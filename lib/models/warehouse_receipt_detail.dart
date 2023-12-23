// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myorder/models/ingredient.dart';

class WarehouseReceiptDetail {
  String warehouse_receipt_detail_id;
  String ingredient_id;
  String ingredient_name;
  double quantity;
  double quantity_in_stock;
  double? new_quantity;
  double price;
  String unit_id;
  String unit_name;
  Timestamp? expiration_date; //hạn sử dụng
  String batch_number; //số lô
  bool isSelected = false;
  Ingredient? ingredient;
  WarehouseReceiptDetail({
    required this.warehouse_receipt_detail_id,
    required this.ingredient_id,
    required this.ingredient_name,
    required this.quantity,
    required this.quantity_in_stock,
    required this.price,
    required this.unit_id,
    required this.unit_name,
    required this.expiration_date,
    required this.batch_number,
  });

  Map<String, dynamic> toJson() => {
        "warehouse_receipt_detail_id": warehouse_receipt_detail_id,
        "ingredient_id": ingredient_id,
        "ingredient_name": ingredient_name,
        "quantity": quantity,
        "quantity_in_stock": quantity_in_stock,
        "price": price,
        "unit_id": unit_id,
        "unit_name": unit_name,
        "expiration_date": expiration_date,
        "batch_number": batch_number,
      };

  static WarehouseReceiptDetail fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return WarehouseReceiptDetail(
      warehouse_receipt_detail_id: snapshot['warehouse_receipt_detail_id'],
      ingredient_id: snapshot['ingredient_id'],
      ingredient_name: snapshot['ingredient_name'],
      quantity: snapshot['quantity'],
      quantity_in_stock: snapshot['quantity_in_stock'],
      price: snapshot['price'],
      unit_id: snapshot['unit_id'],
      unit_name: snapshot['unit_name'],
      expiration_date: snapshot['expiration_date'],
      batch_number: snapshot['batch_number'],
    );
  }
}
