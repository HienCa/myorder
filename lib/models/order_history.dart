// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class OrderHistory {
  String history_id;
  String order_id;
  String employee_id;
  String employee_name;
  String description;
  Timestamp create_at;


  OrderHistory({
    required this.history_id,
    required this.order_id,
    required this.employee_id,
    required this.employee_name,
    required this.description,
    required this.create_at,
  });

  Map<String, dynamic> toJson() => {
        "history_id": history_id,
        "order_id": order_id,
        "employee_id": employee_id,
        "employee_name": employee_name,
        "description": description,
        "create_at": create_at,
      };

  static OrderHistory fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return OrderHistory(
      history_id: snapshot['history_id'],
      order_id: snapshot['order_id'],
      employee_id: snapshot['employee_id'],
      employee_name: snapshot['employee_name'],
      description: snapshot['description'],
      create_at: snapshot['create_at'],
    );
  }
}
