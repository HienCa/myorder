// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myorder/models/warehouse_receipt_detail.dart';

class CancellationReceipt {
  String cancellation_receipt_id;
  String cancellation_receipt_code;
  String reason;
  String employee_id;
  String employee_name;
  Timestamp create_at;
  int status;
  int active;
  List<WarehouseReceiptDetail>? warehouseReceiptDetails = [];
  //Chi tiết phiếu hủy dùng chi tiết phiếu nhập
  CancellationReceipt({
    required this.cancellation_receipt_id,
    required this.cancellation_receipt_code,
    required this.reason,
    required this.create_at,
    required this.employee_id,
    required this.employee_name,
    required this.status,
    required this.active,
  });

  Map<String, dynamic> toJson() => {
        "cancellation_receipt_id": cancellation_receipt_id,
        "cancellation_receipt_code": cancellation_receipt_code,
        "reason": reason,
        "create_at": create_at,
        "employee_id": employee_id,
        "employee_name": employee_name,
        "status": status,
        "active": active,
      };

  static CancellationReceipt fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return CancellationReceipt(
      cancellation_receipt_id: snapshot['cancellation_receipt_id'] ?? "",
      cancellation_receipt_code: snapshot['cancellation_receipt_code'] ?? "",
      reason: snapshot['reason'] ?? "Đã hủy",
      create_at: snapshot['create_at'] ?? Timestamp.now(),
      employee_id: snapshot['employee_id'] ?? "",
      employee_name: snapshot['employee_name'] ?? "",
      status: snapshot['status'] ?? 1,
      active: snapshot['active'] ?? 1,
    );
  }
}
