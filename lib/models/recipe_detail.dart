// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeDetail {
  String recipe_detail_id;
  String ingredient_id;
  String name;
  double quantity;
  String unit_name;
  bool isSelected = false;
  double? new_quantity;

  RecipeDetail({
    required this.recipe_detail_id,
    required this.name,
    required this.ingredient_id,
    required this.quantity,
    required this.unit_name,
  });
  RecipeDetail.empty()
      : recipe_detail_id = '',
      name = '',
      ingredient_id = '',
        quantity = 0,
        unit_name = '';

  Map<String, dynamic> toJson() => {
        "recipe_detail_id": recipe_detail_id,
        "name": name,
        "ingredient_id": ingredient_id,
        "quantity": quantity,
        "unit_name": unit_name,
      };

  static RecipeDetail fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return RecipeDetail(
      recipe_detail_id: snapshot['recipe_detail_id'] ?? "",
      name: snapshot['name'] ?? "",
      ingredient_id: snapshot['ingredient_id'] ?? "",
      quantity: snapshot['quantity'] ?? 0,
      unit_name: snapshot['unit_name'] ?? "",
    );
  }
}
