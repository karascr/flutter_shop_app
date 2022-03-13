import 'dart:async';
import 'dart:convert';
import 'dart:io';

import "package:http/http.dart" as http;
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants.dart';

enum AuthType { Signin, Signup }

class AuthProvider with ChangeNotifier {
  String? _token;
  String? _userID;
  DateTime? _expiryDate;
  Timer? _authTimer;

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
      // print(_token);
      // print(_userID);

      _autoSignout();
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", _token ?? "");
      await prefs.setString("userID", _userID ?? "");
      await prefs.setString("expiryDate", _expiryDate!.toIso8601String());
    } catch (error) {
      throw error;
    }
  }

  Future<bool> tryAutoSignin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("token") ||
        !prefs.containsKey("userID") ||
        !prefs.containsKey("expiryDate")) return false;

    final DateTime expiryDate =
        DateTime.tryParse(prefs.getString("expiryDate") ?? "") ??
            DateTime.now();

    if (expiryDate.isBefore(DateTime.now())) return false;

    _token = prefs.getString("token");
    _userID = prefs.getString("userID");
    _expiryDate = expiryDate;

    notifyListeners();
    _autoSignout();

    return true;
  }

  void signout() async {
    if (_authTimer != null) _authTimer!.cancel();
    _token = null;
    _userID = null;
    _expiryDate = null;

    final prefs = await SharedPreferences.getInstance();
    prefs.remove("token");
    prefs.remove("userID");
    prefs.remove("expiryDate");

    notifyListeners();
  }

  void _autoSignout() {
    if (_authTimer != null) _authTimer!.cancel();
    final int timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    Timer(Duration(seconds: timeToExpiry), signout);
  }
}
