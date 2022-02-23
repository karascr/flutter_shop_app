import 'package:flutter/material.dart';
import 'package:flutter_shop_app/screens/cart_screen.dart';
import 'package:flutter_shop_app/widgets/app_drawer.dart';
import 'package:flutter_shop_app/widgets/badge.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../widgets/products_grid.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("MyShop"),
          actions: [
            PopupMenuButton(
              onSelected: (FilterOptions filterOptions) {
                setState(() {
                  switch (filterOptions) {
                    case FilterOptions.Favorites:
                      _showOnlyFavorites = true;
                      break;
                    default:
                      _showOnlyFavorites = false;
                      break;
                  }
                });
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                PopupMenuItem(
                    child: Text("Only Favorites"),
                    value: FilterOptions.Favorites),
                PopupMenuItem(
                    child: Text("Show All"), value: FilterOptions.All),
              ],
            ),
            Consumer<Cart>(
              builder: (_, cart, child) => Badge(
                child: child ?? Container(),
                value: cart.itemCount.toString(),
              ),
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () =>
                    Navigator.of(context).pushNamed(CartScreen.routeName),
              ),
            ),
          ],
        ),
        drawer: AppDrawer(),
        body: ProductsGrid(
          showOnlyFavorites: _showOnlyFavorites,
        ));
  }
}
