// ignore_for_file: non_constant_identifier_names

import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class DailyItemCount {
  String daily_item_count_id;
  Double quantity_inventory;
  Double? quantity_ordered;
  Double? quantity_served;
  String quantity_remaining;
  String date_serve;
  String food_id;

  DailyItemCount({
    required this.daily_item_count_id,
    required this.quantity_inventory,
             this.quantity_ordered,
             this.quantity_served,
    required this.quantity_remaining,
    required this.date_serve,
    required this.food_id,
  });

  Map<String, dynamic> toJson() => {
        "daily_item_count_id": daily_item_count_id,
        "quantity_inventory": quantity_inventory,
        "quantity_ordered": quantity_ordered,
        "quantity_served": quantity_served,
        "quantity_remaining": quantity_remaining,
        "date_serve": date_serve,
        "food_id": food_id,
      };

  static DailyItemCount fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return DailyItemCount(
      daily_item_count_id: snapshot['daily_item_count_id'],
      quantity_inventory: snapshot['quantity_inventory'],
      quantity_ordered: snapshot['quantity_ordered'],
      quantity_served: snapshot['quantity_served'],
      quantity_remaining: snapshot['quantity_remaining'],
      date_serve: snapshot['date_serve'],
      food_id: snapshot['food_id'],
    );
  }
}
