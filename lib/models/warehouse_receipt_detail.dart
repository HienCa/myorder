// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class WarehouseRecceiptDetail {
  String warehouse_receipt_detail_id;
  String ingredient_id;
  String ingredient_name;
  double quantity;
  double? new_quantity;
  double price;
  String unit_id;
  String unit_name;

  WarehouseRecceiptDetail({
    required this.warehouse_receipt_detail_id,
    required this.ingredient_id,
    required this.ingredient_name,
    required this.quantity,
    required this.price,
    required this.unit_id,
    required this.unit_name,
  });

  Map<String, dynamic> toJson() => {
        "warehouse_receipt_detail_id": warehouse_receipt_detail_id,
        "ingredient_id": ingredient_id,
        "ingredient_name": ingredient_name,
        "quantity": quantity,
        "price": price,
        "unit_id": unit_id,
        "unit_name": unit_name,
      };

  static WarehouseRecceiptDetail fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return WarehouseRecceiptDetail(
      warehouse_receipt_detail_id: snapshot['warehouse_receipt_detail_id'],
      ingredient_id: snapshot['ingredient_id'],
      ingredient_name: snapshot['ingredient_name'],
      quantity: snapshot['quantity'],
      price: snapshot['price'],
      unit_id: snapshot['unit_id'],
      unit_name: snapshot['unit_name'],
    );
  }
}
