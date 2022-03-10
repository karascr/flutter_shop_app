import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/products_provider.dart';
import 'package:flutter_shop_app/screens/cart/cart_screen.dart';
import 'package:flutter_shop_app/widgets/app_drawer.dart';
import 'package:flutter_shop_app/screens/product/widgets/badge.dart';
import 'package:provider/provider.dart';

import '../../providers/cart.dart';
import 'widgets/products_grid.dart';

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
  bool _isInitialized = false;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    if (!_isInitialized) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<ProductsProvider>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
      _isInitialized = true;
    }
    super.didChangeDependencies();
  }

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
                value: cart.totalItemQuantity.toString(),
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
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ProductsGrid(
                showOnlyFavorites: _showOnlyFavorites,
              ));
  }
}
