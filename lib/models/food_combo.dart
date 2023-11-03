// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class FoodCombo {
  String food_id;
  String name;
  String? image;
  double price;
  String? vat_id;
  double? price_with_temporary;
  Timestamp? temporary_price_from_date;
  Timestamp? temporary_price_to_date;
  int active;
  String category_id;
  int category_code;
  String unit_id;
  int temporary_percent;
  bool isSelected = false;
  List<FoodCombo> listFood;

  FoodCombo({
    required this.food_id,
    required this.name,
    required this.category_code,
    this.image,
    required this.price,
    this.vat_id,
    this.price_with_temporary,
    this.temporary_price_from_date,
    this.temporary_price_to_date,
    required this.active,
    required this.category_id,
    required this.unit_id,
    required this.temporary_percent,
    required this.listFood,
  });

  Map<String, dynamic> toJson() {
    return {
      "food_id": food_id,
      "name": name,
      "image": image,
      "price": price,
      "vat_id": vat_id,
      "price_with_temporary": price_with_temporary,
      "temporary_price_from_date": temporary_price_from_date,
      "temporary_price_to_date": temporary_price_to_date,
      "active": active,
      "category_id": category_id,
      "category_code": category_code,
      "unit_id": unit_id,
      "temporary_percent": temporary_percent,
      "listFood": listFood.map((food) => food.toJson()).toList(),
    };
  }

  factory FoodCombo.fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    // Kiểm tra nếu có danh sách thực phẩm
    List<FoodCombo> listFood = [];
    if (snapshot['listFood'] != null) {
      var foodList = snapshot['listFood'] as List;
      listFood = foodList.map((food) => FoodCombo.fromSnap(food)).toList();
    }

    return FoodCombo(
      food_id: snapshot['food_id'],
      name: snapshot['name'],
      image: snapshot['image'],
      price: snapshot['price'],
      vat_id: snapshot['vat_id'],
      price_with_temporary: snapshot['price_with_temporary'],
      temporary_price_from_date: snapshot['temporary_price_from_date'],
      temporary_price_to_date: snapshot['temporary_price_to_date'],
      active: snapshot['active'],
      category_id: snapshot['category_id'],
      category_code: snapshot['category_code'],
      unit_id: snapshot['unit_id'],
      temporary_percent: snapshot['temporary_percent'],
      listFood: listFood,
    );
  }
}
