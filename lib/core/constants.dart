class DbConstants {
  static const String dbUrl =
      "flutter-shop-app-e63b6-default-rtdb.europe-west1.firebasedatabase.app";
  static const String signupUrl =
      "https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=" +
          webApiKey;
  static const String signinUrl =
      "https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=" +
          webApiKey;
  static const String webApiKey = "AIzaSyBOOXdQp0BE9PpTO5hiaOMzL9vnX7gwSqw";
  static const String dbProductsKey = "products";
  static const String dbUserFavoritesKey = "userFavorites";
  static const String dbOrdersKey = "orders";
}
