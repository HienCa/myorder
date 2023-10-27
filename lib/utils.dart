// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'package:another_flushbar/flushbar.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/models/food_order.dart';
import 'package:myorder/models/order_detail.dart';
import 'package:uuid/uuid.dart';

//Các phương phức hay dùng
class Utils {
  static bool isShowingFlushbar = false;

  //Show Message
  static void showMessage(BuildContext context, String title, String message,
      ContentType contentType) {
    final snackBar = SnackBar(
      /// need to set following properties for best effect of awesome_snackbar_content
      elevation: 1000,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: contentType,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static void showErrorFlushbar(
    BuildContext context,
    String title,
    String message,
  ) {
    if (!isShowingFlushbar) {
      isShowingFlushbar = true;
      Flushbar(
        title: title != "" ? title : "THÔNG BÁO!",
        message: message,
        duration: duration,
        backgroundColor: Colors.redAccent,
        icon: const Icon(Icons.error),
      ).show(context).then((_) {
        // Reset the flag after the Flushbar is dismissed
        isShowingFlushbar = false;
      });
    }
  }

  static void showWarningFlushbar(
    BuildContext context,
    String title,
    String message,
  ) {
    if (!isShowingFlushbar) {
      isShowingFlushbar = true;
      Flushbar(
        title: title.isNotEmpty ? title : "CHÚ Ý!",
        message: message,
        duration: duration,
        backgroundColor: colorWarning,
        icon: const Icon(Icons.warning),
      ).show(context).then((_) {
        // Reset the flag after the Flushbar is dismissed
        isShowingFlushbar = false;
      });
    }
  }

  static void showSuccessFlushbar(
    BuildContext context,
    String title,
    String message,
  ) {
    if (!isShowingFlushbar) {
      isShowingFlushbar = true;
      Flushbar(
        title: title != "" ? title : "THÀNH CÔNG!",
        message: message,
        duration: duration,
        backgroundColor: Colors.green,
        icon: const Icon(Icons.check),
      ).show(context).then((_) {
        // Reset the flag after the Flushbar is dismissed
        isShowingFlushbar = false;
      });
    }
  }

  //Push Screen

  //Pop Screen
  static void myPopResult(BuildContext context, dynamic result) {
    Navigator.pop(context, result);
  }

  //Pop Screen Success
  static void myPopSuccess(BuildContext context) {
    Navigator.pop(context, 'success');
  }

  //Pop Screen Cancel
  static void myPopCancel(BuildContext context) {
    Navigator.pop(context, 'cancel');
  }

//Pop Screen
  static void myPop(BuildContext context) {
    Navigator.pop(context);
  }

  //Tạo id
  static String generateUUID() {
    const uuid = Uuid();
    return uuid.v4();
  }

  //
  static List<Map<String, dynamic>> convertQuerySnapshotToJson(
      QuerySnapshot querySnapshot) {
    final List<Map<String, dynamic>> jsonData = [];
    for (final doc in querySnapshot.docs) {
      jsonData.add(doc.data() as Map<String, dynamic>);
    }
    return jsonData;
  }

  static String showDataJson(QuerySnapshot querySnapshot) {
    print(convertQuerySnapshotToJson(querySnapshot));
    return "";
  }

  //datetime
  static bool isDateTimeInRange(
      Timestamp startTimestamp, Timestamp endTimestamp) {
    DateTime currentDateTime = DateTime.now();
    DateTime startTime = startTimestamp.toDate();
    DateTime endTime = endTimestamp.toDate();
    return currentDateTime.isAfter(startTime) &&
        currentDateTime.isBefore(endTime);
  }

  static String convertTimestampToFormatDateVN(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate(); // Get the DateTime object
    String formattedDateTime = DateFormat('dd/MM/yyyy HH:mm')
        .format(dateTime); // Format DateTime as a string
    return formattedDateTime;
  }

  static String convertTextFieldPrice(String input) {
    final formatter = NumberFormat("#,###");
    return formatter.format(int.parse(input));
  }

  static String formatCurrency(double? amount) {
    final formattedNumber = NumberFormat("#,###", "en_US").format(amount);
    // print(formattedNumber);
    // print("formattedNumber");
    return formattedNumber;
  }

  static bool isAnyFoodSelected(List<FoodOrder> foods) {
    for (var food in foods) {
      if (food.isSelected == true) {
        // Có ít nhất một đối tượng đã được chọn
        return true;
      }
    }
    // Không có đối tượng nào được chọn
    return false;
  }

  static bool isAnyOrderDetailSelected(List<OrderDetail> foods) {
    for (var food in foods) {
      if (food.isSelected == true) {
        return true;
      }
    }
    return false;
  }

  static void refeshSelected(List<dynamic> array) {
    for (var item in array) {
      if (item.isSelected == true) {
        item.isSelected = false;
        print("refeshSelected");
      }
    }
  }

  //Đếm số lượng orderDetail muốn thay đổi
  static int counterOrderDetailSelected(List<OrderDetail> foods) {
    int count = 0;
    for (var food in foods) {
      if (food.isSelected == true) {
        count++;
      }
    }
    return count;
  }

  static bool isQuantityChanged(
      List<OrderDetail> orderDetailsOrigin, OrderDetail orderDetails) {
    for (int i = 0; i < orderDetailsOrigin.length; i++) {
      if (orderDetailsOrigin[i].order_detail_id ==
              orderDetails.order_detail_id &&
          orderDetailsOrigin[i].quantity != orderDetails.quantity) {
        return true;
      }
    }

    // Không có sự thay đổi
    return false;
  }
  // static bool isAnyOrderDetailChange(
  //     List<OrderDetail> orderDetailsOrigin, List<OrderDetail> orderDetails) {
  //   if (orderDetailsOrigin.length != orderDetails.length) {
  //     // Nếu số lượng phần tử không giống nhau, có thay đổi
  //     return true;
  //   }

  //   // Sắp xếp cả hai danh sách theo order_detail_id để so sánh từng cặp phần tử
  //   orderDetailsOrigin
  //       .sort((a, b) => a.order_detail_id.compareTo(b.order_detail_id));
  //   orderDetails.sort((a, b) => a.order_detail_id.compareTo(b.order_detail_id));

  //   for (int i = 0; i < orderDetailsOrigin.length; i++) {
  //     if (orderDetailsOrigin[i].quantity != orderDetails[i].quantity) {
  //       // Nếu order_detail_id hoặc quantity có sự khác biệt, có thay đổi
  //       return true;
  //     }
  //   }

  //   // Không có sự thay đổi
  //   return false;
  // }

  static bool isAnyFoodSelected2(List<OrderDetail> foods) {
    for (var food in foods) {
      if (food.isSelected == true) {
        // Có ít nhất một đối tượng đã được chọn
        return true;
      }
    }
    // Không có đối tượng nào được chọn
    return false;
  }

  //VD: 1,000,000 -> 1000000 (string)
  static String formatCurrencytoDouble(String amount) {
    return amount.replaceAll(RegExp(r','), "");
  }

  //VD: 1,000,000 -> 1000000 (double)
  static double stringConvertToDouble(String amount) {
    double formattedAmount =
        double.tryParse(amount.replaceAll(RegExp(r','), "")) ?? 0;
    return formattedAmount;
  }

  //block special characterset
  static String getFormattedDateSimple(int time) {
    DateFormat newFormat = DateFormat("MMMM dd, yyyy");
    return newFormat.format(DateTime.fromMillisecondsSinceEpoch(time));
  }

  //block space
  static String removeWhitespace(String input) {
    return input.replaceAll(' ', '');
  }

  //checkMail
  static isValidEmail(String email) {
    final RegExp regex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return regex.hasMatch(email);
  }

  //checkPhone
  static bool startsWithZero(String phoneNumber) {
    return phoneNumber.startsWith('0');
  }

  //check number of characters
  static bool isStringLengthValid(String input,
      {int minLength = 0, int maxLength = 255}) {
    int length = input.length;
    return length >= minLength && length <= maxLength;
  }

  static getValidSubstring(String input, int maxLength) {
    if (input.length > maxLength) {
      return input.substring(0, maxLength);
    } else {
      return input;
    }
  }

  //check string and number
  static String getValidCharacters(String input) {
    final RegExp regex = RegExp(r'[a-zA-Z0-9]');
    return input.split('').where((char) => regex.hasMatch(char)).join('');
  }

  // get valid string
  String getValidText(String input) {
    final RegExp regex = RegExp(r'[a-zA-Z]+');
    final Iterable<Match> matches = regex.allMatches(input);
    final List<String> validMatches =
        matches.map((match) => match.group(0)!).toList();
    final String validText = validMatches.join('');
    return validText;
  }
}
