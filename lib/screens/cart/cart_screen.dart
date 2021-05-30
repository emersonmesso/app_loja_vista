import 'package:flutter/material.dart';
import 'package:app_loja/commom/empty_card.dart';
import 'package:app_loja/commom/login_card.dart';
import 'package:app_loja/commom/price_card.dart';
import 'package:app_loja/models/cart_manager.dart';
import 'package:app_loja/screens/cart/componentes/cart_tile.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho'),
      ),
      body: Consumer<CartManager>(
        builder: (_, cartManager, __) {
          if (cartManager.user == null) {
            return LoginCard();
          }

          if (cartManager.items.isEmpty) {
            return EmptyCard(
              iconData: Icons.remove_shopping_cart,
              title: 'Nenhum produto no carrinho!',
            );
          }
          return ListView(
            children: <Widget>[
              Column(
                children: cartManager.items
                    .map((cartProduct) => CartTile(cartProduct))
                    .toList(),
              ),
              PriceCard(
                buttonText: 'Continuar para Entrega',
                onPressed: cartManager.isCartValid
                    ? () {
                        Navigator.of(context).pushNamed('/address');
                      }
                    : null,
              ),
            ],
          );
        },
      ),
    );
  }
}
