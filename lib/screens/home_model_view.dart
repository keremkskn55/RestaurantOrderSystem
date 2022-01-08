import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_order_system/models/restaurant.dart';
import 'package:restaurant_order_system/services/database.dart';

class HomeModelView extends ChangeNotifier {
  String collectionPath = 'emails';
  Database _database = Database();

  Stream<QuerySnapshot> getRestaurantList() {
    print('Using...');

    return _database.getRestaurantListFromApi(collectionPath);
  }

  Future<void> updateOrder(String email, List orderInString) {
    return _database.updateDocument('emails', email, orderInString);
  }

  // Stream<List<Restaurant>> getRestaurantList() {
  //
  //   /// stream<QuerySnapshot> --> Stream<List<DocumentSnapshot>>
  //   Stream<List<DocumentSnapshot>> streamListDocument = _database
  //       .getRestaurantListFromApi(collectionPath)
  //       .map((querySnapshot) => querySnapshot.docs);
  //
  //   ///Stream<List<DocumentSnapshot>> --> Stream<List<Book>>
  //   Stream<List<Restaurant>> streamListRestaurant = streamListDocument.map(
  //       (listOfDocSnap) => listOfDocSnap
  //           .map((docSnap) => Restaurant.fromMap(docSnap.data() as Map))
  //           .toList());
  //
  //   return streamListRestaurant;
  // }
}
