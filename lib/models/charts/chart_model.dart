// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';

class ChartModel {
  String title;
  double price;
  int quantity;
  final Color color;
  String id;
  double total_amount;

  ChartModel({
    required this.id,
    required this.total_amount,
    required this.title,
    required this.quantity,
    required this.price,
    required this.color,
  });
}


