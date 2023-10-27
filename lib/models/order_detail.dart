// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myorder/models/food_order_detail.dart';

class OrderDetail {
  String order_detail_id;
  double price;
  int quantity;
  int food_status;
  String food_id;
  String category_id;
  int category_code;
  FoodOrderDetail? food;
  bool is_gift = false;
  bool isSelected = false;
  OrderDetail(
      {required this.order_detail_id,
      required this.price,
      required this.quantity,
      required this.food_status,
      required this.food_id,
      required this.category_id,
      required this.category_code,
      required this.is_gift,
      this.food});

  OrderDetail.copy(OrderDetail other)
      : order_detail_id = other.order_detail_id,
        price = other.price,
        quantity = other.quantity,
        food_status = other.food_status,
        food_id = other.food_id,
        category_id = other.category_id,
        food = other.food,
        is_gift = other.is_gift,
        category_code = other.category_code;

  Map<String, dynamic> toJson() => {
        "order_detail_id": order_detail_id,
        "price": price,
        "quantity": quantity,
        "food_status": food_status,
        "food_id": food_id,
        "category_id": category_id,
        "category_code": category_code,
        "is_gift": is_gift,
      };

  static OrderDetail fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return OrderDetail(
      order_detail_id: snapshot['order_detail_id'],
      price: snapshot['price'],
      quantity: snapshot['quantity'],
      food_status: snapshot['food_status'],
      food_id: snapshot['food_id'],
      category_id: snapshot['category_id'],
      category_code: snapshot['category_code'],
      is_gift: snapshot['is_gift'],
    );
  }
}
