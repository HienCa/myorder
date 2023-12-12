// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class Role {
  int role_id;
  String name;

  Role({
    required this.role_id,
    required this.name,
  });

  Map<String, dynamic> toJson() => {
        "role_id": role_id,
        "name": name,
      };

  static Role fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Role(
      role_id: snapshot['role_id'],
      name: snapshot['name'],
    );
  }
}
