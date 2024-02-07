import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Correct import for Firestore
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/firebaseAPI/firebase_api.dart';
import 'package:myorder/models/employee.dart' as model;
import 'package:myorder/views/screens/auth/login_screen.dart';
import 'package:myorder/views/screens/home_screen.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  late Rx<User?> _user;
  late Rx<File?> _pickedImage;

  File? get profilePhoto => _pickedImage.value;
  User get user => _user.value!;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(firebaseAuth.currentUser);
    _user.bindStream(firebaseAuth.authStateChanges());
    ever(_user, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => LoginScreen());
    } else {
      Get.offAll(() => const HomeScreen());
    }
  }

  void pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      Get.snackbar('Upload Avatar', 'Bạn đã tải lên avatar thành công!');
    }
    _pickedImage = Rx<File?>(File(pickedImage!.path));
  }

  // upload to firebase storage
  Future<String> _uploadToStorage(File image) async {
    Reference ref = firebaseStorage
        .ref()
        .child('profilePics')
        .child(firebaseAuth.currentUser!.uid);

    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  // registering the user
  void registerUser(
      String username,
      File? image,
      String cccd,
      String gender,
      String birthday,
      String phone,
      String email,
      String password,
      String address,
      int role) async {
    try {
      if (username.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          image != null) {
        // save out user to our auth and firebase firestore
        UserCredential cred = await firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        String downloadUrl = await _uploadToStorage(image);

        model.Employee employee = model.Employee(
          employee_id: cred.user!.uid,
          name: username,
          avatar: downloadUrl,
          cccd: cccd,
          gender: gender,
          birthday: birthday,
          phone: phone,
          email: email,
          password: password,
          address: address,
          device_token: await FirebaseApi().getDeviceToken(),
          role: role,
          active: 1,
        );
        // Get a reference to the 'users' collection in Firestore
        CollectionReference usersCollection =
            FirebaseFirestore.instance.collection('employees');

        // Add the user data to the 'users' collection using the user's UID as the document ID
        await usersCollection.doc(cred.user!.uid).set(employee.toJson());
      } else {
        Get.snackbar(
          'Đăng ký thất bại!',
          'Vui lòng điền đầy đủ các trường bên dưới!',
        );
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Đăng ký thất bại!',
        e.message ?? 'Có lỗi xãy ra trong quá trình tạo tài khoản.',
      );
    } catch (e) {
      Get.snackbar(
        'Đăng ký thất bại!',
        e.toString(),
      );
    }
  }

  void loginUser(String email, String password) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
        Get.snackbar(
          'WELCOME TO HIENCA-ORDER!',
          'Chúc bạn có một ngày vui vẻ!!!',
          backgroundColor: Colors.lightBlue, // Màu nền
          colorText: Colors.white, // M
        );
      } else {
        Get.snackbar(
          'Đăng nhập thất bại!',
          'Vui lòng cung cấp đầy đủ tài khoản và mật khẩu!',
        );
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Đăng nhập thất bại!',
        e.message ?? 'Có lỗi xãy ra trong quá trình đăng nhập.',
      );
    } catch (e) {
      Get.snackbar(
        'Đăng nhập thất bại!',
        e.toString(),
      );
    }
  }

  void signOut() async {
    Get.snackbar(
      'SEE YOU!',
      'Chúc bạn có một ngày vui vẻ!!!',
      backgroundColor: Colors.lightBlue, // Màu nền
      colorText: Colors.white, // M
    );
    await firebaseAuth.signOut();
  }
}
