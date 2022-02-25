import 'package:flutter/material.dart';
import 'package:flutter_shop_app/screens/cart/cart_screen.dart';
import 'package:flutter_shop_app/screens/order/orders_screen.dart';
import 'package:flutter_shop_app/screens/user/edit_product_screen.dart';
import 'package:flutter_shop_app/screens/user/user_products_screen.dart';
import 'package:provider/provider.dart';

import 'providers/order.dart';
import 'providers/products_provider.dart';
import 'screens/product/product_detail_screen.dart';
import 'screens/product/products_overview_screen.dart';
import '/providers/cart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductsProvider()),
        ChangeNotifierProvider(create: (_) => Cart()),
        ChangeNotifierProvider(create: (_) => Order()),
      ],
      child: MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch(
                primarySwatch: Colors.purple, accentColor: Colors.deepOrange),
            fontFamily: "Lato"),
        home: MyHomePage(),
        routes: {
          ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
          CartScreen.routeName: (context) => CartScreen(),
          OrdersScreen.routeName: (context) => OrdersScreen(),
          UserProductsScreen.routeName: (context) => UserProductsScreen(),
          EditProductScreen.routeName: (context) => EditProductScreen(),
        },
        debugShowCheckedModeBanner: false,
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
