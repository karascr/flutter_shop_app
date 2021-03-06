import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../core/constants.dart';

class Product with ChangeNotifier {
  String id;
  String title;
  String description;
  String imageUrl;
  double price;
  late bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    this.isFavorite = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'isFavorite': isFavorite,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      isFavorite: map['isFavorite'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));

  Future<void> toggleFavoriteStatus(String token, String userID) async {
    if (userID.isEmpty) return;
    final url = Uri.https(
        DbConstants.dbUrl,
        DbConstants.dbUserFavoritesKey + "/$userID/$id" + ".json",
        {"auth": token});
    final response = await http.put(url, body: json.encode(!isFavorite));
    print(response.body);
    if (response.statusCode == 200) {
      isFavorite = !isFavorite;
      notifyListeners();
    }
  }

  @override
  String toString() {
    return 'Product(id: $id, title: $title, description: $description, imageUrl: $imageUrl, price: $price, isFavorite: $isFavorite)';
  }
}
