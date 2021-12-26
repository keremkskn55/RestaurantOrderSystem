class Order {
  String placeNum;
  int tableNum;
  String note;
  bool isFinished;
  String date;
  List<String> currentOrders;

  Order(
      {required this.placeNum,
      required this.tableNum,
      required this.note,
      required this.isFinished,
      required this.date,
      required this.currentOrders});

  Map<String, dynamic> toMap() {
    return {
      'placeNum': placeNum,
      'tableNum': tableNum,
      'note': note,
      'isFinished': isFinished,
      'date': date,
      'currentOrders': currentOrders,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      placeNum: map['placeNum'],
      tableNum: map['tableNum'],
      note: map['note'],
      isFinished: map['isFinished'],
      date: map['date'],
      currentOrders: List<String>.from(map['currentOrders']),
    );
  }
}
