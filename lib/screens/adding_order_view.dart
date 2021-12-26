import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_order_system/models/order.dart';
import 'package:restaurant_order_system/models/restaurant.dart';
import 'package:restaurant_order_system/screens/adding_order_model_view.dart';

class AddingOrderView extends StatefulWidget {
  Restaurant currentRestaurant;
  List<Map<String, dynamic>> foodCategory;
  List<Order> ordersList;
  String placeName;
  int tableNum;

  AddingOrderView({
    required this.currentRestaurant,
    required this.foodCategory,
    required this.placeName,
    required this.tableNum,
    required this.ordersList,
  });

  @override
  _AddingOrderViewState createState() => _AddingOrderViewState();
}

class _AddingOrderViewState extends State<AddingOrderView> {
  Map<String, List<Map<String, double>>> currentOrderList = {
    'isServed': [
      {'isServed': -1}
    ],
    'food': []
  };
  int addingAmount = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('foodCategory: ${widget.foodCategory}');
    Size size = MediaQuery.of(context).size;
    return ChangeNotifierProvider<AddingOrderModelView>(
      create: (_) => AddingOrderModelView(),
      builder: (context, _) => Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
        ),
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
            children: [
              SizedBox(
                height: AppBar().preferredSize.height,
              ),
              Text(
                widget.currentRestaurant.restaurantName,
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(24),
                      ),
                    ),
                    child: Text(
                      '${widget.placeName} ${widget.tableNum}. Table',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: widget.foodCategory.length,
                    itemBuilder: (context, index) {
                      List<dynamic>? foodListInCategory = [];
                      String categoryName = "";

                      for (var category in widget.foodCategory[index].keys) {
                        if (category != 'isEditing1') {
                          categoryName = category;
                          print('category: $category');
                          print(
                              'categoryDetail: ${widget.foodCategory[index][category]}');
                          print(foodListInCategory.runtimeType);
                          print((widget.foodCategory[index][category])
                              .runtimeType);
                          foodListInCategory =
                              widget.foodCategory[index][category];
                        }
                      }

                      return Container(
                        margin: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        height: 50 * (foodListInCategory!.length + 1),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24)),
                        child: Column(
                          children: [
                            /// CategoryName
                            SizedBox(
                              height: 50,
                              child: Center(
                                child: Text(
                                  categoryName,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),

                            /// Foods
                            SizedBox(
                              height: 50.0 * foodListInCategory.length,
                              child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: foodListInCategory.length,
                                  itemBuilder: (context, index) {
                                    String? foodName;
                                    double? foodPrice;
                                    for (var food
                                        in foodListInCategory![index].keys) {
                                      if (food != 'isEditing1') {
                                        foodName = food;
                                        foodPrice =
                                            foodListInCategory[index][food];
                                      }
                                    }
                                    return IgnorePointer(
                                      ignoring: foodListInCategory[index]
                                                  ['isEditing1'] ==
                                              -1
                                          ? false
                                          : true,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            foodListInCategory![index]
                                                        ['isEditing1'] ==
                                                    -1
                                                ? foodListInCategory[index]
                                                    ['isEditing1'] = 1
                                                : foodListInCategory[index]
                                                    ['isEditing1'] = -1;
                                            print(
                                                'accessing: ${foodListInCategory[index]['isEditing1']}');
                                            currentOrderList['food']!.add({
                                              '$foodName': foodPrice!,
                                              'amount': 1,
                                            });
                                          });
                                        },
                                        child: SizedBox(
                                          height: 50,
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 24,
                                              ),
                                              Container(
                                                color: foodListInCategory[index]
                                                            ['isEditing1'] ==
                                                        -1
                                                    ? Color(0xFFA2A2A2)
                                                    : Colors.black,
                                                child: Icon(
                                                  Icons
                                                      .subdirectory_arrow_right,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 24,
                                              ),
                                              Text(
                                                foodName!,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18),
                                              ),
                                              Spacer(),
                                              Text(
                                                '$foodPrice \$',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18),
                                              ),
                                              SizedBox(
                                                width: 24,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            )
                          ],
                        ),
                      );
                    }),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: currentOrderList['food']!.length,
                  itemBuilder: (context, index) {
                    String? orderName;
                    for (var orderedFoodName
                        in currentOrderList['food']![index].keys) {
                      if (orderedFoodName != 'amount') {
                        orderName = orderedFoodName;
                      }
                    }
                    return Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFF474747),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(16)),
                            child: Center(
                              child: Text(
                                '${currentOrderList['food']![index]['amount']!.round()}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            orderName!,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (currentOrderList['food']![index]
                                        ['amount'] !=
                                    1) {
                                  currentOrderList['food']![index]['amount'] =
                                      (currentOrderList['food']![index]
                                              ['amount']! -
                                          1.0);
                                } else {
                                  currentOrderList['food']!.removeAt(index);
                                  for (var categories in widget.foodCategory) {
                                    for (var categoryName in categories.keys) {
                                      if (categoryName != 'isEditing1') {
                                        for (var foodNameMap
                                            in categories[categoryName]) {
                                          for (var foodName
                                              in foodNameMap.keys) {
                                            if (foodName == orderName) {
                                              foodNameMap['isEditing1'] = -1;
                                            }
                                          }
                                        }
                                      }
                                    }
                                  }
                                }
                              });
                            },
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.remove,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                currentOrderList['food']![index]['amount'] =
                                    (currentOrderList['food']![index]
                                            ['amount']! +
                                        1.0);
                              });
                            },
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Divider(
                  color: Colors.black,
                  thickness: 2,
                  height: 20,
                ),
              ),
              GestureDetector(
                onTap: () async {
                  Order? oldOrderCurrentTable;
                  for (Order order in widget.ordersList) {
                    if (order.tableNum == widget.tableNum &&
                        order.placeNum == widget.placeName) {
                      oldOrderCurrentTable = order;
                      break;
                    }
                  }

                  List<String> allOrders = widget.currentRestaurant.orders;

                  if (oldOrderCurrentTable == null) {
                    String currentOrderBeforeSend =
                        jsonEncode(currentOrderList);
                    Order newOrder = Order(
                      date: DateTime.now().toIso8601String(),
                      note: '',
                      currentOrders: [currentOrderBeforeSend],
                      isFinished: false,
                      placeNum: widget.placeName,
                      tableNum: widget.tableNum,
                    );
                    allOrders.add(jsonEncode(newOrder.toMap()));
                    print(allOrders);
                  } else {
                    print('update old oRDER');
                    String currentOrderBeforeSend =
                        jsonEncode(currentOrderList);
                    oldOrderCurrentTable.currentOrders
                        .add(currentOrderBeforeSend);
                    for (int i = 0; i < allOrders.length; i++) {
                      Order orderInAllOrder =
                          Order.fromMap(jsonDecode(allOrders[i]));
                      print(
                          '${!orderInAllOrder.isFinished} ${orderInAllOrder.tableNum == widget.tableNum} ${orderInAllOrder.placeNum == widget.placeName}');
                      print('${orderInAllOrder.tableNum} ${widget.tableNum}');
                      if (!orderInAllOrder.isFinished &&
                          orderInAllOrder.tableNum == (widget.tableNum) &&
                          orderInAllOrder.placeNum == widget.placeName) {
                        print('real Updating old order');
                        allOrders.removeAt(i);
                        allOrders.add(jsonEncode(oldOrderCurrentTable.toMap()));
                      }
                      break;
                    }
                  }

                  print('Give New Order.');
                  await Provider.of<AddingOrderModelView>(context,
                          listen: false)
                      .updateOrder(widget.currentRestaurant.email, allOrders);
                  Navigator.pop(context);
                },
                child: Container(
                  margin: EdgeInsets.all(16),
                  height: 48,
                  width: size.width - 32,
                  decoration: BoxDecoration(
                    color: Color(0xFF00CE52),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      'Update Order',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
