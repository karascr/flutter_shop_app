import 'dart:convert';
import 'dart:io';

import "package:http/http.dart" as http;
import 'package:flutter/cupertino.dart';

import '../core/constants.dart';

enum AuthType { Signin, Signup }

class AuthProvider with ChangeNotifier {
  String? _token;
  String? _userID;
  DateTime? _expiryDate;

  bool get isAuth {
    if (token.isNotEmpty)
      return true;
    else
      return false;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token ?? "";
    }
    return "";
  }

  String get userID {
    return _userID ?? "";
  }

  Future<void> authenticate(
      String email, String password, AuthType authTpye) async {
    final url = Uri.parse(authTpye == AuthType.Signin
        ? DbConstants.signinUrl
        : DbConstants.signupUrl);

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {"email": email, "password": password, "returnSecureToken": true},
        ),
      );
      final responseBody = json.decode(response.body);
      if (responseBody["error"] != null) {
        throw HttpException(responseBody["error"]["message"]);
      }
      print("signin succesfull");
      _token = responseBody["idToken"];
      _userID = responseBody["localId"];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseBody["expiresIn"])));
      print(_token);
      print(_userID);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  // Future<void> signup(String email, String password) async {
  //   try {
  //     final url = Uri.parse(DbConstants.signupUrl);
  //     final response = await http.post(
  //       url,
  //       body: json.encode(
  //         {"email": email, "password": password, "returnSecureToken": true},
  //       ),
  //     );
  //     print(json.decode(response.body));
  //   } catch (error) {
  //     print(error);
  //   }
  // }

  // Future<void> signin(String email, String password) async {
  //   try {
  //     final url = Uri.parse(DbConstants.signinUrl);
  //     final response = await http.post(
  //       url,
  //       body: json.encode(
  //         {"email": email, "password": password, "returnSecureToken": true},
  //       ),
  //     );
  //     print(json.decode(response.body));
  //   } catch (error) {
  //     print(error);
  //   }
  // }
}
