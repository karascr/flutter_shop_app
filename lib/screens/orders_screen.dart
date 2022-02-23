import 'package:flutter/material.dart';
import 'package:flutter_shop_app/widgets/app_drawer.dart';
import 'package:provider/provider.dart';

import '../providers/order.dart' show Order;
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const String routeName = "/orders";

  @override
  Widget build(BuildContext context) {
    final Order order = Provider.of<Order>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("My Orders"),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: order.orders.length,
        itemBuilder: (context, i) => OrderItem(order: order.orders[i]),
      ),
    );
  }
}
