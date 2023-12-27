// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myorder/models/warehouse_export_detail.dart';

class WarehouseExport {
  String warehouse_export_id;
  String warehouse_export_code;
  String employee_id;
  String employee_name;
  Timestamp created_at;
  String note;
  int vat;
  int status;
  double discount;
  int active;
  List<WarehouseExportDetail>? warehouseExportDetails;

  WarehouseExport({
    required this.warehouse_export_id,
    required this.warehouse_export_code,
    required this.employee_id,
    required this.employee_name,
    required this.created_at,
    required this.note,
    required this.vat,
    required this.discount,
    required this.status,
    required this.active,
  });

  Map<String, dynamic> toJson() => {
        "warehouse_export_id": warehouse_export_id,
        "warehouse_export_code": warehouse_export_code,
        "employee_id": employee_id,
        "employee_name": employee_name,
        "created_at": created_at,
        "note": note,
        "vat": vat,
        "discount": discount,
        "active": active,
        "status": status,
      };

  static WarehouseExport fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return WarehouseExport(
      warehouse_export_id: snapshot['warehouse_export_id'],
      warehouse_export_code: snapshot['warehouse_export_code'],
      employee_id: snapshot['employee_id'],
      employee_name: snapshot['employee_name'],
      created_at: snapshot['created_at'],
      note: snapshot['note'],
      vat: snapshot['vat'],
      discount: snapshot['discount'],
      active: snapshot['active'],
      status: snapshot['status'],
    );
  }
}
