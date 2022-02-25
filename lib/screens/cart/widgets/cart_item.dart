import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final double price;
  final int quantity;

  const CartItem(
      {Key? key,
      required this.id,
      required this.title,
      required this.price,
      required this.quantity,
      required this.productId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Dismissible(
          key: ValueKey(id),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            Provider.of<Cart>(context, listen: false).removeItem(productId);
          },
          background: Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            padding: EdgeInsets.only(right: 15),
            color: Theme.of(context).colorScheme.errorContainer,
            child: Icon(
              Icons.delete,
              color: Colors.white,
              size: 32,
            ),
            alignment: Alignment.centerRight,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: ListTile(
              leading: CircleAvatar(child: Text("$quantity x")),
              title: Text(title),
              subtitle: Text("Total: \$${price * quantity}"),
              trailing: Text("\$$price"),
            ),
          ),
        ),
        Divider()
      ],
    );
  }
}
