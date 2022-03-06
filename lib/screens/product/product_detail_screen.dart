import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/product.dart';
import '/providers/products_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const String routeName = "/product-detail";

  @override
  Widget build(BuildContext context) {
    final String id = ModalRoute.of(context)?.settings.arguments as String;
    Product product =
        Provider.of<ProductsProvider>(context, listen: false).getById(id);
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 300,
              child: Image.network(product.imageUrl),
            ),
            SizedBox(height: 10),
            Text(
              "\$${product.price}",
              style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                child: Text(
                  product.description,
                  textAlign: TextAlign.center,
                  softWrap: true,
                )),
          ],
        ),
      ),
    );
  }
}
