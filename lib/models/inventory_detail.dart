// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class InventoryDetail {
  String inventory_detail_id;
  String ingredient_id;
  double quantity;
  double? new_quantity;
  double price;


  InventoryDetail({
    required this.inventory_detail_id,
    required this.ingredient_id,
    required this.quantity,
    required this.new_quantity,
    required this.price,

  });

  Map<String, dynamic> toJson() => {
        "inventory_detail_id": inventory_detail_id,
        "ingredient_id": ingredient_id,
        "quantity": quantity,
        "new_quantity": new_quantity,
        "price": price,

      };

  static InventoryDetail fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return InventoryDetail(
      inventory_detail_id: snapshot['inventory_detail_id'],
      ingredient_id: snapshot['ingredient_id'],
      quantity: snapshot['quantity'],
      new_quantity: snapshot['new_quantity'],
      price: snapshot['price'],

    );
  }
}
