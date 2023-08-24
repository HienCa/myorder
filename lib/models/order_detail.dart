// ignore_for_file: non_constant_identifier_names

import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class OrrderDetail {
  String order_detail_id;
  Double price;
  Double quantity;
  int food_status;
  String order_id;
  String food_id;
  String table_id;

  OrrderDetail({
    required this.order_detail_id,
    required this.price,
    required this.quantity,
    required this.food_status,
    required this.order_id,
    required this.food_id,
    required this.table_id,
  });

  Map<String, dynamic> toJson() => {
        "order_detail_id": order_detail_id,
        "price": price,
        "quantity": quantity,
        "food_status": food_status,
        "order_id": order_id,
        "food_id": food_id,
        "table_id": table_id,
      };

  static OrrderDetail fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return OrrderDetail(
      order_detail_id: snapshot['order_detail_id'],
      price: snapshot['price'],
      quantity: snapshot['quantity'],
      food_status: snapshot['food_status'],
      order_id: snapshot['order_id'],
      food_id: snapshot['food_id'],
      table_id: snapshot['table_id'],
    );
  }
}
