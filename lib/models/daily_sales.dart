// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myorder/models/food.dart';

class DailySales {
  String daily_sale_id;
  String name;
  Timestamp date_apply;
  int active;
  List<DailySaleDetail>? dailySaleDetails;

  DailySales({
    required this.daily_sale_id,
    required this.name,
    required this.date_apply,
    required this.active,
  });

  Map<String, dynamic> toJson() => {
        "daily_sale_id": daily_sale_id,
        "name": name,
        "date_apply": date_apply,
        "active": active,
      };

  static DailySales fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return DailySales(
      daily_sale_id: snapshot['daily_sale_id'],
      name: snapshot['name'],
      date_apply: snapshot['date_apply'],
      active: snapshot['active'],
    );
  }
}

class DailySaleDetail {
  String daily_sale_detail_id;
  String food_id;
  Food? food;
  int quantity_for_sell;
  int? new_quantity_for_sell;
  int active;
  bool? isSelected;
  DailySaleDetail({
    required this.daily_sale_detail_id,
    required this.food_id,
    required this.quantity_for_sell,
    required this.active,
  });

  Map<String, dynamic> toJson() => {
        "daily_sale_detail_id": daily_sale_detail_id,
        "food_id": food_id,
        "quantity_for_sell": quantity_for_sell,
        "active": active,
      };

  static DailySaleDetail fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return DailySaleDetail(
      daily_sale_detail_id: snapshot['daily_sale_detail_id'],
      food_id: snapshot['food_id'],
      quantity_for_sell: snapshot['quantity_for_sell'],
      active: snapshot['active'],
    );
  }
}
