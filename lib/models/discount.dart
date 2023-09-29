// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class Discount {
  String discount_id;
  String name;
  int discount_price;
  int active;

  Discount({
    required this.discount_id,
    required this.name,
    required this.discount_price,
    required this.active,
  });

  Map<String, dynamic> toJson() => {
        "discount_id": discount_id,
        "name": name,
        "discount_price": discount_price,
        "active": active,
      };

  static Discount fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Discount(
      discount_id: snapshot['discount_id'],
      name: snapshot['name'],
      discount_price: snapshot['discount_price'],
      active: snapshot['active'],
    );
  }
}
