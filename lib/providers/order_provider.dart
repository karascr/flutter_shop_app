import 'dart:convert';

import "package:http/http.dart" as http;
import 'package:flutter/foundation.dart';

import '../core/constants.dart';
import 'cart_provider.dart';

class OrderItem {
  String id;
  double amount;
  List<CartItem> products;
  DateTime dateTime;

  OrderItem(
      {required this.id,
      required this.amount,
      required this.products,
      required this.dateTime});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'products': products.map((x) => x.toMap()).toList(),
      'dateTime': dateTime.toIso8601String(),
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      id: map['id'] ?? '',
      amount: map['amount']?.toDouble() ?? 0.0,
      products:
          List<CartItem>.from(map['products']?.map((x) => CartItem.fromMap(x))),
      dateTime: DateTime.parse(map['dateTime']),
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderItem.fromJson(String source) =>
      OrderItem.fromMap(json.decode(source));
}

class OrderProvider with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetProducts() async {
    final url = Uri.https(Constants.dbUrl, Constants.dbOrdersKey + ".json");
    try {
      final response = await http.get(url);
      final data = json.decode(response.body) as Map<String, dynamic>;
      final List<OrderItem> loadedItems = [];
      data.forEach((id, data) {
        OrderItem item = OrderItem.fromMap(data);
        item.id = id;
        loadedItems.add(item);
      });
      _orders = loadedItems;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<bool> addOrder(List<CartItem> cartProducts, double total) async {
    OrderItem item = OrderItem(
      id: "",
      amount: total,
      products: cartProducts,
      dateTime: DateTime.now(),
    );

    final url = Uri.https(Constants.dbUrl, Constants.dbOrdersKey + ".json");
    final response = await http.post(url, body: item.toJson());

    if (response.statusCode == 200) {
      item.id = json.decode(response.body)["name"];
      _orders.insert(
        0,
        item,
      );
      notifyListeners();
      return true;
    }
    return false;
  }
}
