// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class Table {
  String table_id;
  String name;
  int total_slot;
  List? table_merge_ids;
  int status;
  int active;
  String area_id;
 

  Table({
    required this.table_id,
    required this.name,
    required this.total_slot,
             this.table_merge_ids,
    required this.status,
    required this.active,
    required this.area_id,
  });

  Map<String, dynamic> toJson() => {
        "table_id": table_id,
        "name": name,
        "total_slot": total_slot,
        "table_merge_ids": table_merge_ids,
        "status": status,
        "active": active,
        "area_id": area_id,
      };

  static Table fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Table(
      table_id: snapshot['table_id'],
      name: snapshot['name'],
      total_slot: snapshot['total_slot'],
      table_merge_ids: snapshot['table_merge_ids'],
      status: snapshot['status'],
      active: snapshot['active'],
      area_id: snapshot['area_id'],
    );
  }
}
