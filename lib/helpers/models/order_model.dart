class OrderModel {
  int? id, menuId, quantity;
  String? amount;

  OrderModel({this.id, this.menuId, this.quantity, this.amount});

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      menuId: json['menuId'],
      quantity: json['quantity'],
      amount: json['amount'],
    );
  }
}
