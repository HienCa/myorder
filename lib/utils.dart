// ignore_for_file: depend_on_referenced_packages, avoid_print, constant_identifier_names

import 'dart:math';

import 'package:another_flushbar/flushbar.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/models/employee.dart';
import 'package:myorder/models/food.dart';
import 'package:myorder/models/food_combo.dart';
import 'package:myorder/models/food_order.dart';
import 'package:myorder/models/ingredient.dart';
import 'package:myorder/models/order_detail.dart';
import 'package:stylish_dialog/stylish_dialog.dart';
import 'package:uuid/uuid.dart';
import 'package:myorder/models/order.dart' as orderModel;

enum TypeToast {
  SUCCESS,
  ERROR,
  WARNING,
  INFO,
  NORMAL,
}

class TimeOption {
  DateTime startDate;
  DateTime endDate;

  TimeOption({required this.startDate, required this.endDate});
}

//Các phương phức hay dùng
class Utils {
  //SCREEN
  static bool isLandscapeOrientation(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  //DATETIME

  static TimeOption getTimeOption(int index) {
    DateTime now = DateTime.now();
    DateTime startDate;
    DateTime endDate;
    TimeOption timeOption = TimeOption(
        startDate: DateTime(now.year, now.month, now.day),
        endDate: DateTime(now.year, now.month, now.day, 23, 59, 59, 999));
    switch (index) {
      case 0: //hôm nay
        print("Thời gian: hôm nay");

        startDate = DateTime(now.year, now.month, now.day);
        endDate = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);

        timeOption = TimeOption(startDate: startDate, endDate: endDate);
        break;
      case 1: //hôm qua
        print("Thời gian: hôm qua");

        startDate = DateTime(now.year, now.month, now.day - 1);
        endDate = DateTime(now.year, now.month, now.day - 1, 23, 59, 59, 999);
        timeOption = TimeOption(startDate: startDate, endDate: endDate);

        break;
      case 2: //tuần này
        print("Thời gian: tuần này");

        startDate = now.subtract(Duration(days: now.weekday - 1));
        endDate = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
        timeOption = TimeOption(startDate: startDate, endDate: endDate);

        break;
      case 3: //tháng này
        print("Thời gian: tháng này");

        startDate = DateTime(now.year, now.month, 1);
        endDate = DateTime(now.year, now.month + 1, 0, 23, 59, 59, 999);
        timeOption = TimeOption(startDate: startDate, endDate: endDate);

        break;
      case 4: //tháng trước
        print("Thời gian: tháng trước");

        startDate = DateTime(now.year, now.month - 1, 1);
        endDate = DateTime(now.year, now.month, 0, 23, 59, 59, 999);
        timeOption = TimeOption(startDate: startDate, endDate: endDate);

        break;
      case 5: //3 tháng gần nhất
        print("Thời gian: 3 năm gần nhất");

        startDate = DateTime(now.year, now.month - 2, now.day);
        endDate = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
        timeOption = TimeOption(startDate: startDate, endDate: endDate);

        break;
      case 6: //năm nay
        print("Thời gian: 3 năm gần nhất");

        startDate = DateTime(now.year, 1, 1);
        endDate = DateTime(now.year, 12, 31, 23, 59, 59, 999);
        timeOption = TimeOption(startDate: startDate, endDate: endDate);

        break;
      case 7: //năm trước
        print("Thời gian: năm trước");

        startDate = DateTime(now.year - 1, 1, 1);
        endDate = DateTime(now.year - 1, 12, 31, 23, 59, 59, 999);
        timeOption = TimeOption(startDate: startDate, endDate: endDate);

        break;
      case 8: //3 năm gần nhất
        print("Thời gian: 3 năm gần nhất");

        startDate = DateTime(now.year - 2, now.month, now.day);
        endDate = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
        timeOption = TimeOption(startDate: startDate, endDate: endDate);

        break;
      case 9: //tất cả các năm
        print("Thời gian: tất cả các năm");

        startDate = DateTime(1970, 1, 1);
        // endDate = DateTime(2100, 12, 31, 23, 59, 59, 999);
        endDate = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
        timeOption = TimeOption(startDate: startDate, endDate: endDate);

        break;
      default:
        return timeOption;
    }
    return timeOption;
  }

  static String formatTimestamp(Timestamp? timestamp) {
    if (timestamp != null) {
      var dateTime = timestamp.toDate();
      var formatter = DateFormat('dd/MM/yyyy');
      return formatter.format(dateTime);
    } else {
      return '';
    }
  }

