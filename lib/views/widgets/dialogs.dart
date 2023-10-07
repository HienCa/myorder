// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:myorder/constants.dart';

Future<void> showAlertDialogButtons(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        // <-- SEE HERE
        title: const Text('Cancel booking'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Are you sure want to cancel booking?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Yes'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<void> showAlertDialog(
    BuildContext context, String title, String subtitle) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(subtitle),
            ],
          ),
        ),
      );
    },
  );
}

void showCustomAlertDialogConfirm(BuildContext context, String title,
    String subtitle, Color titleColor, Future<dynamic> Function() func) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: backgroundColor,
        title: Center(
            child: Text(
          title,
          style: TextStyle(color: titleColor),
        )),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(subtitle, style: const TextStyle(color: Colors.black54)),
            ],
          ),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () => {
                  Navigator.pop(context),
                },
                child: Expanded(
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 3,
                    color: backgroundColorCancel,
                    child: const Center(
                      child: Text(
                        'HỦY',
                        style: buttonStyleCancel,
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async => {await func(), Navigator.pop(context)},
                child: Expanded(
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 3,
                    color: primaryColor,
                    child: const Center(
                      child: Text(
                        'XÁC NHẬN',
                        style: buttonStyleConfirm,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      );
    },
  );
}

void showCustomAlertDialogConfirmCancelOrder(BuildContext context, String title,
    String subtitle, Color titleColor, Future<dynamic> Function() func) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: backgroundColor,
        title: Center(
            child: Text(
          title,
          style: TextStyle(color: titleColor),
        )),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(subtitle, style: const TextStyle(color: Colors.black54)),
            ],
          ),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () => {Navigator.pop(context), Navigator.pop(context)},
                child: Expanded(
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 3,
                    color: backgroundColorCancel,
                    child: const Center(
                      child: Text(
                        'HỦY',
                        style: buttonStyleCancel,
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async => {
                  await func(),
                },
                child: Expanded(
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 3,
                    color: primaryColor,
                    child: const Center(
                      child: Text(
                        'XÁC NHẬN',
                        style: buttonStyleConfirm,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          // TextButton(
          //   child: const Text(
          //     'HỦY',
          //     style: TextStyle(color: Colors.redAccent),
          //   ),
          //   onPressed: () {
          //     Navigator.of(context).pop();
          //   },
          // ),
          // TextButton(
          //   child:
          //       const Text('XÁC NHẬN', style: TextStyle(color: primaryColor)),
          //   onPressed: () async {
          //     await func();
          //     Navigator.of(context).pop(); // Đóng hộp thoại cảnh báo
          //   },
          // ),
        ],
      );
    },
  );
}

// custom bàn phím chọn số lượng người order -> thêm slot vào order
void showCustomAlertDialogConfirmToOrder(BuildContext context, String title,
    String subtitle, Color titleColor, Future<dynamic> Function() func) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: backgroundColor,
        title: Center(
            child: Text(
          title,
          style: TextStyle(color: titleColor),
        )),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(subtitle, style: const TextStyle(color: Colors.black54)),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'HỦY',
              style: TextStyle(color: Colors.redAccent),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child:
                const Text('XÁC NHẬN', style: TextStyle(color: primaryColor)),
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
