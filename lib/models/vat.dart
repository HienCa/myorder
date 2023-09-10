// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class Vat {
  String vat_id;
  String name;
  int vat_percent;
  int active;

  Vat({
    required this.vat_id,
    required this.name,
    required this.vat_percent,
    required this.active,
  });

  Map<String, dynamic> toJson() => {
        "vat_id": vat_id,
        "name": name,
        "vat_percent": vat_percent,
        "active": active,
      };

  static Vat fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Vat(
      vat_id: snapshot['vat_id'],
      name: snapshot['name'],
      vat_percent: snapshot['vat_percent'],
      active: snapshot['active'],
    );
  }
}
