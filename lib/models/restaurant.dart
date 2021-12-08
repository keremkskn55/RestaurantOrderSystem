class Restaurant {
  String email;
  String password;
  String restaurantName;
  Map<String, int> places;
  List<String> placesList;
  List<Map<String, List<Map<String, double>>>> categories;

  Restaurant({
    required this.email,
    required this.password,
    required this.restaurantName,
    required this.categories,
    required this.places,
    required this.placesList,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
      'restaurantName': restaurantName,
      'categories': categories,
      'places': places,
      'placesList': placesList,
    };
  }

  factory Restaurant.fromMap(Map map) {
    return Restaurant(
      email: map['email'],
      password: map['password'],
      restaurantName: map['restaurantName'],
      categories: map['categories'],
      places: map['places'],
      placesList: map['placesList'],
    );
  }
}
