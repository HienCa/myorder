// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:myorder/constants.dart';

void showCustomAlertDialogConfirm(BuildContext context, String title, String subtitle, Color titleColor, Future<dynamic> Function() func) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: backgroundColor,
        title: Center(child: Text(title, style: TextStyle(color: titleColor),)),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(subtitle, style: const TextStyle(color: Colors.black54)),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('HỦY', style: TextStyle(color: Colors.redAccent),),
            onPressed: () {
              Navigator.of(context).pop(); 
            },
          ),
          TextButton(
            child: const Text('XÁC NHẬN', style: TextStyle(color: primaryColor)),
            onPressed: () async {
              
              await func();
              Navigator.of(context).pop(); // Đóng hộp thoại cảnh báo
            },
          ),
        ],
      );
    },
  );
}

// custom bàn phím chọn số lượng người order -> thêm slot vào order
void showCustomAlertDialogConfirmToOrder(BuildContext context, String title, String subtitle, Color titleColor, Future<dynamic> Function() func) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: backgroundColor,
        title: Center(child: Text(title, style: TextStyle(color: titleColor),)),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(subtitle, style: const TextStyle(color: Colors.black54)),
              
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('HỦY', style: TextStyle(color: Colors.redAccent),),
            onPressed: () {
              Navigator.of(context).pop(); 
            },
          ),
          TextButton(
            child: const Text('XÁC NHẬN', style: TextStyle(color: primaryColor)),
            onPressed: () async {
              
              await func();
              Navigator.of(context).pop(); // Đóng hộp thoại cảnh báo
            },
          ),
        ],
      );
    },
  );
}
