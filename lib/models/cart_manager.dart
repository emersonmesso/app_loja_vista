import 'dart:convert';

import 'package:app_loja/models/responseGeolocation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:app_loja/models/address.dart';
import 'package:app_loja/models/cart_product.dart';
import 'package:app_loja/models/product.dart';
import 'package:app_loja/models/user.dart';
import 'package:app_loja/models/user_manager.dart';
import 'package:http/http.dart' as http;
import 'package:app_loja/services/cepaberto_service.dart';

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
      final rest = await http.get(
          'http://api.positionstack.com/v1/reverse?access_key=e86ea61000774a648f4e9c03e682c6d9&query=$lat,$lng');

      if (rest.statusCode == 200) {
        var dados = ResponseGeolocator.fromJson(json.decode(rest.body));
        var data = dados.data[0];
        address = Address(
            street: data.name,
            district: data.street,
            zipCode: data.postalCode,
            city: data.county,
            state: data.regionCode,
            lat: data.latitude,
            long: data.longitude);
      }
      loading = false;
    } catch (e) {
      loading = false;
      return Future.error('Localização não encontrada!');
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
    //buscando os valores das regiões
    final norte = doc.data['norte'] as num;
    final nordeste = doc.data['nordeste'] as num;
    final centro = doc.data['centro'] as num;
    final sudeste = doc.data['sudeste'] as num;
    final sul = doc.data['sul'] as num;

    if (address != null) {
      final estadoUser = address.state;
      //verificando o estado do usuário
      switch (estadoUser) {
        case 'RR':
        case 'AP':
        case 'AM':
        case 'PA':
        case 'AC':
        case 'RO':
        case 'TO':
          print("Norte");
          deliveryPrice = norte;
          break;
        case 'PE':
        case 'MA':
        case 'PI':
        case 'CE':
        case 'RN':
        case 'PB':
        case 'AL':
        case 'SE':
        case 'BA':
          print("Nordeste");
          deliveryPrice = nordeste;
          break;
        case 'MT':
        case 'GO':
        case 'DF':
        case 'MS':
          print("Centro");
          deliveryPrice = centro;
          break;
        case 'SP':
        case 'MG':
        case 'ES':
        case 'RJ':
          print("Sudeste");
          deliveryPrice = sudeste;
          break;
        case 'RS':
        case 'SC':
        case 'PR':
          print("Sul");
          deliveryPrice = sul;
          break;
        default:
          deliveryPrice = 0;
      }
    } else {
      deliveryPrice = 0;
    }

    /*

    final latStore = doc.data['lat'] as double;
    final longStore = doc.data['long'] as double;

    final base = doc.data['base'] as num;
    final km = doc.data['km'] as num;
    final maxkm = doc.data['maxkm'] as num;

    double dis = Geolocator.distanceBetween(latStore, longStore, lat, long);

    dis /= 5000.0;
    

    debugPrint('Distance $dis');

    if (dis > maxkm) {
      return false;
    }
    */
    return true;
  }
}
