// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:myorder/models/food_order.dart';

//Các phương phức hay dùng
class Utils {
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

  static String formatCurrency(double amount) {
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

  static String formatCurrencytoDouble(String amount) {
    return amount.replaceAll(RegExp(r','), "");
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
