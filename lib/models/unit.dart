// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class Unit {
  String unit_id;
  String name;
  int active;

  Unit({
    required this.unit_id,
    required this.name,
    required this.active,
  });

  Map<String, dynamic> toJson() => {
        "unit_id": unit_id,
        "name": name,
        "active": active,
      };

  static Unit fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Unit(
      unit_id: snapshot['unit_id'],
      name: snapshot['name'],
      active: snapshot['active'],
    );
  }
}
