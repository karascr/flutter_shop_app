import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/auth_provider.dart';
import 'package:flutter_shop_app/screens/order/orders_screen.dart';
import 'package:flutter_shop_app/screens/product/products_overview_screen.dart';
import 'package:flutter_shop_app/screens/user/user_products_screen.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text("Welcome!"),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text("Shop"),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(ProductOverviewScreen.routeName),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text("Orders"),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(OrdersScreen.routeName),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text("Manage Products"),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(UserProductsScreen.routeName),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("Logout"),
            onTap: () =>
                Provider.of<AuthProvider>(context, listen: false).signout(),
          ),
        ],
      ),
    );
  }
}
