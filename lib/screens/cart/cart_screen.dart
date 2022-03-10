import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/cart_provider.dart';
import 'package:provider/provider.dart';

import '../../providers/order_provider.dart';
import 'widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const String routeName = "/cart";
  @override
  Widget build(BuildContext context) {
    final CartProvider cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.items.values.toList();
    final cartItemKeys = cartProvider.items.keys.toList();

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
                "\$${cartProvider.totalAmount}",
                style: TextStyle(fontSize: 18),
              ),
            )
          ]),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: cartProvider.itemCount,
            itemBuilder: (context, i) => CartItemWidget(
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
            OrderButton(cartItems: cartItems, cart: cartProvider),
          ],
        ),
        SizedBox(height: 10),
      ]),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cartItems,
    required this.cart,
  }) : super(key: key);

  final List<CartItem> cartItems;
  final CartProvider cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? CircularProgressIndicator()
        : TextButton(
            onPressed: () async {
              if (widget.cartItems.length == 0) return;

              setState(() {
                _isLoading = true;
              });

              final result =
                  await Provider.of<OrderProvider>(context, listen: false)
                      .addOrder(widget.cartItems, widget.cart.totalAmount);
              String snackbarMessage = "Successful!";
              if (result)
                widget.cart.clear();
              else
                snackbarMessage = "Order can not created.";
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(snackbarMessage),
                ),
              );
              setState(() {
                _isLoading = false;
              });
            },
            child: Text(
              "ORDER NOW",
              style: TextStyle(
                fontSize: 18,
                color: widget.cartItems.length > 0 ? null : Colors.grey,
              ),
            ),
          );
  }
}
