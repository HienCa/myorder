// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class Area {
  String area_id;
  String name;
  int active;
 

  Area({
    required this.area_id,
    required this.name,
    required this.active,
  });

  Map<String, dynamic> toJson() => {
        "area_id": area_id,
        "name": name,
        "active": active,
      };

  static Area fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Area(
      area_id: snapshot['area_id'],
      name: snapshot['name'],
      active: snapshot['active'],
    );
  }
}
