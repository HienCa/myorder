// ignore_for_file: depend_on_referenced_packages, avoid_print, constant_identifier_names

import 'package:another_flushbar/flushbar.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/models/food.dart';
import 'package:myorder/models/food_combo.dart';
import 'package:myorder/models/food_order.dart';
import 'package:myorder/models/order_detail.dart';
import 'package:stylish_dialog/stylish_dialog.dart';
import 'package:uuid/uuid.dart';

enum TypeToast {
  SUCCESS,
  ERROR,
  WARNING,
  INFO,
  NORMAL,
}

//Các phương phức hay dùng
class Utils {
  //SCREEN
  static bool isLandscapeOrientation(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  //DATETIME
  static String formatTimestamp(Timestamp? timestamp) {
    if (timestamp != null) {
      var dateTime = timestamp.toDate();
      var formatter = DateFormat('dd/MM/yyyy');
      return formatter.format(dateTime);
    } else {
      return '';
    }
  }

  static String formatTime(Timestamp? timestamp) {
    if (timestamp != null) {
      var dateTime = timestamp.toDate();
      var formatter = DateFormat('HH:mm:ss');
      return formatter.format(dateTime);
    } else {
      return '';
    }
  }

  //DATETIME
  static String formatDatetime(DateTime? datetime) {
    if (datetime != null) {
      var formatter = DateFormat('dd/MM/yyyy HH:mm:ss');
      return formatter.format(datetime);
    } else {
      return '';
    }
  }

  static Timestamp convertDatetimeToTimestamp(DateTime datetime) {
    return Timestamp.fromDate(DateTime.parse(datetime.toString()));
  }

  //TIME BOOKING
  //KIỂM TRA TRƯỚC GIỜ BOOKING 30P VÀ TRỄ 1H
  static bool isNearBookingTime(Timestamp? timeBooking) {
    if (timeBooking != null) {
      // Lấy thời gian hiện tại
      final currentTime = Timestamp.now().toDate();

      // Lấy thời gian đặt hàng dưới dạng DateTime
      final bookingDateTime = timeBooking.toDate();

      // Đặt thời gian cảnh báo trước (ví dụ: 30 phút)
      const alertThreshold = Duration(minutes: 30);

      // Đặt thời gian kiểm tra sau đặt hàng (ví dụ: 1 giờ)
      const checkTimeAfterBooking = Duration(hours: 1);

      // Tính thời gian 30 phút trước thời gian đặt hàng
      final startTime = bookingDateTime.subtract(alertThreshold);

      // Tính thời gian 1 giờ sau thời gian đặt hàng
      final endTime = bookingDateTime.add(checkTimeAfterBooking);

      // Kiểm tra xem thời gian hiện tại có nằm trong khoảng từ startTime đến endTime không
      return currentTime.isAfter(startTime) && currentTime.isBefore(endTime);
    }
    return false;
  }

  //KIỂM TRA SAU GIỜ BOOKING 1H
  static bool isAfterOneHourFromBookingTime(Timestamp? timeBooking) {
    if (timeBooking != null) {
// Lấy thời gian hiện tại
      final currentTime = Timestamp.now().toDate();

      // Lấy thời gian đặt hàng dưới dạng DateTime
      final bookingDateTime = timeBooking.toDate();

      // Đặt thời gian kiểm tra sau đặt hàng (ví dụ: 1 giờ)
      const checkTimeAfterBooking = Duration(hours: 1);

      // Tính thời gian 1 giờ sau thời gian đặt hàng
      final endTime = bookingDateTime.add(checkTimeAfterBooking);

      // Kiểm tra xem thời gian hiện tại có nằm sau 1 giờ kể từ thời gian đặt hàng không
      return currentTime.isAfter(endTime);
    } else {
      return false;
    }
  }

  static bool isValidDateTime(String time, DateTime? startTime) {
    if (startTime != null && time != "") {
      final currentTime = DateTime.parse(time);

      final startDateTime = startTime;

      return currentTime.isAfter(startDateTime);
    } else {
      return false;
    }
  }

  //Lọc món theo category_code
  static List<Food> filterCategoryFood(List<Food> list, int categoryCode) {
    List<Food> filteredList = [];
    for (Food food in list) {
      if (food.category_code == categoryCode) {
        filteredList.add(food);
      }
    }
    return filteredList;
  }

  //Số phần tử cần render khi thuộc food_caterogy
  static double getHeightRecommentFoodSelected(
      List<Food> list, int categoryCode) {
    double count = 0;
    for (Food food in list) {
      if (food.category_code == categoryCode) {
        count++;
      }
    }
    count = count * 60;
    if (count > 200) {
      return 200;
    }
    return count;
  }

  //Số phần tử cần render khi thuộc food_caterogy
  static double getHeightRecommentAdditionFoodSelected(List<Food> list) {
    double count = 0;

    count = list.length * 60;
    if (count > 200) {
      return 200;
    }
    return count;
  }

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
      Timestamp? startTimestamp, Timestamp? endTimestamp) {
    if (startTimestamp == null || endTimestamp == null) {
      return false;
    } else {
      DateTime currentDateTime = DateTime.now();
      DateTime startTime = startTimestamp.toDate();
      DateTime endTime = endTimestamp.toDate();
      return currentDateTime.isAfter(startTime) &&
          currentDateTime.isBefore(endTime);
    }
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

  static bool isCheckedAll(List<OrderDetail> foods) {
    for (var food in foods) {
      print(food.food!.name);
      print(food.isSelected);

      if (food.isSelected == false) {
        return false;
      }
    }
    return true;
  }

  static void checkAll(List<OrderDetail> foods) {
    for (var food in foods) {
      food.isSelected = true;
    }
  }

  static void unCheckAll(List<OrderDetail> foods) {
    for (var food in foods) {
      food.isSelected = false;
      print(food.food!.name);
    }
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

  static bool isSelected(dynamic item) {
    print('Name:${item.name} - ${item.isSelected}');
    if (item.isSelected == true) {
      return true;
    }
    return false;
  }

  static List<dynamic> filterSelected(List<dynamic> list) {
    List<dynamic> fliteredList = [];
    for (var item in list) {
      if (item.isSelected == true) {
        fliteredList.add(item);
      }
    }
    return fliteredList;
  }

  static List<FoodOrder> filterSelectedCategory(
      List<FoodOrder> list, int categoryCode) {
    List<FoodOrder> fliteredList = [];
    for (var item in list) {
      //Nếu có category thì lọc theo category, nếu truyền vào CATEGORY_ALL thì lấy tất cả selected
      if (categoryCode == CATEGORY_ALL) {
        if (item.isSelected == true) {
          fliteredList.add(item);
        }
      } else {
        if (item.isSelected == true && item.category_code == categoryCode) {
          fliteredList.add(item);
        }
      }
    }
    return fliteredList;
  }

  static List<String> filterFoodIdsSelected(List<Food> list) {
    List<String> listFoodIds = [];
    for (var item in list) {
      if (item.isSelected == true) {
        listFoodIds.add(item.food_id);
      }
    }
    return listFoodIds;
  }

  static List<FoodCombo> filterFoodComboSelected(List<FoodCombo> list) {
    List<FoodCombo> fliteredList = [];
    for (var item in list) {
      if (item.isSelected == true) {
        FoodCombo foodCombo = FoodCombo(
            food_id: item.food_id,
            name: item.name,
            category_code: item.category_code,
            price: item.price,
            active: item.active,
            category_id: item.category_id,
            unit_id: item.unit_id,
            temporary_percent: item.temporary_percent,
            temporary_price_from_date: item.temporary_price_from_date,
            temporary_price_to_date: item.temporary_price_to_date,
            listFood: []);
        fliteredList.add(foodCombo);
      }
    }
    return fliteredList;
  }

  //Đếm số lượng food muốn thay đổi
  static int counterSelected(List<dynamic> list) {
    int count = 0;
    for (var item in list) {
      if (item.isSelected == true) {
        count++;
      }
    }
    return count;
  }

  static bool isAnySelected(List<dynamic> foods) {
    for (var food in foods) {
      if (food.isSelected == true) {
        // Có ít nhất một đối tượng đã được chọn
        return true;
      }
    }
    // Không có đối tượng nào được chọn
    return false;
  }

  static bool isAnyFoodCooking(List<OrderDetail> foods) {
    for (var food in foods) {
      if (food.food_status == FOOD_STATUS_COOKING ||
          food.food_status == FOOD_STATUS_IN_CHEF) {
        return true;
      }
    }
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

  //Tính tổng tiền theo total_amount
  static double getSumTotalAmount(List<dynamic> list) {
    double total = 0;
    for (var item in list) {
      total += item.total_amount;
    }
    return total;
  }

  //Tính tổng tiền theo total_amount
  static double getSumPriceQuantity(List<dynamic> list) {
    double total = 0;
    for (var item in list) {
      if (item.isGift == false) {
        total += (item.price * item.quantity);
      }
    }
    return total;
  }

  //Tính tổng tiền theo total_amount
  static double getSumPriceQuantitySelected(List<dynamic> list) {
    double total = 0;
    for (var item in list) {
      if (item.isGift == false) {
        if (item.isSelected == true &&
            Utils.isDateTimeInRange(
                item.temporary_price_from_date, item.temporary_price_to_date)) {
          total += ((item.price_with_temporary ?? 0) * item.quantity);
        } else if (item.isSelected == true) {
          total += (item.price * item.quantity);
        }
      }
    }
    return total;
  }

  //Tính tổng tiền theo price * quantity theo category
  static double getSumPriceQuantityCategory(
      List<FoodOrder> list, int categoryCode) {
    list = filterSelectedCategory(list, categoryCode);
    double total = 0;
    for (var item in list) {
      if (Utils.isDateTimeInRange(
          item.temporary_price_from_date, item.temporary_price_to_date)) {
        total += ((item.price_with_temporary ?? 0) * (item.quantity ?? 1));
      } else {
        total += (item.price * (item.quantity ?? 1));
      }
    }
    return total;
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

  //Đếm số lượng orderDetail muốn thay đổi
  static int counterCancelStatusOrderDetailSelected(List<OrderDetail> foods) {
    int count = 0;
    for (var food in foods) {
      if (food.isSelected == true && food.food_status == FOOD_STATUS_IN_CHEF) {
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

  //BEGIN=========================VALIDATE TEXT FIELD===========================
  //String
  static bool isValidLengthString(String string, int min, int max) {
    if (string.trim().length >= min && string.trim().length <= max) {
      return true;
    } else {
      return false;
    }
  }

  //String
  static bool isValidRangeString(String string, int min, int max) {
    if ((int.tryParse(string) ?? 0) >= min &&
        (int.tryParse(string) ?? 0) <= max) {
      return true;
    } else {
      return false;
    }
  }

  //TextEditingController
  static bool isValidLengthTextEditController(
      TextEditingController textEditingController, int min, int max) {
    if (textEditingController.text.trim().length >= min &&
        textEditingController.text.trim().length <= max) {
      return true;
    } else {
      return false;
    }
  }

  //TextEditingController
  static bool isValidRangeTextEditController(
      TextEditingController textEditingController, int min, int max) {
    if ((int.tryParse(textEditingController.text) ?? 0) >= min &&
        (int.tryParse(textEditingController.text) ?? 0) <= max) {
      return true;
    } else {
      return false;
    }
  }

  //END============================VALIDATE TEXT FIELD==========================

  //BEGIN===============================DIALOG==================================

  //Link: https://pub.dev/packages/stylish_dialog

  //VÍ DỤ

  //Utils.showStylishDialog(context,'THÔNG BÁO', 'Vui lòng nhập đầy đủ các trường', StylishDialogType.NORMAL);
  //Utils.showStylishDialog(context,'THÔNG BÁO', 'Vui lòng nhập đầy đủ các trường', StylishDialogType.WARNING);
  //Utils.showStylishDialog(context,'THÔNG BÁO', 'Vui lòng nhập đầy đủ các trường', StylishDialogType.SUCCESS);
  //Utils.showStylishDialog(context,'THÔNG BÁO', 'Vui lòng nhập đầy đủ các trường', StylishDialogType.INFO);
  //Utils.showStylishDialog(context,'THÔNG BÁO', 'Vui lòng nhập đầy đủ các trường', StylishDialogType.ERROR);
  //Utils.showStylishDialog(context,'THÔNG BÁO', 'Vui lòng nhập đầy đủ các trường', StylishDialogType.PROGRESS);

  static void showStylishDialog(BuildContext context, String title,
      String description, StylishDialogType style) {
    DialogController controller = DialogController(
      listener: (status) {
        if (status == DialogStatus.Showing) {
          debugPrint("Dialog is showing");
        } else if (status == DialogStatus.Changed) {
          debugPrint("Dialog type changed");
        } else if (status == DialogStatus.Dismissed) {
          debugPrint("Dialog dismissed");
        }
      },
    );
    StylishDialog dialog = StylishDialog(
      //sau 2s dismiss nên không cần nhấn bên ngoài dimiss sẽ gây ra lỗi
      dismissOnTouchOutside: false,
      context: context,
      alertType: style,
      style: DefaultStyle(),
      controller: controller,
      title: Text(
        title,
        style: textStylePlaceholder,
      ),
      content: Text(description, style: textStylePlaceholder),
      // animationLoop: true,
    );

    // StylishDialog dialog = StylishDialog(
    //  dismissOnTouchOutside: false,
    //   context: context,
    //   alertType: style,
    //   style: Style1(),
    //   controller: controller,
    //   title: Text(
    //     title,
    //     style: textStylePlaceholder,
    //   ),
    //   content: Text(description, style: textStylePlaceholder),
    //   // animationLoop: true,
    // );

    dialog.show();
    Future.delayed(const Duration(seconds: 2), () {
      dialog.dismiss();
    });
  }

  //END=================================DIALOG==================================
  //BEGIN===============================TOAST===================================

  static void showToast(String message, TypeToast typeToast,
      {ToastGravity toastGravity = ToastGravity.BOTTOM,
      Toast toast = Toast.LENGTH_LONG}) {
    Color backgroundColor = secondColor;
    Color textColor = secondColor;
    switch (typeToast) {
      case TypeToast.SUCCESS:
        backgroundColor = colorSuccess;
        break;
      case TypeToast.ERROR:
        backgroundColor = colorCancel;
        break;
      case TypeToast.WARNING:
        backgroundColor = colorWarning;
        break;
      case TypeToast.INFO:
        backgroundColor = colorInformation;
        break;
      case TypeToast.NORMAL:
        backgroundColor = colorInformation;
        textColor = labelBlackColor;
        break;
      default:
        backgroundColor = secondColor;
        break;
    }
    Fluttertoast.showToast(
        msg: message,
        toastLength: toast,
        gravity: toastGravity,
        timeInSecForIosWeb: 1,
        backgroundColor: backgroundColor,
        textColor: textColor,
        fontSize: 16.0);
  }
  //END=================================TOAST===================================
}
