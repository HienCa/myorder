// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class Report {
  int quantity;
  double total_amount;

  Report({
    required this.quantity,
    required this.total_amount,
  });
  Report.empty()
      : quantity = 0, // Provide a default value for quantity
        total_amount = 0.0; // Provide a default value for total_amount

  Map<String, dynamic> toJson() => {
        "vat_id": quantity,
        "total_amount": total_amount,
      };

  static Report fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Report(
      quantity: snapshot['quantity'],
      total_amount: snapshot['total_amount'],
    );
  }
}
