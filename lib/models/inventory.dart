// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class Inventory {
  String inventory_id;
  String code;
  String employee_id;
  String employee_name;
  Timestamp created_at;
  String note;
  int vat;
  int status;
  double discount;
  int active;

  Inventory({
    required this.inventory_id,
    required this.code,
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
        "inventory_id": inventory_id,
        "code": code,
        "employee_id": employee_id,
        "employee_name": employee_name,
        "created_at": created_at,
        "note": note,
        "vat": vat,
        "discount": discount,
        "active": active,
        "status": status,
      };

  static Inventory fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Inventory(
      inventory_id: snapshot['inventory_id'],
      code: snapshot['code'],
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
