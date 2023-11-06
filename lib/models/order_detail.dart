// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myorder/models/food.dart';

class OrderDetail {
  String order_detail_id;
  double price;
  int quantity;
  int food_status;
  int chef_bar_status;
  String food_id;
  String category_id;
  int category_code;
  Food? food;
  bool is_gift = false;
  bool is_addition = false;
  bool isSelected = false;
  List<Food> listCombo = [];
  OrderDetail(
      {required this.order_detail_id,
      required this.price,
      required this.quantity,
      required this.food_status,
      required this.chef_bar_status,
      required this.food_id,
      required this.category_id,
      required this.category_code,
      required this.is_gift,
      required this.is_addition,
      this.food});

  OrderDetail.copy(OrderDetail other)
      : order_detail_id = other.order_detail_id,
        price = other.price,
        quantity = other.quantity,
        food_status = other.food_status,
        food_id = other.food_id,
        category_id = other.category_id,
        food = other.food,
        is_addition = other.is_addition,
        is_gift = other.is_gift,
        chef_bar_status = other.chef_bar_status,
        category_code = other.category_code;

  Map<String, dynamic> toJson() => {
        "order_detail_id": order_detail_id,
        "price": price,
        "quantity": quantity,
        "food_status": food_status,
        "chef_bar_status": chef_bar_status,
        "food_id": food_id,
        "category_id": category_id,
        "category_code": category_code,
        "is_gift": is_gift,
        "is_addition": is_addition,
      };

  static OrderDetail fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return OrderDetail(
      order_detail_id: snapshot['order_detail_id'],
      price: snapshot['price'],
      quantity: snapshot['quantity'],
      food_status: snapshot['food_status'],
      chef_bar_status: snapshot['chef_bar_status'],
      food_id: snapshot['food_id'],
      category_id: snapshot['category_id'],
      category_code: snapshot['category_code'],
      is_gift: snapshot['is_gift'],
      is_addition: snapshot['is_addition'],
    );
  }
}
