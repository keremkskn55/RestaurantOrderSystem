import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:restaurant_order_system/models/order.dart';
import 'package:restaurant_order_system/models/restaurant.dart';
import 'package:restaurant_order_system/screens/orders_view_model.dart';
import 'package:restaurant_order_system/services/auth.dart';

class OrdersView extends StatefulWidget {
  const OrdersView({Key? key}) : super(key: key);

  @override
  _OrdersViewState createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder<QuerySnapshot>(
        stream: OrdersViewModel().getRestaurantList(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            // Auth().signOut();
            return Center(child: Text('There is an error.'));
          } else if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          List<Restaurant> restaurants = [];

          restaurants = snapshot.data!.docs.map((doc) {
            return Restaurant.fromMap(doc.data() as Map<String, dynamic>);
          }).toList();

          String? currentEmailAddress = Auth().currentEmailAddress();

          if (restaurants == []) {
            return Center(
              child: Text('There is no restaurant.'),
            );
          }
          Restaurant currentRestaurant = restaurants
              .where((element) => element.email == currentEmailAddress)
              .toList()[0];

          List<Order> realOrderList = currentRestaurant.orders
              .map((order) => Order.fromMap(jsonDecode(order)))
              .toList();

          List<Order> currentOrderList = [];
          List<Order> oldOrderList = [];

          print(DateFormat('y/MM/dd').format(DateTime.now()));

          for (Order order in realOrderList) {
            print(order.date.split(' ')[0]);
            if (order.date.split(' ')[0] ==
                DateFormat('y/MM/dd').format(DateTime.now())) {
              if (order.isFinished) {
                oldOrderList.add(order);
              } else {
                currentOrderList.add(order);
              }
            }
          }

          return Container(
            width: size.width,
            height: size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  // Colors.black,
                  Colors.black.withOpacity(0.25),
                  Colors.white,
                ],
              ),
            ),
            child: DefaultTabController(
              initialIndex: 0,
              length: 2,
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  backgroundColor: Colors.grey,
                  title: Text(
                      'Orders ${DateFormat('dd/MM/y').format(DateTime.now())}'),
                  bottom: const TabBar(
                    indicatorColor: Colors.white,
                    tabs: <Widget>[
                      Tab(
                        icon: Icon(Icons.restaurant),
                        child: Text(
                          'Current',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Tab(
                        icon: Icon(Icons.restaurant_menu),
                        child: Text(
                          'Old',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                body: TabBarView(
                  children: <Widget>[
                    todaysOrderMethod(currentOrderList),
                    todaysOrderMethod(oldOrderList),
                  ],
                ),
              ),
            ),
          );
        });
  }

  ListView todaysOrderMethod(List<Order> currentOrderList) {
    return ListView.builder(
      itemCount: currentOrderList.length,
      itemBuilder: (context, index) {
        int lengthOfFood = 0;
        List<Map<String, dynamic>> ordersInCurrentOrder = currentOrderList[
                index]
            .currentOrders
            .map((foodOrder) => jsonDecode(foodOrder) as Map<String, dynamic>)
            .toList();

        for (var orderInCurrentOrder in ordersInCurrentOrder) {
          int tempLength = orderInCurrentOrder['food'].length;
          lengthOfFood += tempLength;
        }

        print('lengthOfFood: $lengthOfFood');

        return Container(
          margin: EdgeInsets.all(8),
          width: 50,
          height: 50.0 * (lengthOfFood + 1),
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 50,
                child: Center(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        '${currentOrderList[index].placeNum} ${currentOrderList[index].tableNum}. Table',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 50.0 * (lengthOfFood),
                child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: ordersInCurrentOrder.length,
                    itemBuilder: (context, index2) {
                      List<dynamic> foodOrdersInOrdersInCurrentOrder =
                          ordersInCurrentOrder[index2]['food'];
                      print(foodOrdersInOrdersInCurrentOrder);
                      return Container(
                        height: 50.0 * foodOrdersInOrdersInCurrentOrder.length,
                        decoration: BoxDecoration(
                          color: ordersInCurrentOrder[index2]['isServed'][0]
                                      ['isServed'] ==
                                  -1
                              ? Colors.yellow.withOpacity(0.5)
                              : Colors.green,
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: foodOrdersInOrdersInCurrentOrder.length,
                          itemBuilder: (context, index3) {
                            String foodName = '';
                            for (var food
                                in foodOrdersInOrdersInCurrentOrder[index3]
                                    .keys) {
                              if (food != 'amount') {
                                foodName = food;
                                break;
                              }
                            }
                            return Container(
                              height: 50,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Text(
                                    '${foodOrdersInOrdersInCurrentOrder[index3]['amount'].round()}',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Text(
                                    '${foodName}',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    }),
              ),
            ],
          ),
        );
      },
    );
  }
}
