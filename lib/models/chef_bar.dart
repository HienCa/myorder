// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class ChefBar {
  String chef_bar_id;
  String table_name;
  // String area_id;
  Timestamp create_at;
  int quantity;
  // bool isSelected = false;
  String? area_name;
  ChefBar({
    required this.chef_bar_id,
    required this.table_name,
    // required this.area_id,
    required this.create_at,
    required this.quantity,
  });

  ChefBar.empty()
      : chef_bar_id = '',
        create_at = Timestamp.now(),
        quantity = 0,
        // area_id = "",
        table_name = '';

  Map<String, dynamic> toJson() => {
        "chef_bar_id": chef_bar_id,
        "table_name": table_name,
        // "area_id": area_id,
        "quantity": quantity,
        "create_at": create_at,
      };

  static ChefBar fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return ChefBar(
      chef_bar_id: snapshot['chef_bar_id'],
      table_name: snapshot['table_name'],
      // area_id: snapshot['area_id'],
      quantity: snapshot['quantity'],
      create_at: snapshot['create_at'],
    );
  }
}
