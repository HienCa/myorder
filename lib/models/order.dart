// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myorder/models/order_detail.dart';
import 'package:myorder/models/table.dart';

class Order {
  String order_id;
  String order_code;
  int total_slot;
  int is_vat;
  int is_discount;
  double discount_amount_all;
  double discount_amount_food;
  double discount_amount_drink;
  double discount_amount_other;
  String discount_reason;
  int discount_percent;
  String? vat_name;
  String? discount_name;
  double total_vat_amount;
  double total_discount_amount;
  double total_surcharge_amount;
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
  //booking
  String customer_name = '';
  String customer_phone = '';
  Timestamp? customer_time_booking;
  double deposit_amount = 0;
  Order({
    required this.order_id,
    required this.order_code,
    required this.order_status,
    required this.discount_reason,
    required this.total_slot,
    this.note,
    required this.total_surcharge_amount,
    required this.create_at,
    this.payment_at,
    required this.active,
    required this.employee_id,
    this.employee_name,
    required this.table_id,
    required this.total_amount,
    this.table,
    required this.is_vat,
    required this.is_discount,
    required this.total_vat_amount,
    required this.total_discount_amount,
    required this.discount_amount_all,
    required this.discount_amount_food,
    required this.discount_amount_drink,
    required this.discount_amount_other,
    required this.discount_percent,
    required this.table_merge_ids,
    required this.table_merge_names,
    required this.customer_name,
    required this.customer_phone,
    required this.customer_time_booking,
    required this.deposit_amount,
  });
  Order.empty()
      : order_id = '',
        order_code = '',
        discount_reason = '',
        total_slot = 1,
        is_vat = 0,
        is_discount = 0,
        discount_amount_all = 0,
        discount_amount_food = 0,
        discount_amount_drink = 0,
        discount_amount_other = 0,
        discount_percent = 0,
        total_vat_amount = 0,
        total_discount_amount = 0,
        total_surcharge_amount = 0,
        order_status = 0,
        total_amount = 0,
        create_at = Timestamp.now(),
        active = 1,
        employee_id = '',
        table_id = '',
        customer_name = '',
        customer_phone = '',
        deposit_amount = 0,
        customer_time_booking = null,
        table_merge_ids = [],
        table_merge_names = [];

  Map<String, dynamic> toJson() => {
        "order_id": order_id,
        "order_code": order_code,
        "total_slot": total_slot,
        "discount_reason": discount_reason,
        "order_status": order_status,
        "note": note,
        "create_at": create_at,
        "payment_at": payment_at,
        "active": active,
        "employee_id": employee_id,
        "table_id": table_id,
        "is_vat": is_vat,
        "is_discount": is_discount,
        "total_amount": total_amount,
        "total_vat_amount": total_vat_amount,
        "total_discount_amount": total_discount_amount,
        "total_surcharge_amount": total_surcharge_amount,
        "discount_amount_all": discount_amount_all,
        "discount_amount_drink": discount_amount_drink,
        "discount_amount_food": discount_amount_food,
        "discount_amount_other": discount_amount_other,
        "discount_percent": discount_percent,
        "table_merge_ids": table_merge_ids,
        "table_merge_names": table_merge_names,
        "customer_name": customer_name,
        "customer_phone": customer_phone,
        "customer_time_booking": customer_time_booking,
        "deposit_amount": deposit_amount,
      };

  static Order fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Order(
      order_id: snapshot['order_id'],
      order_code: snapshot['order_code'],
      total_slot: snapshot['total_slot'],
      discount_reason: snapshot['discount_reason'],
      total_amount: snapshot['total_amount'],
      order_status: snapshot['order_status'],
      note: snapshot['note'],
      create_at: snapshot['create_at'],
      payment_at: snapshot['payment_at'],
      active: snapshot['active'],
      employee_id: snapshot['employee_id'],
      table_id: snapshot['table_id'],
      is_vat: snapshot['is_vat'],
      is_discount: snapshot['is_discount'],
      total_vat_amount: snapshot['total_vat_amount'],
      total_discount_amount: snapshot['total_discount_amount'],
      total_surcharge_amount: snapshot['total_surcharge_amount'],
      discount_amount_all: snapshot['discount_amount_all'],
      discount_amount_food: snapshot['discount_amount_food'],
      discount_amount_drink: snapshot['discount_amount_drink'],
      discount_amount_other: snapshot['discount_amount_other'],
      discount_percent: snapshot['discount_percent'],
      table_merge_ids: snapshot['table_merge_ids'],
      table_merge_names: snapshot['table_merge_names'],
      customer_name: snapshot['customer_name'],
      customer_phone: snapshot['customer_phone'],
      customer_time_booking: snapshot['customer_time_booking'],
      deposit_amount: snapshot['deposit_amount'],
    );
  }
}
