import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/product.dart';
import 'package:http/http.dart' as http;

import '../core/constants.dart';
import 'product.dart';

class ProductsProvider with ChangeNotifier {
  final String authToken;
  final String userID;

  ProductsProvider(this.authToken, this.userID, this._items);

  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((i) => i.isFavorite).toList();
  }

  Future<void> fetchAndSetProducts({bool filterByUser = false}) async {
    var filterMap = {
      "orderBy": "\"creatorID\"",
      "equalTo": "\"$userID\"",
    };
    final url = Uri.https(
      DbConstants.dbUrl,
      DbConstants.dbProductsKey + ".json",
      {
        "auth": authToken,
      }..addEntries(
          filterByUser
              ? Iterable.generate(filterMap.length, (i) {
                  return MapEntry(filterMap.keys.elementAt(i),
                      filterMap.values.elementAt(i));
                })
              : {},
        ),
    );

    final favoritesUrl = Uri.https(
        DbConstants.dbUrl,
        DbConstants.dbUserFavoritesKey + "/$userID" + ".json",
        {"auth": authToken});

    try {
      final response = await http.get(url);
      final favoritesResponse = await http.get(favoritesUrl);

      if (response.statusCode != 200 || favoritesResponse.statusCode != 200)
        throw HttpException(response.body + favoritesResponse.body);

      final data = json.decode(response.body) as Map<String, dynamic>;
      final favoritesData =
          json.decode(favoritesResponse.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      data.forEach((id, data) {
        Product prod = Product.fromMap(data);
        prod.isFavorite =
            favoritesData[id] == null ? false : favoritesData[id] ?? false;
        prod.id = id;
        loadedProducts.add(prod);
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<bool> addProduct(Product p) async {
    final url = Uri.https(
      DbConstants.dbUrl,
      DbConstants.dbProductsKey + ".json",
      {"auth": authToken},
    );
    final response = await http.post(
      url,
      body: json.encode(
        p.toMap()..putIfAbsent("creatorID", () => userID),
      ),
    );

    if (response.statusCode == 200) {
      // print(json.decode(response.body));
      // print(json.decode(response.body)["name"]);
      p.id = json.decode(response.body)["name"];
      _items.add(p);
      // _items.insert(0, newProduct);
      notifyListeners();
      return true;
    }

    return false;
  }

  Future<bool> updateProduct(Product p) async {
    final url = Uri.https(
        DbConstants.dbUrl,
        DbConstants.dbProductsKey +
            "/${p.id}" +
            ".json" +
            "?auth=" +
            authToken);
    final response = await http.patch(url, body: p.toJson());

    if (response.statusCode == 200) {
      final index = _items.indexWhere((element) => element.id == p.id);
      if (index >= 0) {
        _items[index] = p;
        notifyListeners();
      }
      return true;
    }

    return false;
  }

  Future<bool> deleteProduct(String id) async {
    final url = Uri.https(
      DbConstants.dbUrl,
      DbConstants.dbProductsKey + "/${id}" + ".json",
      {"auth": authToken},
    );
    final result = await http.delete(url);

    if (result.statusCode == 200) {
      _items.removeWhere((element) => element.id == id);
      notifyListeners();
      return true;
    }
    return false;
  }

  Product getById(String id) {
    return _items.firstWhere((p) => p.id == id);
  }
}
