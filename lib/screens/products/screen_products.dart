import 'package:flutter/material.dart';
import 'package:app_loja/commom/custom_drawer/custom_drawer.dart';
import 'package:app_loja/models/product_manager.dart';
import 'package:app_loja/models/user_manager.dart';
import 'package:app_loja/screens/products/components/products_list_tile.dart';
import 'package:provider/provider.dart';

import 'components/search_dialogs.dart';

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Consumer<ProductManager>(
          builder: (_, productManager, __) {
            if (productManager.search.isEmpty) {
              return const Text('Produtos');
            } else {
              return LayoutBuilder(builder: (_, constraints) {
                return GestureDetector(
                  onTap: () async {
                    final search = await showDialog<String>(
                        context: context, builder: (_) => SearchDialog());
                    if (search != null) {
                      productManager.search = search;
                    }
                  },
                  child: Container(
                      width: constraints.biggest.width,
                      child: Text(productManager.search)),
                );
              });
            }
          },
        ),
        centerTitle: true,
        actions: <Widget>[
          Consumer<ProductManager>(builder: (_, productManager, __) {
            if (productManager.search.isEmpty) {
              return IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () async {
                    final search = await showDialog<String>(
                        context: context, builder: (_) => SearchDialog());
                    if (search != null) {
                      productManager.search = search;
                    }
                  });
            } else {
              return IconButton(
                icon: Icon(Icons.close),
                onPressed: () async {
                  productManager.search = '';
                },
              );
            }
          }),
          Consumer<UserManager>(
            builder: (_, userManager, __) {
              if (userManager.adminEnabled) {
                return IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      '/edit_product',
                    );
                  },
                );
              } else {
                return Container();
              }
            },
          )
        ],
      ),
      body: Consumer<ProductManager>(builder: (_, productManager, __) {
        final filteredProducts = productManager.filteredProducts;
        return ListView.builder(
            //padding: EdgeInsets.all(8),
            itemCount: filteredProducts.length,
            itemBuilder: (_, index) {
              return ProductListTile(filteredProducts[index]);
            });
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF01579B),
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.of(context).pushNamed('/cart');
        },
        child: Icon(Icons.shopping_cart),
      ),
    );
  }
}
