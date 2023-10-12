// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myorder/models/order_detail.dart';
import 'package:myorder/models/table.dart';

class Order {
  String order_id;
  String order_code;
  String vat_id;
  String discount_id;
  String? vat_name;
  String? discount_name;
  double? total_vat_amount;
  double? total_discount_amount;
  int order_status;
  String? note;
  Timestamp create_at;
  Timestamp? payment_at;
  int active;
  String employee_id;
  String? employee_name;
  String table_id;
  Table? table;
  List<OrderDetail> order_details = [];
  double total_amount = 0;
  List table_merge_ids = [];
  List table_merge_names = [];
  Order({
    required this.order_id,
    required this.order_code,
    required this.order_status,
    this.note,
    required this.create_at,
    this.payment_at,
    required this.active,
    required this.employee_id,
    this.employee_name,
    required this.table_id,
    required this.total_amount,
    this.table,
    required this.vat_id,
    required this.discount_id,
    required this.table_merge_ids,
    required this.table_merge_names,
  });
  Order.empty()
      : order_id = '',
        order_code = '',
        vat_id = '',
        discount_id = '',
        order_status = 0,
        total_amount = 0,
        create_at = Timestamp.now(),
        active = 1,
        employee_id = '',
        table_id = '', table_merge_ids = [], table_merge_names = [];

  Map<String, dynamic> toJson() => {
        "order_id": order_id,
        "order_code": order_code,
        "order_status": order_status,
        "note": note,
        "create_at": create_at,
        "payment_at": payment_at,
        "active": active,
        "employee_id": employee_id,
        "table_id": table_id,
        "vat_id": vat_id,
        "discount_id": discount_id,
        "table_merge_ids": table_merge_ids,
        "table_merge_names": table_merge_names,
      };

  static Order fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Order(
      order_id: snapshot['order_id'],
      order_code: snapshot['order_code'],
      total_amount: snapshot['total_amount'],
      order_status: snapshot['order_status'],
      note: snapshot['note'],
      create_at: snapshot['create_at'],
      payment_at: snapshot['payment_at'],
      active: snapshot['active'],
      employee_id: snapshot['employee_id'],
      table_id: snapshot['table_id'],
      vat_id: snapshot['vat_id'],
      discount_id: snapshot['discount_id'],
      table_merge_ids: snapshot['table_merge_ids'],
      table_merge_names: snapshot['table_merge_names'],
    );
  }
}
