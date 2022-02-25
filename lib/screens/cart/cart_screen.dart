import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cart.dart' show Cart;
import '../../providers/order.dart';
import 'widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const String routeName = "/cart";
  @override
  Widget build(BuildContext context) {
    final Cart cart = Provider.of<Cart>(context);
    final cartItems = cart.items.values.toList();
    final cartItemKeys = cart.items.keys.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              "Total",
              style: TextStyle(fontSize: 20),
            ),
            Chip(
              label: Text(
                "\$${cart.totalAmount}",
                style: TextStyle(fontSize: 18),
              ),
            )
          ]),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: cart.itemCount,
            itemBuilder: (context, i) => CartItem(
                id: cartItems[i].id,
                productId: cartItemKeys[i],
                price: cartItems[i].price,
                quantity: cartItems[i].quantity,
                title: cartItems[i].title),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                Provider.of<Order>(context, listen: false)
                    .addOrder(cartItems, cart.totalAmount);
                cart.clear();
              },
              child: Text(
                "ORDER NOW",
                style: TextStyle(fontSize: 18),
              ),
            )
          ],
        ),
        SizedBox(height: 10),
      ]),
    );
  }
}
