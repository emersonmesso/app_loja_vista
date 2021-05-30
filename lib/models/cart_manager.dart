import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:app_loja/models/address.dart';
import 'package:app_loja/models/cart_product.dart';
import 'package:app_loja/models/product.dart';
import 'package:app_loja/models/user.dart';
import 'package:app_loja/models/user_manager.dart';
import 'package:http/http.dart' as http;
import 'package:app_loja/models/responseGeolocation.dart';

class CartManager extends ChangeNotifier {
  List<CartProduct> items = [];

  User user;
  Address address;

  num productsPrice = 0.0;
  num deliveryPrice;

  num get totalPrice => productsPrice + (deliveryPrice ?? 0);

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  final Firestore firestore = Firestore.instance;

  void updateUser(UserManager userManager) {
    user = userManager.user;
    productsPrice = 0.0;
    items.clear();
    removeAddress();

    if (user != null) {
      _loadCartItems();
      _loadUserAddress();
    }
  }

  Future<void> _loadCartItems() async {
    final QuerySnapshot cartSnap = await user.cartReference.getDocuments();

    items = cartSnap.documents
        .map((d) => CartProduct.fromDocument(d)..addListener(_onItemUpdate))
        .toList();
  }

  Future<void> _loadUserAddress() async {
    if (user.address != null &&
        await calculateDelivery(user.address.lat, user.address.long)) {
      address = user.address;
      notifyListeners();
    }
  }

  void addToCart(Product product) {
    try {
      final e = items.firstWhere((p) => p.stackable(product));
      e.increment();
    } catch (e) {
      final cartProduct = CartProduct.fromProduct(product);
      cartProduct.addListener(_onItemUpdate);
      items.add(cartProduct);
      user.cartReference
          .add(cartProduct.toCartItemMap())
          .then((doc) => cartProduct.id = doc.documentID);
      _onItemUpdate();
    }
  }

  void removeFromCart(CartProduct cartProduct) {
    items.removeWhere((p) => p.id == cartProduct.id);
    user.cartReference.document(cartProduct.id).delete();
    cartProduct.removeListener(_onItemUpdate);
    notifyListeners();
  }

  void clear() {
    for (final cartProduct in items) {
      user.cartReference.document(cartProduct.id).delete();
    }
    items.clear();
    notifyListeners();
  }

  void _onItemUpdate() {
    productsPrice = 0.0;

    for (int i = 0; i < items.length; i++) {
      final cartProduct = items[i];

      if (cartProduct.quantity == 0) {
        removeFromCart(cartProduct);
        i--;
        continue;
      }
      productsPrice += cartProduct.totalPrice;

      _updateCartProduct(cartProduct);
    }

    notifyListeners();
  }

  void _updateCartProduct(CartProduct cartProduct) {
    if (cartProduct.id != null)
      user.cartReference
          .document(cartProduct.id)
          .updateData(cartProduct.toCartItemMap());
  }

  bool get isCartValid {
    for (final cartProduct in items) {
      if (!cartProduct.hasStock) return false;
    }
    return true;
  }

  bool get isAddressValid => address != null && deliveryPrice != null;

  // ADDRESS

  Future<void> getAddress(String lat, String lng) async {
    loading = true;

    try {
      //final cepAbertoAddress = await cepAbertoService.getAddressFromCep(cep);

      //buscando os dados da API
      var res = await http.get(
          "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=AIzaSyDkHXoj25Qf3Izr07pF0dfyadEDOrIsFJE");
      if (res.statusCode == 200) {
        ResponseGeolocator data =
            ResponseGeolocator.fromJson(json.decode(res.body));
        var dados = data.results[0].addressComponents;
        print("Cidade: ${dados[3].longName}");
        address = Address(
            street: dados[1].longName,
            district: dados[2].longName,
            zipCode: dados[6].longName,
            city: dados[3].longName,
            state: dados[4].longName,
            lat: double.parse(lat),
            long: double.parse(lng));

        loading = false;
      }
    } catch (e) {
      loading = false;
      return Future.error('Endereço Inválido');
    }
  }

  Future<void> setAddress(Address address) async {
    loading = true;
    this.address = address;

    if (await calculateDelivery(address.lat, address.long)) {
      user.setAddress(address);
      loading = false;
    } else {
      loading = false;
      return Future.error('Endereço fora do raio de entrega :(');
    }
  }

  void removeAddress() {
    address = null;
    deliveryPrice = null;
    notifyListeners();
  }

  Future<bool> calculateDelivery(double lat, double long) async {
    final DocumentSnapshot doc = await firestore.document('aux/delivery').get();

    final latStore = doc.data['lat'] as double;
    final longStore = doc.data['long'] as double;

    final base = doc.data['base'] as num;
    final km = doc.data['km'] as num;
    final maxkm = doc.data['maxkm'] as num;

    double dis = Geolocator.distanceBetween(latStore, longStore, lat, long);

    dis /= 5000.0;

    print('Distance $dis');

    if (dis > maxkm) {
      return false;
    }

    deliveryPrice = base + dis * km;
    return true;
  }
}
