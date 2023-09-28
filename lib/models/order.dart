// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myorder/models/order_detail.dart';
import 'package:myorder/models/table.dart';

class Order {
  String order_id;
  int order_status;
  String? note;
  Timestamp create_at;
  Timestamp? payment_at;
  int active;
  String employee_id;
  String table_id;
  Table? table;
  List<OrderDetail> order_details = [];
  List<String>? table_merged_names;
  double? total_amount = 0;
  Order({
    required this.order_id,
    required this.order_status,
    this.note,
    required this.create_at,
    this.payment_at,
    required this.active,
    required this.employee_id,
    required this.table_id,
    this.total_amount,
    this.table,
    this.table_merged_names,
  });

  Map<String, dynamic> toJson() => {
        "order_id": order_id,
        "order_status": order_status,
        "note": note,
        "create_at": create_at,
        "payment_at": payment_at,
        "active": active,
        "employee_id": employee_id,
        "table_id": table_id,
        "order_details": order_details,
      };

  static Order fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Order(
      order_id: snapshot['order_id'],
      order_status: snapshot['order_status'],
      note: snapshot['note'],
      create_at: snapshot['create_at'],
      payment_at: snapshot['payment_at'],
      active: snapshot['active'],
      employee_id: snapshot['employee_id'],
      table_id: snapshot['table_id'],
    );
  }
}
