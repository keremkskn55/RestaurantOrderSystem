import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:restaurant_order_system/models/order.dart';
import 'package:restaurant_order_system/models/restaurant.dart';
import 'package:restaurant_order_system/services/database.dart';

class AddingOrderModelView extends ChangeNotifier {
  Database _database = Database();
  String collectionPath = 'emails';

  Future<void> updateOrder(String email, List orderInString) {
    return _database.updateDocument('emails', email, orderInString);
  }
}
