import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_order_system/models/restaurant.dart';
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
                                              Icons.settings,
                                              color: Colors.white,
                                            ),
                                            Text(
                                              'Settings',
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
                                  return Container(
                                    margin: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                        color: Color(0XFFC4C4C4),
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
}
