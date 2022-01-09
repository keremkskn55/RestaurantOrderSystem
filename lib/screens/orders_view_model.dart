import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurant_order_system/services/database.dart';

class OrdersViewModel {
  String collectionPath = 'emails';
  Database _database = Database();

  Stream<QuerySnapshot> getRestaurantList() {
    print('Using...');

    return _database.getRestaurantListFromApi(collectionPath);
  }

  Future<void> updateOrder(String email, List orderInString) {
    return _database.updateDocument('emails', email, orderInString);
  }
}
