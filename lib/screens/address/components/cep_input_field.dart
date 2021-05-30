import 'package:flutter/material.dart';
import 'package:app_loja/commom/custom_drawer/custom_icon_button.dart';
import 'package:app_loja/models/address.dart';
import 'package:app_loja/models/cart_manager.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class CepInputField extends StatefulWidget {
  const CepInputField(this.address);

  final Address address;
  @override
  _CepInputFieldState createState() => _CepInputFieldState();
}

class _CepInputFieldState extends State<CepInputField> {
  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  @override
  Widget build(BuildContext context) {
    final cartManager = context.watch<CartManager>();
    final primaryColor = Theme.of(context).primaryColor;

    if (widget.address.zipCode == null)
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (cartManager.loading)
            LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation(primaryColor),
              backgroundColor: Colors.transparent,
            ),
          RaisedButton(
            onPressed: !cartManager.loading
                ? () async {
                    //busvando a localização do usuário
                    _getLocationUser();
                    //enviando os dados
                  }
                : null,
            textColor: Colors.white,
            color: primaryColor,
            disabledColor: primaryColor.withAlpha(100),
            child: const Text('Buscar Localização'),
          ),
        ],
      );
    else
      return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'CEP: ${widget.address.zipCode}',
                  style: TextStyle(
                      color: primaryColor, fontWeight: FontWeight.w600),
                ),
              ),
              CustomIconButton(
                iconData: Icons.edit,
                color: primaryColor,
                size: 20,
                onTap: () {
                  context.read<CartManager>().removeAddress();
                },
              ),
            ],
          ));
  }

  void _getLocationUser() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    try {
      await context.read<CartManager>().getAddress(
          _locationData.latitude.toString(),
          _locationData.longitude.toString());
    } catch (e) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('$e'),
        backgroundColor: Colors.red,
      ));
    }
  }
}
