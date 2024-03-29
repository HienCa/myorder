// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  String category_id;
  int category_code;
  String name;
  int active;

  Category({
    required this.category_id,
    required this.category_code,
    required this.name,
    required this.active,
  });

  Map<String, dynamic> toJson() => {
        "category_id": category_id,
        "category_code": category_code,
        "name": name,
        "active": active,
      };

  static Category fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Category(
      category_id: snapshot['category_id'],
      category_code: snapshot['category_code'],
      name: snapshot['name'],
      active: snapshot['active'],
    );
  }
}
