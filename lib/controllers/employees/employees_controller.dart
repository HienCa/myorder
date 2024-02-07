// ignore_for_file: non_constant_identifier_names, avoid_print, unused_element

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Correct import for Firestore
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/firebaseAPI/firebase_api.dart';

import 'package:myorder/models/employee.dart' as model;
import 'package:myorder/models/employee.dart';

class EmployeeController extends GetxController {
  late Rx<User?> _user;
  late Rx<File?> _pickedImage;

  File? get profilePhoto => _pickedImage.value;
  User get user => _user.value!;

  void pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      Get.snackbar('Upload Avatar', 'Bạn đã tải lên avatar thành công!');
    }
    _pickedImage = Rx<File?>(File(pickedImage!.path));
  }

  Future<String> _uploadToStorage(File image) async {
    String fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${image.path.split('/').last}';
    Reference ref = firebaseStorage.ref().child('profilePics/$fileName');

    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  getEmployeeById(String employeeId) async {
    try {
      DocumentSnapshot employee =
          await firestore.collection('employees').doc(employeeId).get();
      if (employee.exists) {
        final userData = employee.data();
        if (userData != null && userData is Map<String, dynamic>) {
          String employee_id = userData['employee_id'] ?? '';
          String name = userData['name'] ?? '';
          String avatar = userData['avatar'] ?? '';
          String cccd = userData['cccd'] ?? '';
          String gender = userData['gender'] ?? '';
          String birthday = userData['birthday'] ?? '';
          String phone = userData['phone'] ?? '';
          String email = userData['email'] ?? '';
          String password = userData['password'] ?? '';

          String address = userData['address'] ?? '';
          String device_token = userData['device_token'] ?? '';
          int role = userData['role'] ?? 1;
          int active = userData['active'] ?? 1;
          return model.Employee(
            employee_id: employee_id,
            name: name,
            avatar: avatar,
            cccd: cccd,
            gender: gender,
            birthday: birthday,
            phone: phone,
            email: email,
            password: password,
            address: address,
            role: role,
            active: active,
            device_token: device_token,
          );
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return Employee(
          employee_id: '',
          name: '',
          cccd: '',
          gender: '',
          birthday: '',
          phone: '',
          email: '',
          password: '',
          address: '',
          device_token: '',
          role: ROLE_STAFF,
          active: 1);
    }
  }

  final Rx<List<Employee>> _employees = Rx<List<Employee>>([]);
  List<Employee> get employees => _employees.value;

  getEmployees(String keySearch) async {
    if (keySearch.isEmpty) {
      _employees.bindStream(
        firestore.collection('employees').snapshots().map(
          (QuerySnapshot query) {
            List<Employee> retValue = [];
            for (var element in query.docs) {
              retValue.add(Employee.fromSnap(element));
              print(element);
            }
            return retValue;
          },
        ),
      );
    } else {
      _employees.bindStream(firestore
          .collection('employees')
          .orderBy('name')
          .snapshots()
          .map((QuerySnapshot query) {
        List<Employee> retVal = [];
        for (var elem in query.docs) {
          String name = elem['name'].toLowerCase();
          String search = keySearch.toLowerCase().trim();
          if (name.contains(search)) {
            retVal.add(Employee.fromSnap(elem));
          }
        }
        return retVal;
      }));
    }
  }

  void createEmployee(
      String name,
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
      if (name.isNotEmpty &&
          email.isNotEmpty &&
          cccd.isNotEmpty &&
          gender.isNotEmpty &&
          birthday.isNotEmpty &&
          phone.isNotEmpty &&
          address.isNotEmpty) {
        UserCredential cred = await firebaseAuth.createUserWithEmailAndPassword(
          email: email.trim(),
          password: password,
        );

        String downloadUrl = "";
        if (image != null) {
          downloadUrl = await _uploadToStorage(image);
        }

        model.Employee employee = model.Employee(
          employee_id: cred.user!.uid,
          name: name.trim(),
          avatar: downloadUrl,
          cccd: cccd.trim(),
          gender: gender,
          birthday: birthday.trim(),
          phone: phone.trim(),
          email: email.trim(),
          password: password.trim(),
          address: address.trim(),
          role: role,
          active: 1,
          device_token: await FirebaseApi().getDeviceToken(),
        );
        CollectionReference usersCollection =
            FirebaseFirestore.instance.collection('employees');

        await usersCollection.doc(cred.user!.uid).set(employee.toJson());
      } else {
        Get.snackbar(
          'Error!',
          'Thêm nhân viên thất bại!',
          backgroundColor: backgroundFailureColor,
          colorText: Colors.white,
        );
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Error!',
        e.message ?? 'Có lỗi xãy ra.',
      );
    } catch (e) {
      Get.snackbar(
        'Error!',
        e.toString(),
      );
    }
  }

  updateEmployee(
      String employee_id,
      String name,
      String? avatar,
      File? image,
      String cccd,
      String gender,
      String birthday,
      String phone,
      String email,
      String password,
      String address,
      int role,
      Employee employee) async {
    String downloadUrl = "";
    try {
      if (image != null) {
        print("Image Selected");

        // Tải ảnh mới lên Firebase Storage và nhận URL
        downloadUrl = await _uploadToStorage(image);
        // Cập nhật tên và URL hình đại diện vào tài liệu người dùng
        await firestore.collection('employees').doc(employee_id).update({
          "name": name.trim(),
          "avatar": downloadUrl,
          "cccd": cccd.trim(),
          "gender": gender.trim(),
          "birthday": birthday.trim(),
          "phone": phone.trim(),
          "email": email.trim(),
          "password": password.trim(),
          "address": address.trim(),
          "role": role,
        });
      } else {
        print("NO Image Selected");

        // Cập nhật tên và URL hình đại diện vào tài liệu người dùng
        await firestore.collection('employees').doc(employee_id).update({
          "name": name.trim(),
          "avatar": avatar,
          "cccd": cccd.trim(),
          "gender": gender.trim(),
          "birthday": birthday.trim(),
          "phone": phone.trim(),
          "email": email.trim(),
          "password": password.trim(),
          "address": address.trim(),
          "role": role,
        });
      }

      try {
        // Lấy thông tin người dùng từ Firebase Authentication bằng UID
        User? user = await FirebaseAuth.instance
            .authStateChanges()
            .firstWhere((u) => u?.uid == employee_id);
        print(user);
        if (user != null) {
          AuthCredential credential = EmailAuthProvider.credential(
              email: employee.email, password: employee.password);
          await user.reauthenticateWithCredential(credential);

          await user.updateEmail(email);

          print('Email updated successfully.');
        } else {
          print('User not found.');

          await firebaseAuth.createUserWithEmailAndPassword(
            email: email.trim(),
            password: password,
          );
        }
      } catch (e) {
        print('Error updating email: $e');
      }

      update();
    } catch (e) {
      Get.snackbar(
        'Cập nhật thất bại!',
        e.toString(),
        backgroundColor: backgroundFailureColor,
        colorText: Colors.white,
      );
    }
  }

  updateTokenDevice() async {
    try {
      await firestore
          .collection('employees')
          .doc(authController.user.uid)
          .update({
        "device_token": await FirebaseApi().getDeviceToken(),
      });

      update();
    } catch (e) {
      print(e);
    }
  }

  updateToggleActive(
    String employee_id,
    int active,
  ) async {
    try {
      await firestore.collection('employees').doc(employee_id).update({
        "active": active == ACTIVE ? DEACTIVE : ACTIVE,
      });

      Get.snackbar(
        'THÀNH CÔNG!',
        'Cập nhật thông tin thành công!',
        backgroundColor: backgroundSuccessColor,
        colorText: Colors.white,
      );
      update();
    } catch (e) {
      Get.snackbar(
        'Cập nhật thất bại!',
        e.toString(),
        backgroundColor: backgroundFailureColor,
        colorText: Colors.white,
      );
    }
  }

  _deleteOldProfilePhoto(DocumentSnapshot doc) async {
    if (doc.exists && doc.data() != null) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      String oldDownloadUrl = data['avatar'];
      if (oldDownloadUrl.isNotEmpty) {
        try {
          Reference storageRef =
              FirebaseStorage.instance.refFromURL(oldDownloadUrl);

          await storageRef.getDownloadURL();

          await storageRef.delete();
        } catch (e) {
          print("Error deleting file: $e");
        }
      }
    }
  }
}
