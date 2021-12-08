import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_order_system/screens/create_account_food_categories_view.dart';
import 'package:restaurant_order_system/widgets/common_components/text_field_component.dart';
import 'package:restaurant_order_system/widgets/create_account_name_and_floor_number_components/create_account_name_select_floor.dart';
import 'package:restaurant_order_system/widgets/create_account_view_components/create_account_view_top_texts.dart';

class CreateAccountNameAndFloorNumberView extends StatefulWidget {
  String email;
  String password;

  CreateAccountNameAndFloorNumberView(
      {required this.email, required this.password});

  @override
  _CreateAccountNameAndFloorNumberViewState createState() =>
      _CreateAccountNameAndFloorNumberViewState();
}

class _CreateAccountNameAndFloorNumberViewState
    extends State<CreateAccountNameAndFloorNumberView> {
  /// Global Key
  GlobalKey<FormState> nameRestaurantKey = new GlobalKey<FormState>();

  /// Text Field
  TextEditingController restaurantNameCtr = new TextEditingController();

  /// Icons
  Icon restaurantNameIcon = Icon(
    Icons.restaurant_menu,
    color: Colors.black,
  );

  /// NumberOfFloor
  int numberOfFloor = 3;

  /// FloorsDetails
  Map<String, int> places = {
    '1. Place': 10,
    '2. Place': 10,
    '3. Place': 10,
    '4. Place': 10,
    '5. Place': 10,
  };

  /// ListOfPlaces
  List<String> placesList = [
    '1. Place',
    '2. Place',
    '3. Place',
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
              child: Form(
                key: nameRestaurantKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CreateAccountViewTopTexts(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFieldComponent(
                        ctr: restaurantNameCtr,
                        sentHintText: 'Restaurant Name',
                        sentPrefixIcon: restaurantNameIcon,
                      ),
                    ),
                    CreateAccontNameSelectFloor(
                      callback: updateNumberOfFloor,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: placesList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: size.width,
                      height: 48,
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 12,
                          ),
                          Text(
                            placesList[index],
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (places[placesList[index]]! > 1) {
                                  places[placesList[index]] =
                                      (places[placesList[index]]! - 1);
                                }
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                color: Color(0xFFDEDEDE),
                                borderRadius: BorderRadius.circular(13),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.remove,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            '${places[placesList[index]]}',
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (places[placesList[index]]! < 45) {
                                  places[placesList[index]] =
                                      (places[placesList[index]]! + 1);
                                }
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                color: Color(0xFF8F8F8F),
                                borderRadius: BorderRadius.circular(13),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
            GestureDetector(
              onTap: () {
                if (nameRestaurantKey.currentState!.validate()) {
                  print('Continue');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateAccountFoodCategoriesView(
                        places: places,
                        placesList: placesList,
                        email: widget.email,
                        password: widget.password,
                        restaurantName: restaurantNameCtr.text,
                      ),
                    ),
                  );
                }
              },
              child: Container(
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Color(0xFF494949),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Countinue Create Account',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updateNumberOfFloor(int newNumberOfFloor) {
    setState(() {
      numberOfFloor = newNumberOfFloor;
      updateListOfFloor();
    });
  }

  void updateListOfFloor() {
    if (numberOfFloor == 1) {
      placesList = [
        '1. Place',
      ];
      places['2. Place'] = 10;
      places['3. Place'] = 10;
      places['4. Place'] = 10;
      places['5. Place'] = 10;
    }
    if (numberOfFloor == 2) {
      placesList = [
        '1. Place',
        '2. Place',
      ];
      places['3. Place'] = 10;
      places['4. Place'] = 10;
      places['5. Place'] = 10;
    }
    if (numberOfFloor == 3) {
      placesList = [
        '1. Place',
        '2. Place',
        '3. Place',
      ];
      places['4. Place'] = 10;
      places['5. Place'] = 10;
    }
    if (numberOfFloor == 4) {
      placesList = [
        '1. Place',
        '2. Place',
        '3. Place',
        '4. Place',
      ];
      places['5. Place'] = 10;
    }
    if (numberOfFloor == 5) {
      placesList = [
        '1. Place',
        '2. Place',
        '3. Place',
        '4. Place',
        '5. Place',
      ];
    }
  }
}
