import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:app_loja/models/cart_manager.dart';
import 'package:app_loja/models/product.dart';
import 'package:app_loja/models/user_manager.dart';
import 'package:provider/provider.dart';
import 'componentes/sizewidget.dart';

class PageProduct extends StatelessWidget {
  const PageProduct(this.product);

  final Product product;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return ChangeNotifierProvider.value(
        value: product,
        child: Scaffold(
          appBar: AppBar(title: Text(product.name), actions: <Widget>[
            Consumer<UserManager>(
              builder: (_, userManager, __) {
                if (userManager.adminEnabled && !product.deleted) {
                  return IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed(
                          '/edit_product',
                          arguments: product);
                    },
                  );
                } else {
                  return Container();
                }
              },
            )
          ]),
          backgroundColor: Colors.white,
          body: ListView(
            children: <Widget>[
              AspectRatio(
                  aspectRatio: 1,
                  child: Carousel(
                    images: product.images.map((url) {
                      return NetworkImage(url);
                    }).toList(),
                    dotSize: 4,
                    dotSpacing: 15,
                    dotBgColor: Colors.transparent,
                    dotColor: Theme.of(context).primaryColor,
                    autoplay: false,
                  )),
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      product.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'A partir de',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Text(
                      'R\$ ${product.basePrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 8),
                      child: Text('Descrição',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          )),
                    ),
                    Text(
                      product.description,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    if (product.deleted)
                      Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 8),
                        child: Text('Este produto não está mais disponível',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.red)),
                      )
                    else ...[
                      Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 8),
                        child: Text(
                          'Tamanhos',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: product.sizes.map((s) {
                          return SizeWidget(size: s);
                        }).toList(),
                      ),
                    ],
                    const SizedBox(
                      height: 35,
                    ),
                    if (product.hasStock)
                      Consumer2<UserManager, Product>(
                        builder: (_, userManager, product, __) {
                          return SizedBox(
                            height: 50,
                            child: RaisedButton(
                              onPressed: product.selectedSize != null
                                  ? () {
                                      if (userManager.isLoggedIn) {
                                        context
                                            .read<CartManager>()
                                            .addToCart(product);
                                        Navigator.of(context)
                                            .pushNamed('/cart');
                                      } else {
                                        Navigator.of(context)
                                            .pushNamed('/login');
                                      }
                                    }
                                  : null,
                              color: primaryColor,
                              textColor: Colors.white,
                              child: Text(
                                userManager.isLoggedIn
                                    ? 'Adicionar ao carrinho'
                                    : 'Entre para comprar',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          );
                        },
                      )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
