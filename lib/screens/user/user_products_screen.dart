import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/app_drawer.dart';
import 'edit_product_screen.dart';
import 'widgets/user_product_item.dart';
import '/providers/products_provider.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () =>
                Navigator.of(context).pushNamed(EditProductScreen.routeName),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Body(),
    );
  }
}

class Body extends StatefulWidget {
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late ProductsProvider productsProvider =
      Provider.of<ProductsProvider>(context, listen: false);

  Future<void> _refreshProducts(BuildContext context) async {
    await productsProvider.fetchAndSetProducts(filterByUser: true);
  }

  @override
  Widget build(BuildContext context) {
    print("dsfsfd");
    return FutureBuilder(
      future: _refreshProducts(context),
      builder: (BuildContext ctx, AsyncSnapshot<dynamic> snapshot) =>
          snapshot.connectionState == ConnectionState.waiting
              ? Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: () => _refreshProducts(context),
                  child: Consumer<ProductsProvider>(
                    builder: (context, value, _) => Padding(
                      padding: EdgeInsets.all(8),
                      child: ListView.builder(
                        itemCount: productsProvider.items.length,
                        itemBuilder: (_, i) => Column(
                          children: [
                            UserProductItem(
                              productsProvider.items[i].id,
                              productsProvider.items[i].title,
                              productsProvider.items[i].imageUrl,
                            ),
                            Divider(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
    );
  }
}
