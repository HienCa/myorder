// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/utils.dart';
import 'package:myorder/views/widgets/textfields/text_field_label/text_field_number.dart';

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
          child: Center(
            child: ListBody(
              children: <Widget>[
                Text(subtitle, style: const TextStyle(color: Colors.black54)),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () => {Utils.myPopResult(context, 'DEFAULT')},
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
                  // Utils.showToast('Thêm món thành công!', TypeToast.SUCCESS,
                  //     toastGravity: ToastGravity.CENTER),
                  Navigator.pop(context)
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
        ],
      );
    },
  );
}

void showCustomAlertDialogConfirmOrder(
    BuildContext context,
    String title,
    String subtitle,
    Color titleColor,
    TextEditingController textEditController,
    int max,
    Future<dynamic> Function() func, bool isRotatedBox) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
     
      return  AlertDialog(
          backgroundColor: backgroundColor,
          title: Center(
              child: Text(
            title,
            style: TextStyle(color: titleColor),
          )),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                // Text(subtitle, style: const TextStyle(color: Colors.black54)),
                MyTextFieldNumber(
                  textController: textEditController,
                  label: 'Số khách (tối đa: $max)',
                  placeholder: 'Nhập số lượng...',
                  isReadOnly: false,
                  min: 1,
                  max: max,
                  isRequire: true,
                )
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () => {Utils.myPopResult(context, 'DEFAULT')},
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
                    if ((int.tryParse(textEditController.text) ?? 0) > 0)
                      {
                        await func(),
                        Utils.showToast('Đặt bàn thành công!', TypeToast.SUCCESS,
                            toastGravity: ToastGravity.CENTER),
                        Navigator.pop(context)
                      }
                    else
                      {
                        Utils.showToast(
                            'Vui lòng nhập số lượng khách!', TypeToast.ERROR,
                            toastGravity: ToastGravity.CENTER)
                      },
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
