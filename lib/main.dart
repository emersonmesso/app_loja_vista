import 'package:cloud_functions/cloud_functions.dart';
import 'package:correios_frete/correios_frete.dart';
import 'package:flutter/material.dart';
import 'package:app_loja/models/admin_orders_manager.dart';
import 'package:app_loja/models/admin_users.dart';
import 'package:app_loja/models/cart_manager.dart';
import 'package:app_loja/models/home_manager.dart';
import 'package:app_loja/models/order.dart';
import 'package:app_loja/models/orders_manager.dart';
import 'package:app_loja/models/product.dart';
import 'package:app_loja/models/product_manager.dart';
import 'package:app_loja/models/user_manager.dart';
import 'package:app_loja/screens/address/address_screen.dart';
import 'package:app_loja/screens/screen_signup/signup.dart';
import 'package:app_loja/screens/base/base_screen.dart';
import 'package:app_loja/screens/cart/cart_screen.dart';
import 'package:app_loja/screens/checkout/checkout_screen.dart';
import 'package:app_loja/screens/confirmation/confirmation_screen.dart';
import 'package:app_loja/screens/edit_product/edit_product.dart';
import 'package:app_loja/screens/login/login_screen.dart';
import 'package:app_loja/screens/page_product/pageproduct.dart';
import 'package:app_loja/screens/select_product/select_product_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(MyApp());

  final response = await CloudFunctions.instance
      .getHttpsCallable(functionName: 'helloWorld')
      .call();
  print(response.data);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => ProductManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => HomeManager(),
          lazy: false,
        ),
        ChangeNotifierProxyProvider<UserManager, CartManager>(
          create: (_) => CartManager(),
          lazy: false,
          update: (_, userManager, cartManager) =>
              cartManager..updateUser(userManager),
        ),
        ChangeNotifierProxyProvider<UserManager, OrdersManager>(
          create: (_) => OrdersManager(),
          lazy: false,
          update: (_, userManager, ordersManager) =>
              ordersManager..updateUser(userManager.user),
        ),
        ChangeNotifierProxyProvider<UserManager, AdminUsersManager>(
          create: (_) => AdminUsersManager(),
          lazy: false,
          update: (_, userManager, adminUsersManager) =>
              adminUsersManager..updateUser(userManager),
        ),
        ChangeNotifierProxyProvider<UserManager, AdminOrdersManager>(
          create: (_) => AdminOrdersManager(),
          lazy: false,
          update: (_, userManager, adminOrdersManager) => adminOrdersManager
            ..updateAdmin(adminEnabled: userManager.adminEnabled),
        )
      ],
      child: MaterialApp(
        title: 'Vista Tecnologia',
        debugShowCheckedModeBanner: false,
        /*theme: ThemeData(
          primaryColor: const Color.fromARGB(255, 173, 216, 230),
          scaffoldBackgroundColor: const Color.fromARGB(255, 173, 216, 230),
          appBarTheme: const AppBarTheme(elevation: 0),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),*/
        theme: ThemeData(
          primaryColor: Color(0xFF01579B),
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(elevation: 0),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        //initialRoute: '/base',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/login':
              return MaterialPageRoute(builder: (_) => LoginScreen());
            case '/signup':
              return MaterialPageRoute(builder: (_) => SignUpScreen());
            case '/product':
              return MaterialPageRoute(
                  builder: (_) => PageProduct(settings.arguments as Product));
            case '/cart':
              return MaterialPageRoute(
                  builder: (_) => CartScreen(), settings: settings);
            case '/address':
              return MaterialPageRoute(builder: (_) => AddressScreen());
            case '/checkout':
              return MaterialPageRoute(builder: (_) => CheckoutScreen());
            case '/edit_product':
              return MaterialPageRoute(
                  builder: (_) =>
                      EditProductScreen(settings.arguments as Product));
            case '/select_product':
              return MaterialPageRoute(builder: (_) => SelectProductScreen());
            case '/confirmation':
              return MaterialPageRoute(
                  builder: (_) =>
                      ConfirmationScreen(settings.arguments as Order));
            case '/':
            default:
              return MaterialPageRoute(
                  builder: (_) => BaseScreen(), settings: settings);
          }
        },
      ),
    );
  }
}
