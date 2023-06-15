class MenuModel {
  int? id;
  String? name, description, price;

  MenuModel({this.id, this.name, this.description, this.price});

  factory MenuModel.fromJson(Map<String, dynamic> json) {
    return MenuModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
    );
  }
}
