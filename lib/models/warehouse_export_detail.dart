// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class WarehouseExportDetail {
  String warehouse_export_detail_id;
  String warehouse_receipt_detail_id;
  String warehouse_receipt_id;
  String ingredient_id;
  String ingredient_name;
  double quantity;
  double? quantity_in_stock;
  double? new_quantity;
  double price;
  String unit_id;
  String unit_name;

  WarehouseExportDetail({
    required this.warehouse_export_detail_id,
    required this.warehouse_receipt_detail_id,
    required this.warehouse_receipt_id,
    required this.ingredient_id,
    required this.ingredient_name,
    required this.quantity,
    required this.price,
    required this.unit_id,
    required this.unit_name,
  });

  Map<String, dynamic> toJson() => {
        "warehouse_export_detail_id": warehouse_export_detail_id,
        "warehouse_receipt_detail_id": warehouse_receipt_detail_id,
        "warehouse_receipt_id": warehouse_receipt_id,
        "ingredient_id": ingredient_id,
        "ingredient_name": ingredient_name,
        "quantity": quantity,
        "price": price,
        "unit_id": unit_id,
        "unit_name": unit_name,
      };

  static WarehouseExportDetail fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return WarehouseExportDetail(
      warehouse_export_detail_id: snapshot['warehouse_export_detail_id'],
      warehouse_receipt_detail_id: snapshot['warehouse_receipt_detail_id'],
      warehouse_receipt_id: snapshot['warehouse_receipt_id'],
      ingredient_id: snapshot['ingredient_id'],
      ingredient_name: snapshot['ingredient_name'],
      quantity: snapshot['quantity'],
      price: snapshot['price'],
      unit_id: snapshot['unit_id'],
      unit_name: snapshot['unit_name'],
    );
  }
}
