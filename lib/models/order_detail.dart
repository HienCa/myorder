// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myorder/models/food_order_detail.dart';

class OrderDetail {
  String order_detail_id;
  double price;
  int quantity;
  int food_status;
  String food_id;
  FoodOrderDetail? food;
  OrderDetail({
    required this.order_detail_id,
    required this.price,
    required this.quantity,
    required this.food_status,
    required this.food_id,
    this.food
  });

  Map<String, dynamic> toJson() => {
        "order_detail_id": order_detail_id,
        "price": price,
        "quantity": quantity,
        "food_status": food_status,
        "food_id": food_id,
      };

  static OrderDetail fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return OrderDetail(
      order_detail_id: snapshot['order_detail_id'],
      price: snapshot['price'],
      quantity: snapshot['quantity'],
      food_status: snapshot['food_status'],
      food_id: snapshot['food_id'],
    );
  }
}
