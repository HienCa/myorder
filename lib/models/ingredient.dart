// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myorder/models/recipe_detail.dart';

class Ingredient {
  String ingredient_id;
  String name;
  String unit_id;
  String? image;
  // int is_weight;
  int active;
  bool? isSelected = false;
  RecipeDetail? recipeDetail;
  double? price = 0;
  double? quantity = 0;
  String? unit_name = "";
  Ingredient({
    required this.ingredient_id,
    required this.unit_id,
    required this.name,
    this.image,
    // required this.is_weight ,
    required this.active,
  });
  Ingredient.empty()
      : ingredient_id = '',
        name = '',
        unit_id = '',
        image = '',
        // is_weight  = 0,
        active = 0;

  Map<String, dynamic> toJson() => {
        "ingredient_id": ingredient_id,
        "name": name,
        "unit_id": unit_id,
        "image": image,
        // "is_weight ": is_weight ,
        "active": active,
      };

  static Ingredient fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Ingredient(
      ingredient_id: snapshot['ingredient_id'],
      name: snapshot['name'],
      unit_id: snapshot['unit_id'],
      image: snapshot['image'],
      // is_weight : snapshot['is_weight'],
      active: snapshot['active'],
    );
  }
}
