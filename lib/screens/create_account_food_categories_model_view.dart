import 'package:flutter/material.dart';
import 'package:restaurant_order_system/models/restaurant.dart';
import 'package:restaurant_order_system/services/database.dart';

class CreateAccountFoodCategoriesModeView extends ChangeNotifier {
  Database _database = Database();
  String collectionPath = 'emails';

  Future<void> addNewRestaurant(
      {required String email,
      required String password,
      required String restaurantName,
      required Map<String, int> places,
      required List<String> placesList,
      required List<Map<String, List<Map<String, double>>>>
          categoryNameList}) async {
    /// Form alanındaki verileri ile önce bir book objesi oluşturulması
    Restaurant newRestaurant = Restaurant(
      email: email,
      password: password,
      places: places,
      placesList: placesList,
      restaurantName: restaurantName,
      categories: categoryNameList,
    );

    /// bu kitap bilgisini database servisi üzerinden Firestore'a yazacak
    await _database.setRestaurantData(
        collectionPath: collectionPath, restaurantAsMap: newRestaurant.toMap());
  }
}
