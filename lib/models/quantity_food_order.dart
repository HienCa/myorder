// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

// Sếp hoặc bếp phải chốt số lượng muốn bán trong 1 ngày của mỗi món trước ngày hoạt động tiếp theo.
/*
Sau đó mới lên kế hoạch nhập kho nguyên liệu với theo số lượng muốn bán theo ngày hoặc ngày
vd 1 ngày muốn có thể cung cấp 100 thùng bia. thì mới biết cần nhập số lượng bao nhiêu cho đủ hoặc nhập hơn

Khi đã có số lượng cụ thể của từng món cần phục vụ trong ngày hôm đó.
Thì nhân viên kho sẽ dựa vào số lượng này để nhập kho đẻ đảm bảo số lượng cần phục vụ của quán.
Nếu chỉ nhập kho mà không có số lượng thì sẽ xảy ra nhập thừa thiếu số lượng món cần phục vụ
 */
class QuantityFoodOrder {
  String quantity_food_order_id;
  String food_id;
  double max_order_limit;
  double current_order_count;
  Timestamp? start_date_time;
  Timestamp? end_date_time;
  Timestamp create_at;
  int active;

  QuantityFoodOrder({
    required this.quantity_food_order_id,
    required this.food_id,
    required this.max_order_limit,
    required this.current_order_count,
    required this.start_date_time,
    required this.end_date_time,
    required this.create_at,
    required this.active,
  });
  
  QuantityFoodOrder.empty()
      : quantity_food_order_id = "",
        food_id = "",
        max_order_limit = 0,
        active = 1,
        current_order_count = 0,
        start_date_time = null,
        end_date_time = null,
        create_at = Timestamp.now();

  Map<String, dynamic> toJson() => {
        "quantity_food_order_id": quantity_food_order_id,
        "food_id": food_id,
        "max_order_limit": max_order_limit,
        "current_order_count": current_order_count,
        "start_date_time": start_date_time,
        "end_date_time": end_date_time,
        "create_at": create_at,
        "active": active,
      };

  static QuantityFoodOrder fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return QuantityFoodOrder(
      quantity_food_order_id: snapshot['quantity_food_order_id'],
      food_id: snapshot['food_id'],
      max_order_limit: snapshot['max_order_limit'],
      current_order_count: snapshot['current_order_count'],
      start_date_time: snapshot['start_date_time'],
      end_date_time: snapshot['end_date_time'],
      create_at: snapshot['create_at'],
      active: snapshot['active'],
    );
  }
}
