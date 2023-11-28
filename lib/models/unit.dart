// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class Unit {
  String unit_id;
  String name;
  String unit_id_conversion;
  int value_conversion;
  String unit_name_conversion;
  int active;

  Unit({
    required this.unit_id,
    required this.name,
    required this.active,
    required this.value_conversion,
    required this.unit_id_conversion,
    required this.unit_name_conversion,
  });

  Map<String, dynamic> toJson() => {
        "unit_id": unit_id,
        "name": name,
        "active": active,
        "value_conversion": value_conversion,
        "unit_id_conversion": unit_id_conversion,
        "unit_name_conversion": unit_name_conversion,
      };

  static Unit fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Unit(
      unit_id: snapshot['unit_id'],
      name: snapshot['name'],
      active: snapshot['active'],
      value_conversion: snapshot['value_conversion'],
      unit_id_conversion: snapshot['unit_id_conversion'],
      unit_name_conversion: snapshot['unit_name_conversion'],
    );
  }
}
