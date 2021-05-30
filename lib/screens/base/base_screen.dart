import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_loja/commom/custom_drawer/custom_drawer.dart';
//import 'package:app_loja/commom/custom_drawer/custom_drawer.dart';
import 'package:app_loja/models/page_manager.dart';
import 'package:app_loja/models/user_manager.dart';
import 'package:app_loja/screens/admin_orders/admin_orders_screen.dart';
import 'package:app_loja/screens/admins.dart/admins_users.dart';
import 'package:app_loja/screens/home/home.dart';
import 'package:app_loja/screens/orders/orders_screen.dart';
import 'package:app_loja/screens/products/screen_products.dart';
import 'package:provider/provider.dart';

class BaseScreen extends StatefulWidget {
  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final PageController pageController = PageController();

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
        create: (_) => PageManager(pageController),
        child: Consumer<UserManager>(
          builder: (_, userManager, __) {
            return PageView(
              controller: pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: <Widget>[
                HomeScreen(),
                ProductsScreen(),
                OrdersScreen(),
                Scaffold(
                  drawer: CustomDrawer(),
                  appBar: AppBar(
                    title: const Text('Minha Conta'),
                  ),
                ),
                if (userManager.adminEnabled) ...[
                  AdminUsersScreen(),
                  AdminOrdersScreen(),
                ]
              ],
            );
          },
        ));
  }
}
