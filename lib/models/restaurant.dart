class Restaurant {
  String email;
  String password;
  String restaurantName;
  Map<String, int> places;
  List<String> placesList;
  List<String> categories;
  List<String> orders;

  Restaurant({
    required this.email,
    required this.password,
    required this.restaurantName,
    required this.categories,
    required this.places,
    required this.placesList,
    required this.orders,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
      'restaurantName': restaurantName,
      'categories': categories,
      'places': places,
      'placesList': placesList,
      'orders': orders,
    };
  }

  factory Restaurant.fromMap(Map<String, dynamic> map) {
    return Restaurant(
      email: map['email'],
      password: map['password'],
      restaurantName: map['restaurantName'],
      places: Map<String, int>.from(map['places']),
      categories: List<String>.from(map['categories']),
      placesList: List<String>.from(map['placesList']),
      orders: List<String>.from(map['orders']),
    );
  }
}
