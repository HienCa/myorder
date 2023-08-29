import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:myorder/controllers/auth_controller.dart';
import 'package:myorder/views/screens/area/area_screen.dart';
import 'package:myorder/views/screens/order/order_screen.dart';
import 'package:myorder/views/screens/order/orderdetail/order_detail_screen.dart';
import 'package:myorder/views/screens/utilities/utils_screen.dart';

List pages = [
  const OrderdetailPage(),
  const OrderPage(),
  const Text(""),
  const AreaPage(),
  // ProfileScreen(uid: authController.user.uid),
  const UtilsPage()
];

// list of colors that we use in our app
const kBackgroundColor = Color(0xFFF1EFF1);
const kPrimaryColor = Color(0xFF035AA6);
const kSecondaryColor = Color(0xFFFFA41B);
const kTextColor = Color(0xFF000839);
const kTextLightColor = Color(0xFF747474);
const kBlueColor = Color(0xFF40BAD5);

const kDefaultPadding = 20.0;

// our default Shadow
const kDefaultShadow = BoxShadow(
  offset: Offset(0, 15),
  blurRadius: 27,
  color: Colors.black12, // Black color with 12% opacity
);
//corlor
const primaryColor = Color(0xFF40BAD5);
var primaryColorOpacity = const Color(0xFF40BAD5).withOpacity(0.2);
var chooseColorOpacity = const Color(0xFF40BAD5);

//color of order
const tableservingColor = Color(0xFF40BAD5);
const tableemptyColor = Color(0xFF747474);
const tablecancelColor = Color.fromARGB(255, 224, 24, 24);
const cancelFoodColor = Color.fromARGB(255, 224, 24, 24);

//border color
const borderColorPrimary = Color(0xFF40BAD5);

// background
const backgroundColor = Colors.white;
const backgroundColorGray = Color.fromARGB(255, 245, 241, 241);

//text
const textColor = Colors.black;
const textWhiteColor = Colors.white;
const unselectedItemColor = Colors.black45;
const labelBlackColor = Colors.black45;
const borderColor = Colors.grey;

//text style
const textStyleWhiteRegular16 =
    TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400);
const textStyleWhiteBold16 =
    TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold);

const textStyleWhiteBold20 =
    TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold);

const textStylePriceBold16 =
    TextStyle(color: primaryColor, fontSize: 16, fontWeight: FontWeight.bold);

const textStylePriceBold20 =
    TextStyle(color: primaryColor, fontSize: 20, fontWeight: FontWeight.bold);

const textStylePriceRegular16 =
    TextStyle(color: primaryColor, fontSize: 16, fontWeight: FontWeight.normal);

const textStylePriceBlackRegular16 = TextStyle(
    color: Colors.black54, fontSize: 16, fontWeight: FontWeight.normal);

const textStyleFoodNameBold16 = TextStyle(
    color: Colors.black54, fontSize: 16, fontWeight: FontWeight.normal);

const textStyleBlackRegular = TextStyle(
    color: Color.fromARGB(196, 20, 19, 19),
    fontSize: 16,
    fontWeight: FontWeight.w400);

const textStyleBlackBold =
    TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold);

const textStyleGrayBold = TextStyle(
    color: tableemptyColor, fontSize: 20, fontWeight: FontWeight.bold);

const textStylePrimaryBold =
    TextStyle(color: primaryColor, fontSize: 20, fontWeight: FontWeight.bold);

const textStyleSecondBold = TextStyle(
    color: tableemptyColor, fontSize: 16, fontWeight: FontWeight.bold);

const textStyleSeccess =
    TextStyle(color: Colors.green, fontSize: 14, fontWeight: FontWeight.bold);

const textStyleMaking = TextStyle(
    color: Colors.redAccent, fontSize: 14, fontWeight: FontWeight.bold);
    
const textStyleCancel = TextStyle(
    color: Colors.redAccent, fontSize: 20, fontWeight: FontWeight.bold);

const textStylePlaceholder = TextStyle(
    color: tableemptyColor, fontSize: 14, fontWeight: FontWeight.bold);
//button
var buttonColor = const Color(0xFF40BAD5);
const buttonStyleBlackBold =
    TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
double buttonHeight = 50;
double buttonWidth = 300;

//icon
const iconColor = Colors.grey;
const iconWhiteColor = Colors.white;
const iconColorPrimary = Color(0xFF40BAD5);
var iconColorPrimaryOpacity = const Color(0xFF40BAD5).withOpacity(0.8);

const marginTop5 = SizedBox(height: 5);
const marginTop10 = SizedBox(height: 10);
const marginTop20 = SizedBox(height: 20);
const marginTop30 = SizedBox(height: 30);
const marginRight10 = SizedBox(width: 10);
const marginRight20 = SizedBox(width: 20);

const sizeIconLarge = 30;
const sizeIconSmall = 20;

// FIREBASE
var firebaseAuth = FirebaseAuth.instance;
var firebaseStorage = FirebaseStorage.instance;
var firestore = FirebaseFirestore.instance;

// CONTROLLER
var authController = AuthController.instance;
