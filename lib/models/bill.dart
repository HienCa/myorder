// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class Bill {
  String bill_id;
  String order_id;
  double total_amount;
  double vat_amount;
  double discount_amount;
  Bill({
    required this.bill_id,
    required this.order_id,
    required this.total_amount,
    required this.vat_amount,
    required this.discount_amount,
  });

  Map<String, dynamic> toJson() => {
        "bill_id": bill_id,
        "order_id": order_id,
        "total_amount": total_amount,
        "vat_amount": vat_amount,
        "discount_amount": discount_amount,
      };

  static Bill fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Bill(
      bill_id: snapshot['bill_id'],
      order_id: snapshot['order_id'],
      total_amount: snapshot['total_amount'],
      vat_amount: snapshot['vat_amount'],
      discount_amount: snapshot['discount_amount'],
    );
  }
}
