// ignore_for_file: non_constant_identifier_names

import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class Food {
  String food_id;
  String name;
  String? image;
  double  price;
  String vat_id;
  double? price_with_temporary;
  DateTime? temporary_price_from_date;
  DateTime? temporary_price_to_date;
  double ? temporary_price;
  double ? temporary_percent;
  int active;
  String category_id;
  String unit_id;

  Food({
      required this.food_id,
      required this.name,
               this.image,
      required this.price,
      required this.vat_id,
               this.price_with_temporary,
               this.temporary_price_from_date,
               this.temporary_price_to_date,
               this.temporary_price,
               this.temporary_percent,
      required this.active,
      required this.category_id,
      required this.unit_id,      
      });

  Map<String, dynamic> toJson() => {
        "food_id": food_id,
        "name": name,
        "image": image,
        "price": price,
        "vat_id": vat_id,
        "price_with_temporary": price_with_temporary,
        "temporary_price_from_date": temporary_price_from_date,
        "temporary_price_to_date": temporary_price_to_date,
        "temporary_price": temporary_price,
        "temporary_percent": temporary_percent,
        "active": active,
        "category_id": category_id,
        "unit_id": unit_id,
      };

  static Food fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Food(
      food_id: snapshot['food_id'],
      name: snapshot['name'],
      image: snapshot['image'],
      price: snapshot['price'],
      vat_id: snapshot['vat_id'],
      price_with_temporary: snapshot['price_with_temporary'],
      temporary_price_from_date: snapshot['temporary_price_from_date'],
      temporary_price_to_date: snapshot['temporary_price_to_date'],
      temporary_price: snapshot['temporary_price'],
      temporary_percent: snapshot['temporary_percent'],
      active: snapshot['active'],
      category_id: snapshot['category_id'],
      unit_id: snapshot['unit_id'],
    );
  }
}
