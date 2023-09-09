// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

void showCustomAlertDialogConfirm(BuildContext context, String title, String subtitle, Future<dynamic> Function() func) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Center(child: Text(title, style: const TextStyle(color: Color(0xFFFFC107)),)),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(subtitle),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('HỦY'),
            onPressed: () {
              Navigator.of(context).pop(); 
            },
          ),
          TextButton(
            child: const Text('XÁC NHẬN'),
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
