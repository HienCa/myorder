// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeDetail {
  String ingredient_id;
  double quantity;
  String unit_id;
  bool isSelected = false;
  double? new_quantity;

  RecipeDetail({
    required this.ingredient_id,
    required this.quantity,
    required this.unit_id,
  });
  RecipeDetail.empty()
      : ingredient_id = '',
        quantity = 0,
        unit_id = '';

  Map<String, dynamic> toJson() => {
        "ingredient_id": ingredient_id,
        "quantity": quantity,
        "unit_id": unit_id,
      };

  static RecipeDetail fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return RecipeDetail(
      ingredient_id: snapshot['ingredient_id'],
      quantity: snapshot['quantity'],
      unit_id: snapshot['unit_id'],
    );
  }
}
