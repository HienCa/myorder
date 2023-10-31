// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class ChefBar {
  String chef_bar_id;
  String table_name;

  ChefBar({
    required this.chef_bar_id,
    required this.table_name,
  });

  ChefBar.empty()
      : chef_bar_id = '',
        table_name = '';

  Map<String, dynamic> toJson() => {
        "chef_bar_id": chef_bar_id,
        "table_name": table_name,
      };

  static ChefBar fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return ChefBar(
      chef_bar_id: snapshot['chef_bar_id'],
      table_name: snapshot['table_name'],
    );
  }
}
