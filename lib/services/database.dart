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
}
