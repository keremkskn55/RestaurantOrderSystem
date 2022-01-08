import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_order_system/models/order.dart';
import 'package:restaurant_order_system/models/restaurant.dart';
import 'package:restaurant_order_system/screens/adding_order_view.dart';
import 'package:restaurant_order_system/services/auth.dart';

import 'home_model_view.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String currentPlace = '1. Place';
  late int currentPlaceTableNum;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ChangeNotifierProvider<HomeModelView>(
      create: (_) => HomeModelView(),
      builder: (context, child) => StreamBuilder<QuerySnapshot>(
          stream: Provider.of<HomeModelView>(context, listen: false)
              .getRestaurantList(),
          builder: (context, snapshot) {
            print(snapshot.hasError);
            print(Auth().currentEmailAddress());
            if (snapshot.hasError) {
              // Auth().signOut();
              return Center(child: Text('There is an error.'));
            } else {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                print('there is no error');

                // Auth().signOut();
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

                currentPlaceTableNum = currentRestaurant.places[currentPlace]!;

                List<Map<String, dynamic>> foodCategory = currentRestaurant
                    .categories
                    .map((category) =>
                        jsonDecode(category) as Map<String, dynamic>)
                    .toList();
                // print(foodCategory[0]['Drinks'][0]['Cola']);

                List<Order> realOrderList = currentRestaurant.orders
                    .map((order) => Order.fromMap(jsonDecode(order)))
                    .toList();

                List<Order> orderList = [];

                for (Order order in realOrderList) {
                  if (order.isFinished) continue;
                  orderList.add(order);
                  print('${order.placeNum}Place ${order.tableNum}Table...');
                  print(order.currentOrders);
                }

                return SafeArea(
                  child: Scaffold(
                    body: Container(
                      width: size.width,
                      height: size.height,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black,
                            Colors.black.withOpacity(0.25),
                            Colors.white,
                          ],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          /// Top part of the screen
                          Expanded(
                            child: Column(
                              children: [
                                /// Settings and orders
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    /// Settings
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          Auth().signOut();
                                        });
                                      },
                                      child: Container(
                                        width: 100,
                                        height: 40,
                                        margin:
                                            EdgeInsets.only(top: 4, left: 4),
                                        decoration: BoxDecoration(
                                          color: Color(0xFF5E5E5E),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Icon(
                                              Icons.logout,
                                              color: Colors.white,
                                            ),
                                            Text(
                                              'Logout',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    /// Orders
                                    GestureDetector(
                                      child: Container(
                                        width: 100,
                                        height: 40,
                                        margin:
                                            EdgeInsets.only(top: 4, left: 4),
                                        decoration: BoxDecoration(
                                          color: Color(0xFF5E5E5E),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Icon(
                                              Icons.restaurant_menu,
                                              color: Colors.white,
                                            ),
                                            Text(
                                              'Orders',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                /// Name of the restaurant
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    currentRestaurant.restaurantName,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),

                                Spacer(),

                                /// SelectionOfPlace
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: DropdownButton<String>(
                                    value: currentPlace,
                                    onChanged: (String? val) {
                                      setState(() {
                                        currentPlace = val!;
                                        currentPlaceTableNum = currentRestaurant
                                            .places[currentPlace]!;
                                      });
                                    },
                                    icon: Icon(
                                      Icons.keyboard_arrow_down_sharp,
                                      color: Colors.black,
                                    ),
                                    items: currentRestaurant.placesList
                                        .map<DropdownMenuItem<String>>((place) {
                                      return DropdownMenuItem<String>(
                                        value: place,
                                        child: Text(
                                          '$place ',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),

                                /// Divider
                                SizedBox(
                                  width: size.width - 64,
                                  child: Divider(
                                    height: 10,
                                    thickness: 2,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: size.height / 2,
                            width: size.width,
                            child: GridView.builder(
                                scrollDirection: Axis.horizontal,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4,
                                        childAspectRatio: 0.5),
                                itemCount: currentPlaceTableNum,
                                itemBuilder: (context, index) {
                                  Color tableColor = Color(0XFFC4C4C4);
                                  Order? currentOrder = null;

                                  for (Order order in orderList) {
                                    if (order.placeNum == currentPlace &&
                                        order.tableNum == (index + 1)) {
                                      currentOrder = order;
                                      tableColor = Colors.green;
                                      for (var currentOrderFood
                                          in order.currentOrders) {
                                        Map<String, dynamic>
                                            currentOrderFoodMap =
                                            jsonDecode(currentOrderFood);
                                        if (currentOrderFoodMap['isServed'][0]
                                                ['isServed'] ==
                                            -1) {
                                          tableColor = Colors.yellow;
                                        }
                                      }
                                    }
                                  }

                                  /// Table Button
                                  return GestureDetector(
                                    onTap: () {
                                      print(
                                          '$currentPlace ${index + 1}. Table');
                                      buildShowModalBottomSheet(
                                          context,
                                          size,
                                          index,
                                          currentOrder,
                                          currentRestaurant,
                                          foodCategory,
                                          orderList);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                          color: tableColor,
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(
                                            Icons.restaurant,
                                            color: Colors.black,
                                          ),
                                          Text(
                                            '${index + 1}. Table',
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            }
          }),
    );
  }

  Future<void> buildShowModalBottomSheet(
      BuildContext context,
      Size size,
      int index,
      Order? currentOrder,
      Restaurant currentRestaurant,
      List<Map<String, dynamic>> foodCategory,
      List<Order> orderList) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context2) {
        return StatefulBuilder(builder: (context, setModalState) {
          return Container(
            height: size.height / 2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(24), topLeft: Radius.circular(24)),
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFC6C6C6),
                    Color(0xFF656565),
                    Color(0xFF000000).withOpacity(0.7),
                  ]),
            ),
            child: Center(
              child: Column(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// Table Name
                      Container(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          '$currentPlace ${index + 1}. Table',
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFFC4C4C4),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24),
                            bottomRight: Radius.circular(24),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context2);
                        },
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Color(0xFFC4C4C4),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(24),
                              bottomLeft: Radius.circular(24),
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  currentOrder == null
                      ? Spacer()
                      : Expanded(
                          child: ListView.builder(
                              itemCount: currentOrder.currentOrders.length,
                              itemBuilder: (context, index) {
                                List<Map<String, dynamic>> orderedFoodList =
                                    currentOrder.currentOrders
                                        .map((e) => jsonDecode(e)
                                            as Map<String, dynamic>)
                                        .toList();
                                // Map<String, dynamic> orderedFood = jsonDecode(
                                //     currentOrder.currentOrders[index]);
                                int numberOfOrderedFood =
                                    orderedFoodList[index]['food'].length;
                                return Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  height: 50.0 * numberOfOrderedFood,
                                  decoration: BoxDecoration(
                                    color: orderedFoodList[index]['isServed'][0]
                                                ['isServed'] ==
                                            -1
                                        ? Colors.yellow
                                        : Colors.green,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount:
                                          orderedFoodList[index]['food'].length,
                                      itemBuilder: (context, index2) {
                                        String foodName = '';
                                        num totalAmount = 0;
                                        for (var realFoodName
                                            in orderedFoodList[index]['food']
                                                    [index2]
                                                .keys) {
                                          if (realFoodName != 'amount') {
                                            foodName = realFoodName;
                                            totalAmount +=
                                                (orderedFoodList[index]['food']
                                                        [index2][foodName] *
                                                    orderedFoodList[index]
                                                            ['food'][index2]
                                                        ['amount'])!;
                                            print('total Amount: $totalAmount');
                                          }
                                        }
                                        return SizedBox(
                                          height: 50,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: 16,
                                              ),
                                              Text(
                                                '${orderedFoodList[index]['food'][index2]['amount'].round()}',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 16,
                                              ),
                                              Text(
                                                '$foodName',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20,
                                                ),
                                              ),
                                              Spacer(),
                                              Text(
                                                '$totalAmount \$',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 16,
                                              ),
                                              orderedFoodList[index]['isServed']
                                                              [0]['isServed'] ==
                                                          -1 &&
                                                      index2 == 0
                                                  ? GestureDetector(
                                                      onTap: () async {
                                                        List<String>
                                                            allOrdersInRestStrMap =
                                                            [];
                                                        setModalState(() {
                                                          orderedFoodList[index]
                                                                  [
                                                                  'isServed'][0]
                                                              ['isServed'] = 1;
                                                          List<String>
                                                              orderedFoodListString =
                                                              orderedFoodList
                                                                  .map((e) =>
                                                                      jsonEncode(
                                                                          e))
                                                                  .toList();
                                                          currentOrder
                                                                  .currentOrders =
                                                              orderedFoodListString;
                                                          List<
                                                                  Map<String,
                                                                      dynamic>>
                                                              allOrdersInRestFromMap =
                                                              currentRestaurant
                                                                  .orders
                                                                  .map((e) => jsonDecode(
                                                                          e)
                                                                      as Map<
                                                                          String,
                                                                          dynamic>)
                                                                  .toList();
                                                          print(
                                                              allOrdersInRestFromMap);
                                                          Map<String, dynamic>
                                                              currentOrderOnMap =
                                                              currentOrder
                                                                  .toMap();
                                                          for (var orderInAllOrder
                                                              in allOrdersInRestFromMap) {
                                                            if (!orderInAllOrder[
                                                                    'isFinished'] &&
                                                                orderInAllOrder[
                                                                        'placeNum'] ==
                                                                    currentOrder
                                                                        .placeNum &&
                                                                orderInAllOrder[
                                                                        'tableNum'] ==
                                                                    currentOrder
                                                                        .tableNum) {
                                                              allOrdersInRestFromMap
                                                                  .remove(
                                                                      orderInAllOrder);
                                                              allOrdersInRestFromMap
                                                                  .add(
                                                                      currentOrderOnMap);
                                                              break;
                                                            }
                                                          }
                                                          allOrdersInRestStrMap =
                                                              allOrdersInRestFromMap
                                                                  .map((e) =>
                                                                      jsonEncode(
                                                                          e))
                                                                  .toList();
                                                        });
                                                        await HomeModelView()
                                                            .updateOrder(
                                                                currentRestaurant
                                                                    .email,
                                                                allOrdersInRestStrMap);
                                                        setModalState(() {});
                                                        print('Change Of');
                                                      },
                                                      child: Container(
                                                        width: 50,
                                                        height: 50,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.green,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(16),
                                                        ),
                                                        child: Center(
                                                          child: Icon(
                                                            Icons.done,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : Container()
                                            ],
                                          ),
                                        );
                                      }),
                                );
                              }),
                        ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Divider(
                      color: Colors.white,
                      thickness: 2,
                      height: 10,
                    ),
                  ),
                  Row(
                    children: [
                      currentOrder != null
                          ? Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  print('finish');
                                  List<String> allOrdersInRestStrMap = [];
                                  List<Map<String, dynamic>>
                                      allOrdersInRestFromMap = currentRestaurant
                                          .orders
                                          .map((e) => jsonDecode(e)
                                              as Map<String, dynamic>)
                                          .toList();
                                  print(allOrdersInRestFromMap);
                                  currentOrder.isFinished = true;
                                  Map<String, dynamic> currentOrderOnMap =
                                      currentOrder.toMap();
                                  for (var orderInAllOrder
                                      in allOrdersInRestFromMap) {
                                    if (!orderInAllOrder['isFinished'] &&
                                        orderInAllOrder['placeNum'] ==
                                            currentOrder.placeNum &&
                                        orderInAllOrder['tableNum'] ==
                                            currentOrder.tableNum) {
                                      allOrdersInRestFromMap
                                          .remove(orderInAllOrder);
                                      allOrdersInRestFromMap
                                          .add(currentOrderOnMap);
                                      break;
                                    }
                                  }
                                  print(currentOrderOnMap);
                                  allOrdersInRestStrMap = allOrdersInRestFromMap
                                      .map((e) => jsonEncode(e))
                                      .toList();
                                  await HomeModelView().updateOrder(
                                      currentRestaurant.email,
                                      allOrdersInRestStrMap);
                                  setModalState(() {});
                                  print('Change Of Finish');
                                  print(currentRestaurant.orders);
                                  Navigator.pop(context2);
                                },
                                child: Container(
                                  margin: EdgeInsets.all(16),
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF00CE52),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Finish',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddingOrderView(
                                          currentRestaurant: currentRestaurant,
                                          foodCategory: foodCategory,
                                          placeName: currentPlace,
                                          tableNum: (index + 1),
                                          ordersList: orderList,
                                        ))).then(
                                (value) => setModalState(() {}));
                          },
                          child: Container(
                            margin: EdgeInsets.all(16),
                            height: 40,
                            decoration: BoxDecoration(
                              color: Color(0xFF00CE52),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Text(
                                currentOrder != null
                                    ? 'Update Order'
                                    : 'Give New Order',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
      },
    );
  }
}
