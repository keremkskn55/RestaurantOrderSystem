import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurant_order_system/models/restaurant.dart';

class Database {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Set Restaurant
  Future<void> setRestaurantData(
      {required String collectionPath,
      required Map<String, dynamic> restaurantAsMap}) async {
    await _firestore
        .collection(collectionPath)
        .doc(Restaurant.fromMap(restaurantAsMap).email)
        .set(restaurantAsMap);
  }

  /// Get Restaurant
  Stream<QuerySnapshot> getRestaurantListFromApi(String referencePath) {
    print('in Database');
    return _firestore.collection(referencePath).snapshots();
  }

  /// Updating Document
  Future<void> updateDocument(
      String collectionPath, String documentPath, List orderListData) {
    print('orderData $orderListData');
    return _firestore
        .collection(collectionPath)
        .doc(documentPath)
        .update({'orders': orderListData})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }
}
