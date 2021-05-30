import 'package:flutter/material.dart';
import 'package:app_loja/commom/price_card.dart';
import 'package:app_loja/models/cart_manager.dart';
import 'package:app_loja/models/checkout_manager.dart';
import 'package:app_loja/screens/checkout/components/cpf_field.dart';
import 'package:provider/provider.dart';
import 'package:app_loja/screens/checkout/components/credit_card_widget.dart';

class CheckoutScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<CartManager, CheckoutManager>(
      create: (_) => CheckoutManager(),
      update: (_, cartManager, checkoutManager) =>
          checkoutManager..updateCart(cartManager),
      lazy: false,
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: const Text('Pagamento'),
          centerTitle: true,
        ),
        body: Consumer<CheckoutManager>(
          builder: (_, checkoutManager, __) {
            if (checkoutManager.loading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Color(0xFF2661FA)),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      'Processando seu pagamento...',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 16),
                    )
                  ],
                ),
              );
            }
            return Form(
              key: formKey,
              child: ListView(
                children: <Widget>[
                  CreditCardWidget(),
                  CpfField(),
                  PriceCard(
                      buttonText: 'Finalizar Pedido',
                      onPressed: () {
                        if (formKey.currentState.validate()) {
                          formKey.currentState.save();
                          checkoutManager.checkout(onStockFail: (e) {
                            Navigator.of(context).popUntil(
                                (route) => route.settings.name == '/cart');
                          }, onSuccess: (order) {
                            Navigator.of(context).popUntil(
                                (route) => route.settings.name == '/');
                            Navigator.of(context)
                                .pushNamed('/confirmation', arguments: order);
                          });
                        }
                      }),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
