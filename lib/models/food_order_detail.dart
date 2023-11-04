// ignore_for_file: non_constant_identifier_names

class FoodOrderDetail {
  String food_id;
  String category_id;
  String name;
  String image;
  List food_combo_ids = [];
  List<dynamic> food_combo_details = [];
  FoodOrderDetail({
    required this.food_id,
    required this.category_id,
    required this.name,
    required this.image,
  });
}