import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_order_system/on_board.dart';
import 'package:restaurant_order_system/screens/create_account_food_categories_model_view.dart';
import 'package:restaurant_order_system/services/auth.dart';
import 'package:restaurant_order_system/widgets/create_account_view_components/create_account_view_top_texts.dart';

class CreateAccountFoodCategoriesView extends StatefulWidget {
  Map<String, int> places;
  List<String> placesList;

  String email;
  String password;
  String restaurantName;

  CreateAccountFoodCategoriesView({
    required this.places,
    required this.placesList,
    required this.email,
    required this.password,
    required this.restaurantName,
  });

  @override
  _CreateAccountFoodCategoriesViewState createState() =>
      _CreateAccountFoodCategoriesViewState();
}

class _CreateAccountFoodCategoriesViewState
    extends State<CreateAccountFoodCategoriesView> {
  TextEditingController editCtr = TextEditingController();
  TextEditingController editForFoodNameCtr = TextEditingController();
  TextEditingController editForFoodPriceCtr = TextEditingController();

  /// ListOfCategory
  List<Map<String, List<Map<String, double>>>> categoryNameList = [
    // {
    //   'Drinks': [
    //     {
    //       'Coca-Cola 330 ml': 6.45,
    //       'isEditing1': -1,
    //     },
    //     {
    //       'Ice Tea 330 ml': 9.45,
    //       'isEditing1': -1,
    //     },
    //   ],
    //   'isEditing1': [
    //     {
    //       'isEditing2': 0,
    //     },
    //   ],
    // },
    // {
    //   'Soups': [
    //     {
    //       'Mercimek': 12.95,
    //       'isEditing1': -1,
    //     },
    //     {
    //       'Tarhana': 14.95,
    //       'isEditing1': -1,
    //     },
    //   ],
    //   'isEditing1': [
    //     {'isEditing2': 0},
    //   ],
    // },
  ];

  String takingKeyValue(Map<String, List<Map<String, double>>> categoryName) {
    for (String name in categoryName.keys) {
      if (name != 'isEditing1') {
        return name;
      }
    }
    return '';
  }

  String takingKeyValue2(Map<String, double> categoryName) {
    for (String name in categoryName.keys) {
      if (name != 'isEditing1') {
        return name;
      }
    }
    return '';
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return ChangeNotifierProvider<CreateAccountFoodCategoriesModeView>(
      create: (context) => CreateAccountFoodCategoriesModeView(),
      builder: (context, _) => Scaffold(
        // resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () async {
                print('Restaurant Created and added to firebase');

                List<String> foodCategory =
                    categoryNameList.map((data) => jsonEncode(data)).toList();
                await Provider.of<CreateAccountFoodCategoriesModeView>(context,
                        listen: false)
                    .addNewRestaurant(
                        email: widget.email,
                        password: widget.password,
                        restaurantName: widget.restaurantName,
                        places: widget.places,
                        placesList: widget.placesList,
                        categoryNameList: foodCategory);
                try {
                  await Auth().registerWithEmail(widget.email, widget.password);
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'weak-password') {
                    print('The password provided is too weak.');
                  } else if (e.code == 'email-already-in-use') {
                    print('The account already exists for that email.');
                  }
                } catch (e) {
                  print(e);
                }
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => OnBoard()),
                    (Route<dynamic> route) => false);
              },
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.5),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Create',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
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
              Expanded(
                flex: 1,
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: CreateAccountViewTopTexts()),
              ),
              Expanded(
                flex: 3,
                child: ListView.builder(
                  itemCount: categoryNameList.length + 1,
                  itemBuilder: (context, index) {
                    if (index == categoryNameList.length) {
                      /// Adding Category
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            categoryNameList.add(
                              {
                                '': [],
                                'isEditing1': [
                                  {'isEditing2': 0},
                                ],
                              },
                            );
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Icon(
                                  Icons.add_box,
                                  color: Colors.black,
                                ),
                              ),
                              Text('Add Category'),
                            ],
                          ),
                        ),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        children: [
                          /// Category Name Part
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.remove_circle,
                                    color: Colors.black,
                                    size: 24,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      categoryNameList.removeAt(index);
                                    });
                                  },
                                ),
                                SizedBox(
                                  width: size.width - 128,
                                  child: categoryNameList[index]
                                                  ['isEditing1']![0]
                                              ['isEditing2'] ==
                                          0
                                      ? Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                          ),
                                          child: Center(
                                            child: Text(
                                              takingKeyValue(
                                                  categoryNameList[index]),
                                            ),
                                          ),
                                        )
                                      : TextField(
                                          controller: editCtr,
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                          ),
                                        ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      categoryNameList[index]['isEditing1']![0]
                                                  ['isEditing2'] ==
                                              0.0
                                          ? categoryNameList[index]
                                                  ['isEditing1']![0]
                                              ['isEditing2'] = 1
                                          : categoryNameList[index]
                                                  ['isEditing1']![0]
                                              ['isEditing2'] = 0;

                                      if (categoryNameList[index]
                                                  ['isEditing1']![0]
                                              ['isEditing2'] ==
                                          0.0) {
                                        String oldNameOfCategory =
                                            takingKeyValue(
                                                categoryNameList[index]);
                                        List<Map<String, double>>
                                            tempFoodNames =
                                            categoryNameList[index]
                                                [oldNameOfCategory]!;
                                        if (editCtr.text != oldNameOfCategory) {
                                          categoryNameList[index]
                                              [editCtr.text] = tempFoodNames;
                                          categoryNameList[index]
                                              .remove(oldNameOfCategory);
                                        }
                                      } else {
                                        editCtr.text = takingKeyValue(
                                            categoryNameList[index]);
                                      }
                                      print(categoryNameList);
                                    });
                                  },
                                  icon: Icon(
                                    categoryNameList[index]['isEditing1']![0]
                                                ['isEditing2'] ==
                                            0.0
                                        ? Icons.edit
                                        : Icons.done,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          /// Food Name Part Of The Category
                          SizedBox(
                            height: 50.0 *
                                (categoryNameList[index][takingKeyValue(
                                            categoryNameList[index])]!
                                        .length +
                                    1),
                            child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: categoryNameList[index][takingKeyValue(
                                          categoryNameList[index])]!
                                      .length +
                                  1,
                              itemBuilder: (context, index2) {
                                /// Adding new Food
                                if (index2 ==
                                    categoryNameList[index][takingKeyValue(
                                            categoryNameList[index])]!
                                        .length) {
                                  return GestureDetector(
                                    onTap: () {
                                      print('Add Food');
                                      Map<String, double> newFood = Map();
                                      newFood[''] = 0.0;
                                      newFood['isEditing1'] = -1;
                                      print(newFood);
                                      setState(() {
                                        categoryNameList[index][takingKeyValue(
                                                categoryNameList[index])]!
                                            .add(newFood);
                                      });
                                    },
                                    child: Container(
                                      height: 50,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 32.0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(16),
                                          bottomRight: Radius.circular(16),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8),
                                            child: Icon(
                                              Icons.add_box,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text('Add Food'),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                                return Container(
                                  height: 50,
                                  margin: EdgeInsets.symmetric(horizontal: 32),
                                  color: Colors.white,
                                  child: Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          print('remove Food');
                                          setState(() {
                                            categoryNameList[index][
                                                    takingKeyValue(
                                                        categoryNameList[
                                                            index])]!
                                                .removeAt(index2);
                                          });
                                        },
                                        icon: Icon(
                                          Icons.remove_circle,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(
                                        width: size.width / 3,
                                        child: categoryNameList[index][
                                                        takingKeyValue(
                                                            categoryNameList[
                                                                index])]![
                                                    index2]['isEditing1'] ==
                                                -1
                                            ? Text(
                                                takingKeyValue2(
                                                  categoryNameList[index][
                                                      takingKeyValue(
                                                          categoryNameList[
                                                              index])]![index2],
                                                ),
                                              )
                                            : TextField(
                                                controller: editForFoodNameCtr,
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(),
                                                ),
                                              ),
                                      ),
                                      Spacer(),
                                      SizedBox(
                                        width: size.width / 5,
                                        child: categoryNameList[index][
                                                        takingKeyValue(
                                                            categoryNameList[
                                                                index])]![
                                                    index2]['isEditing1'] ==
                                                -1
                                            ? Text(
                                                '${categoryNameList[index][takingKeyValue(categoryNameList[index])]![index2][takingKeyValue2(
                                                categoryNameList[index][
                                                    takingKeyValue(
                                                        categoryNameList[
                                                            index])]![index2],
                                              )]}')
                                            : TextField(
                                                controller: editForFoodPriceCtr,
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(),
                                                ),
                                              ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            categoryNameList[index][takingKeyValue(
                                                            categoryNameList[index])]![index2]
                                                        ['isEditing1'] ==
                                                    -2
                                                ? categoryNameList[index]
                                                        [takingKeyValue(categoryNameList[index])]![
                                                    index2]['isEditing1'] = -1
                                                : categoryNameList[index]
                                                        [takingKeyValue(categoryNameList[index])]![
                                                    index2]['isEditing1'] = -2;

                                            if (categoryNameList[index][
                                                        takingKeyValue(
                                                            categoryNameList[
                                                                index])]![
                                                    index2]['isEditing1'] ==
                                                -1) {
                                              String oldFoodName = takingKeyValue2(
                                                  categoryNameList[index][
                                                          takingKeyValue(
                                                              categoryNameList[
                                                                  index])]![
                                                      index2]);
                                              if (oldFoodName !=
                                                  editForFoodNameCtr.text) {
                                                categoryNameList[index][
                                                        takingKeyValue(
                                                            categoryNameList[
                                                                index])]![index2]
                                                    .remove(oldFoodName);
                                                categoryNameList[index][
                                                        takingKeyValue(
                                                            categoryNameList[
                                                                index])]![index2]
                                                    [editForFoodNameCtr
                                                        .text] = double.parse(
                                                    editForFoodPriceCtr.text);
                                              }
                                            } else {
                                              editForFoodNameCtr.text =
                                                  takingKeyValue2(
                                                      categoryNameList[index][
                                                              takingKeyValue(
                                                                  categoryNameList[
                                                                      index])]![
                                                          index2]);
                                              editForFoodPriceCtr
                                                  .text = categoryNameList[index]
                                                          [takingKeyValue(
                                                              categoryNameList[
                                                                  index])]![index2]
                                                      [takingKeyValue2(
                                                          categoryNameList[index]
                                                              [takingKeyValue(categoryNameList[index])]![index2])]
                                                  .toString();
                                            }
                                            // editForFoodNameCtr.text = '';
                                            // editForFoodPriceCtr.text = '';
                                          });
                                        },
                                        icon: Icon(
                                          categoryNameList[index][
                                                          takingKeyValue(
                                                              categoryNameList[
                                                                  index])]![
                                                      index2]['isEditing1'] ==
                                                  -1
                                              ? Icons.edit
                                              : Icons.done,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
