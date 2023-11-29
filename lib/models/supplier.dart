// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class Supplier {
  String supplier_id;
  String name;
  String? avatar;
  String phone;
  String email;
  String address;
  String note;
  int active;

  Supplier({
    required this.supplier_id,
    required this.name,
    this.avatar,
    required this.phone,
    required this.email,
    required this.address,
    required this.note,
    required this.active,
  });

  Map<String, dynamic> toJson() => {
        "supplier_id": supplier_id,
        "name": name,
        "avatar": avatar,
        "phone": phone,
        "email": email,
        "address": address,
        "note": note,
        "active": active,
      };

  static Supplier fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Supplier(
      supplier_id: snapshot['supplier_id'],
      name: snapshot['name'],
      avatar: snapshot['avatar'],
      phone: snapshot['phone'],
      email: snapshot['email'],
      address: snapshot['address'],
      note: snapshot['note'],
      active: snapshot['active'],
    );
  }
}
