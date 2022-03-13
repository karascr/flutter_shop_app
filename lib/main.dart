import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/auth_provider.dart';
import 'package:flutter_shop_app/screens/cart/cart_screen.dart';
import 'package:flutter_shop_app/screens/login/login_screen.dart';
import 'package:flutter_shop_app/screens/order/orders_screen.dart';
import 'package:flutter_shop_app/screens/splash_screen.dart';
import 'package:flutter_shop_app/screens/user/edit_product_screen.dart';
import 'package:flutter_shop_app/screens/user/user_products_screen.dart';
import 'package:provider/provider.dart';

import 'providers/order_provider.dart';
import 'providers/products_provider.dart';
import 'screens/product/product_detail_screen.dart';
import 'screens/product/products_overview_screen.dart';
import 'providers/cart_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // AuthProvider
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // CartProvider
        ChangeNotifierProvider(create: (_) => CartProvider()),
        // ProductsProvider
        ChangeNotifierProxyProvider(
          create: (_) => ProductsProvider("", "", []),
          update: (BuildContext ctx, AuthProvider authProvider,
                  ProductsProvider? previous) =>
              ProductsProvider(
                  authProvider.token, authProvider.userID, previous!.items),
        ),
        // OrderProvider
        ChangeNotifierProxyProvider(
          create: (_) => OrderProvider("", "", []),
          update: (BuildContext ctx, AuthProvider authProvider,
                  OrderProvider? previous) =>
              OrderProvider(
                  authProvider.token, authProvider.userID, previous!.orders),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, authProvider, _) => MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
              colorScheme: ColorScheme.fromSwatch(
                  primarySwatch: Colors.purple, accentColor: Colors.deepOrange),
              fontFamily: "Lato"),
          home: authProvider.isAuth
              ? ProductOverviewScreen()
              : FutureBuilder(
                  future: authProvider.tryAutoSignin(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    return snapshot.connectionState == ConnectionState.waiting
                        ? SplashScreen()
                        : snapshot.data == true
                            ? ProductOverviewScreen()
                            : LoginScreen();
                  },
                ),
          routes: {
            LoginScreen.routeName: (context) => LoginScreen(),
            ProductOverviewScreen.routeName: (context) =>
                ProductOverviewScreen(),
            ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
            CartScreen.routeName: (context) => CartScreen(),
            OrdersScreen.routeName: (context) => OrdersScreen(),
            UserProductsScreen.routeName: (context) => UserProductsScreen(),
            EditProductScreen.routeName: (context) => EditProductScreen(),
          },
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProductOverviewScreen();
  }
}