  static Future<DateTime?> selectDate(BuildContext context) async {
    final DateTime currentDate = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2200),
    );

    if (pickedDate == null) {
      // Người dùng đã hủy bỏ chọn ngày
      return null;
    }

    return pickedDate;
  }

  //Khi truy vấn firebase thì firebase so sánh lun cả ngày tháng năm giờ phút giây -> bỏ giờ phút giây
  //Convert timestamp dd/mm/yyy truy vấn firebase
  static Timestamp convertTimestampFirebase(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    DateTime formatedDate = DateTime(date.year, date.month, date.day, 0, 0, 0);
    return Timestamp.fromDate(formatedDate);
  }

  static Timestamp convertTimestampFirebaseAddDay(
      Timestamp timestamp, int numberOfday) {
    Timestamp currentTimestamp = Timestamp.now();
    DateTime currentDateTime = currentTimestamp.toDate();
    DateTime formatedDate = currentDateTime.add(Duration(days: 1));
    return Timestamp.fromDate(formatedDate);
  }

  //DATETIME
  static String formatDateTime(DateTime? dateTime) {
    if (dateTime != null) {
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
  static String formatDatetimeFull(DateTime? datetime) {
    if (datetime != null) {
      var formatter = DateFormat('dd/MM/yyyy HH:mm:ss');
      return formatter.format(datetime);
    } else {
      return '';
    }
  }

  //So sánh TIMESTAMP
  static bool isSameDateFromTimstamp(
      Timestamp timestamp1, Timestamp timestamp2) {
    // Chuyển đổi Timestamp thành DateTime
    DateTime date1 = timestamp1.toDate();
    DateTime date2 = timestamp2.toDate();

    // Chuyển đổi DateTime thành DateTime với giờ, phút, giây là 0
    DateTime startDateTime1 =
        DateTime(date1.year, date1.month, date1.day, 0, 0, 0);
    DateTime startDateTime2 =
        DateTime(date2.year, date2.month, date2.day, 0, 0, 0);

    // So sánh giá trị ngày tháng năm
    return startDateTime1.isAtSameMomentAs(startDateTime2);
  }

  //So sánh TIMESTAMP
  static bool isBeforeDateFromTimstamp(
      Timestamp timestamp1, Timestamp timestamp2) {
    // Chuyển đổi Timestamp thành DateTime
    DateTime date1 = timestamp1.toDate();
    DateTime date2 = timestamp2.toDate();

    // Chuyển đổi DateTime thành DateTime với giờ, phút, giây là 0
    DateTime startDateTime1 =
        DateTime(date1.year, date1.month, date1.day, 0, 0, 0);
    DateTime startDateTime2 =
        DateTime(date2.year, date2.month, date2.day, 0, 0, 0);

    // So sánh giá trị ngày tháng năm
    return startDateTime1.isBefore(startDateTime2);
  }

  static Timestamp getOnlyDateFromTimestamp(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    date = DateTime(date.year, date.month, date.day, 0, 0, 0, 0);
    return Timestamp.fromDate(date);
  }

  //ngày mai
  static DateTime getDateTimeNow() {
    DateTime now = Timestamp.now().toDate();
    now = DateTime(now.year, now.month, now.day, 0, 0, 0, 0);
    return now;
  }

  //ngày mai
  static DateTime getTomorrow() {
    DateTime tomorrow = DateTime.now().add(const Duration(days: 1));
    return tomorrow;
  }

  //Ngày + số lượng
  static DateTime getDateTimeAddDay(int number) {
    DateTime datetime = DateTime.now().add(Duration(days: number));
    return datetime;
  }

  //Ngày +1
  static DateTime getDateTimeAddOne(DateTime datetime) {
    DateTime datetimeAdded = datetime.add(const Duration(days: 1));
    return datetimeAdded;
  }

  static Timestamp convertDatetimeToTimestamp(DateTime datetime) {
    return Timestamp.fromDate(DateTime.parse(datetime.toString()));
  }

  static Timestamp convertDatetimeStringToTimestamp(String datetime) {
    return Timestamp.fromDate(DateTime.parse(datetime.toString()));
  }

  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.day == date2.day &&
        date1.month == date2.month &&
        date1.year == date2.year;
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

  static bool isTimestampInRange(
      Timestamp timestampToCheck, DateTime startDate, DateTime endDate) {
    DateTime dateTimeToCheck = timestampToCheck.toDate();
    return dateTimeToCheck.isAfter(startDate) &&
        dateTimeToCheck.isBefore(endDate);
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

  static DateTime stringToDateTimeVN(String dateString) {
    return DateTime.parse(dateString);
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

  static bool isCheckedAllDyamic(List<dynamic> list) {
    for (var item in list) {
      if (item.isSelected == false) {
        return false;
      }
    }
    return true;
  }

  static void toggleCheckAll(List<dynamic> list, bool isCheck) {
    for (var item in list) {
      item.isSelected = isCheck;
    }
  }

  static void checkAllDyamic(List<dynamic> list) {
    for (var item in list) {
      item.isSelected = true;
    }
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

  static void unSelectedAll(List<dynamic> list) {
    for (var item in list) {
      item.isSelected = false;
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

  static List<dynamic> filterActive(List<dynamic> list) {
    List<dynamic> fliteredList = [];
    for (var item in list) {
      if (item.active == ACTIVE) {
        fliteredList.add(item);
      }
    }
    return fliteredList;
  }

  static List<Ingredient> filterIngredientSelected(List<Ingredient> list) {
    List<Ingredient> fliteredList = [];
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

  static bool isAnyQuantityChanged(List<dynamic> list) {
    for (var item in list) {
      if (item.quantity != item.new_quantity) {
        // Có ít nhất một đối tượng đã được chọn
        return true;
      }
    }
    // Không có đối tượng nào được chọn
    return false;
  }

  static bool isAnyQuantityOrUnitChanged(List<dynamic> list) {
    for (var item in list) {
      if (item.quantity != item.new_quantity ||
          item.unit_id != item.new_unit_id) {
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

  //Tính tổng tiền sau khi trừ thuế và giảm giá từ TextEditingController
  static double getTotalAmountFromTextEditingControllerVatDiscount(
      TextEditingController vatTextEditingController,
      TextEditingController discountTextEditingController,
      List<dynamic> list) {
    double totalAmount = Utils.getSumPriceQuantity2(list);
    int vatPercent = int.tryParse(vatTextEditingController.text) ?? 0;
    double discountPrice =
        Utils.stringConvertToDouble(discountTextEditingController.text);

    double totalVat = totalAmount * vatPercent / 100;
    return totalAmount + totalVat - discountPrice;
  }

  //Tính tổng tiền sau khi trừ thuế và giảm giá
  static double getTotalAmountFromVatDiscount(
      double totalAmount, int vatPercent, double discountPrice) {
    double totalVat = totalAmount * vatPercent / 100;
    return totalAmount + totalVat - discountPrice;
  }

  //Tính tổng tiền sau khi trừ thuế và giảm giá đã format tiền tệ
  static String getFormatedTotalAmountFromVatDiscount(
      double totalAmount, int vatPercent, double discountPrice) {
    double totalVat = totalAmount * vatPercent / 100;
    return formatCurrency(totalAmount + totalVat - discountPrice);
  }

  static String generateInvoiceCode(String prefix) {
    // Lấy ngày giờ hiện tại
    DateTime now = DateTime.now();
    // Định dạng chuỗi ngày tháng năm giây khắc
    String formattedDate = DateFormat('ddMMHHyyyymmss').format(now);
    // Tạo mã phiếu từ chuỗi đã định dạng
    String invoiceCode = '${prefix}_$formattedDate';
    return invoiceCode;
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
  static double getSumPriceQuantity2(List<dynamic> list) {
    double total = 0;
    for (var item in list) {
      total += (item.price * item.quantity);
    }
    return total;
  }

  //Tính tổng tiền theo quantity_in_stock
  static double getTotalAmountCancelReceipt(List<dynamic> list) {
    double total = 0;
    for (var item in list) {
      total += (item.price * item.quantity_in_stock);
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
          total +=
              (((item.price_with_temporary ?? 0) + item.price) * item.quantity);
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

  //Tổng tạm tính
  static double getProvisionalInvoice(
      List<OrderDetail> orderdetails) {
    double total = 0;
    for (OrderDetail orderdetail in orderdetails) {
      if (orderdetail.food_status != FOOD_STATUS_CANCEL) {
        total += (orderdetail.price * orderdetail.quantity);
      }
    }
    return total;
  }
  //Tổng tiền cần thanh toán
  static double getTotalAmount(
      orderModel.Order order, List<OrderDetail> orderdetails) {
    double total = 0;
    for (OrderDetail orderdetail in orderdetails) {
      if (orderdetail.food_status != FOOD_STATUS_CANCEL) {
        total += (orderdetail.price * orderdetail.quantity);
      }
    }

    total = total +
        order.total_vat_amount -
        order.total_discount_amount -
        order.deposit_amount;

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

  static void showStylishDialogSetTime(BuildContext context, String title,
      String description, StylishDialogType style, int seconds) {
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
    Future.delayed(Duration(seconds: seconds), () {
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
  static Color generateRandomColor() {
    final Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256), // Red
      random.nextInt(256), // Green
      random.nextInt(256), // Blue
    );
  }

  static List<Color> generateRandomColors(int numberOfColors) {
    final List<Color> colors = [];
    final Random random = Random();

    for (int i = 0; i < numberOfColors; i++) {
      colors.add(Color.fromARGB(
        255,
        random.nextInt(256), // Red
        random.nextInt(256), // Green
        random.nextInt(256), // Blue
      ));
    }

    return colors;
  }

  static Future<Employee> getCurrentEmployee() async {
    Employee employee = Employee(
        employee_id:
            await myCacheManager.getFromCache(CACHE_EMPLOYEE_ID_KEY) ?? "",
        name: await myCacheManager.getFromCache(CACHE_EMPLOYEE_NAME_KEY) ?? "",
        cccd: "",
        gender: "",
        birthday: "",
        phone: "",
        email: "",
        password: "",
        address: "",
        role: int.tryParse(
                await myCacheManager.getFromCache(CACHE_EMPLOYEE_ROLE_KEY) ??
                    "1") ??
            1,
        active: ACTIVE,
        device_token: "");
    return employee;
  }
}
