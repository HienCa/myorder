// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class FoodOrder {
  String food_id ="";
  String name = "";
  String? image = "";
  double price = 0;
  String? vat_id = "";
  double? price_with_temporary = 0;
  Timestamp? temporary_price_from_date;
  Timestamp? temporary_price_to_date;
  int active = 1;
  String category_id = "";
  int category_code = 1;
  String unit_id = "";
  int temporary_percent = 0;
  bool? isSelected = false;
  int? quantity = 1;

  FoodOrder({
    required this.food_id,
    required this.name,
    this.image,
    required this.price,
    this.vat_id,
    this.price_with_temporary,
    this.temporary_price_from_date,
    this.temporary_price_to_date,
    required this.active,
    required this.category_id,
    required this.category_code,
    required this.unit_id,
    required this.temporary_percent,
    this.isSelected,
    this.quantity,
  });
  FoodOrder.empty()
      : food_id = '',
        name = '',
        image = null,
        price = 0.0,
        vat_id = null,
        price_with_temporary = null,
        temporary_price_from_date = null,
        temporary_price_to_date = null,
        active = 1,
        category_id = '',
        category_code = 1,
        unit_id = '',
        temporary_percent = 0,
        isSelected = false,
        quantity = 0;

  Map<String, dynamic> toJson() => {
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
      };

  static FoodOrder fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return FoodOrder(
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
    );
  }
}
