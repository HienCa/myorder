// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class Specifications {
  String specification_id;
  String name;
  int exchange_value;
  int active;

  Specifications({
    required this.specification_id,
    required this.name,
    required this.exchange_value,
    required this.active,
  });

  Map<String, dynamic> toJson() => {
        "specification_id": specification_id,
        "name": name,
        "exchange_value": exchange_value,
        "active": active,
      };

  static Specifications fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Specifications(
      specification_id: snapshot['specification_id'],
      name: snapshot['name'],
      exchange_value: snapshot['exchange_value'],
      active: snapshot['active'],
    );
  }
}
