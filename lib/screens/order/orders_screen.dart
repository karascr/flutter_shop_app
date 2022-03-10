import 'package:flutter/material.dart';
import 'package:flutter_shop_app/screens/order/widgets/order_item.dart';
import 'package:provider/provider.dart';

import '../../providers/order_provider.dart';
import '/widgets/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const String routeName = "/orders";

  @override
  Widget build(BuildContext context) {
    OrderProvider orderProvider =
        Provider.of<OrderProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Orders"),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: orderProvider.fetchAndSetProducts(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          else {
            if (!snapshot.hasError) {
              return ListView.builder(
                  itemCount: orderProvider.orders.length,
                  itemBuilder: (ctx, i) =>
                      OrderItemWidget(order: orderProvider.orders[i]));
            } else {
              return const Center(child: Text("sads"));
            }
          }
        },
      ),
    );
  }
}
