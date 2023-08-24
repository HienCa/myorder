import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:myorder/controllers/auth_controller.dart';
import 'package:myorder/views/screens/utilities/utils_screen.dart';

List pages = [
  const Text("t"),
  const Text(""),
  const Text(""),
  const Text(""),
  // ProfileScreen(uid: authController.user.uid),
  const UtilsPage()
];

// background
const backgroundColor = Colors.white;
const backgroundColorGray = Color.fromARGB(255, 245, 241, 241);

//text
const textColor = Colors.black;
const unselectedItemColor = Colors.black45;
const borderColor = Colors.grey;
const textStyleBlackRegular = TextStyle(
    color: Color.fromARGB(196, 20, 19, 19),
    fontSize: 16,
    fontWeight: FontWeight.w400);
const textStyleBlackBold =
    TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold);
//button
var buttonColor = Colors.red[400];

//icon
const iconColor = Colors.grey;
const iconColorPrimary = Colors.deepOrange;

const marginTop5 = SizedBox(height: 5);
const marginTop10 = SizedBox(height: 10);
const marginTop20 = SizedBox(height: 20);
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
