// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myorder/models/order.dart' as model;
import 'package:myorder/models/order_detail.dart';

class Bill {
  String bill_id;
  String order_id;
  String order_code;
  int order_status;
  model.Order? order = model.Order.empty();
  List<OrderDetail> order_details = [];
  int total_slot;
  double total_amount;
  double total_estimate_amount;
  double vat_amount;
  double discount_amount;
  Timestamp payment_at;
  double deposit_amount = 0;

  Bill({
    required this.bill_id,
    required this.order_id,
    required this.order_code,
    required this.total_slot,
    required this.total_amount,
    required this.total_estimate_amount,
    required this.vat_amount,
    required this.discount_amount,
    required this.payment_at,
    required this.deposit_amount,
    required this.order_status,
  });

  Bill.empty()
      : bill_id = '',
        order_id = '',
        order_code = '',
        total_slot = 1,
        order = null,
        total_amount = 0.0,
        total_estimate_amount = 0.0,
        vat_amount = 0.0,
        discount_amount = 0.0,
        deposit_amount = 0,
        order_status = 0,
        payment_at = Timestamp.now();

  Map<String, dynamic> toJson() => {
        "bill_id": bill_id,
        "order_id": order_id,
        "total_slot": total_slot,
        "order_code": order_code,
        "total_amount": total_amount,
        "total_estimate_amount": total_estimate_amount,
        "vat_amount": vat_amount,
        "discount_amount": discount_amount,
        "payment_at": payment_at,
        "deposit_amount": deposit_amount,
        "order_status": order_status,
      };

  static Bill fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Bill(
      bill_id: snapshot['bill_id'],
      order_id: snapshot['order_id'],
      total_slot: snapshot['total_slot'],
      order_code: snapshot['order_code'],
      total_amount: snapshot['total_amount'],
      total_estimate_amount: snapshot['total_estimate_amount'],
      vat_amount: snapshot['vat_amount'],
      discount_amount: snapshot['discount_amount'],
      payment_at: snapshot['payment_at'],
      deposit_amount: snapshot['deposit_amount'],
      order_status: snapshot['order_status'],
    );
  }
}
