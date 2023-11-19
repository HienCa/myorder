// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  String recipe_id;
  String name;
  String food_id;
  int active;


  Recipe({
    required this.recipe_id,
    required this.food_id,
    required this.name,
    required this.active,
  });
  Recipe.empty()
      : recipe_id = '',
        name = '',
        food_id = '',
        // is_weight  = 0,
        active = 0;

  Map<String, dynamic> toJson() => {
        "ingredient_id": recipe_id,
        "name": name,
        "food_id": food_id,
        "active": active,
        
      };

  static Recipe fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Recipe(
      recipe_id: snapshot['recipe_id'],
      name: snapshot['name'],
      food_id: snapshot['food_id'],
      active: snapshot['active'],
    );
  }
}
