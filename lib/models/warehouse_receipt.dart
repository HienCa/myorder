// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myorder/models/warehouse_receipt_detail.dart';

class WarehouseReceipt {
  String warehouse_receipt_id;
  String warehouse_receipt_code;
  String employee_id;
  String employee_name;
  String supplier_id;
  String supplier_name;
  Timestamp created_at;
  String note;
  int vat;
  int status;
  double discount;
  int active;
  List<WarehouseRecceiptDetail>? warehouseRecceiptDetails;

  WarehouseReceipt({
    required this.warehouse_receipt_id,
    required this.warehouse_receipt_code,
    required this.employee_id,
    required this.employee_name,
    required this.supplier_id,
    required this.supplier_name,
    required this.created_at,
    required this.note,
    required this.vat,
    required this.discount,
    required this.status,
    required this.active,
  });

  Map<String, dynamic> toJson() => {
        "warehouse_receipt_id": warehouse_receipt_id,
        "warehouse_receipt_code": warehouse_receipt_code,
        "employee_id": employee_id,
        "employee_name": employee_name,
        "supplier_id": supplier_id,
        "supplier_name": supplier_name,
        "created_at": created_at,
        "note": note,
        "vat": vat,
        "discount": discount,
        "active": active,
        "status": status,
      };

  static WarehouseReceipt fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return WarehouseReceipt(
      warehouse_receipt_id: snapshot['warehouse_receipt_id'],
      warehouse_receipt_code: snapshot['warehouse_receipt_code'],
      employee_id: snapshot['employee_id'],
      employee_name: snapshot['employee_name'],
      supplier_id: snapshot['supplier_id'],
      supplier_name: snapshot['supplier_name'],
      created_at: snapshot['created_at'],
      note: snapshot['note'],
      vat: snapshot['vat'],
      discount: snapshot['discount'],
      active: snapshot['active'],
      status: snapshot['status'],
    );
  }
}
