// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class FoodOrderDetail {
  String food_id;
  String name;
  String image;
  FoodOrderDetail({
    required this.food_id,
    required this.name,
    required this.image,
  });
}