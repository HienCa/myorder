// ignore_for_file: non_constant_identifier_names, avoid_print

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Correct import for Firestore
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/models/Employee.dart';
import 'package:myorder/models/employee.dart' as model;

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
          String city = userData['city'] ?? '';
          String district = userData['district'] ?? '';
          String ward = userData['ward'] ?? '';
          String address = userData['address'] ?? '';
          String role = userData['role'] ?? '';
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
            city: city,
            district: district,
            ward: ward,
            address: address,
            role: role,
            active: active,
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
          role: '',
          active: 1);
    }
    print("gggggggggg");
  }

  final Rx<List<Employee>> _employees = Rx<List<Employee>>([]);
  List<Employee> get employees => _employees.value;
  getEmployees() async {
    _employees.bindStream(
      firestore.collection('employees').snapshots().map(
        (QuerySnapshot query) {
          List<Employee> retValue = [];
          for (var element in query.docs) {
            retValue.add(Employee.fromSnap(element));
          }
          return retValue;
        },
      ),
    );
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
      String city,
      String district,
      String ward,
      String address,
      String role) async {
    try {
      if (name.isNotEmpty &&
          email.isNotEmpty &&
          cccd.isNotEmpty &&
          gender.isNotEmpty &&
          birthday.isNotEmpty &&
          phone.isNotEmpty &&
          address.isNotEmpty &&
          role.isNotEmpty) {
        UserCredential cred = await firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        String downloadUrl = "";
        if (image != null) {
          downloadUrl = await _uploadToStorage(image);
        }

        model.Employee employee = model.Employee(
          employee_id: cred.user!.uid,
          name: name,
          avatar: downloadUrl,
          cccd: cccd,
          gender: gender,
          birthday: birthday,
          phone: phone,
          email: email,
          password: password,
          city: city,
          district: district,
          ward: ward,
          address: address,
          role: role,
          active: 1,
        );
        CollectionReference usersCollection =
            FirebaseFirestore.instance.collection('employees');

        await usersCollection.doc(cred.user!.uid).set(employee.toJson());
        Get.snackbar(
          'THÀNH CÔNG!',
          'Thêm nhân viên mới thành công!',
          backgroundColor: backgroundSuccessColor,
          colorText: Colors.white,
        );
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
      String city,
      String district,
      String ward,
      String address,
      String role) async {
    // var doc = await firestore.collection('employees').doc(employee_id).get();
    String downloadUrl = "";
    try {
      if (image != null) {
        print("Image Selected");

        // Xóa ảnh cũ nếu có
        // await _deleteOldProfilePhoto(doc);// nếu xóa thì dùng chung ảnh có thể mất hết

        // Tải ảnh mới lên Firebase Storage và nhận URL
        downloadUrl = await _uploadToStorage(image);
        // Cập nhật tên và URL hình đại diện vào tài liệu người dùng
        await firestore.collection('employees').doc(employee_id).update({
          "name": name,
          "avatar": downloadUrl,
          "cccd": cccd,
          "gender": gender,
          "birthday": birthday,
          "phone": phone,
          "email": email,
          "password": password,
          "city": city,
          "district": district,
          "ward": ward,
          "address": address,
          "role": role,
        });
      } else {
        print("NO Image Selected");
        print("employee_id $employee_id");

        // Cập nhật tên và URL hình đại diện vào tài liệu người dùng
        await firestore.collection('employees').doc(employee_id).update({
          "name": name,
          "avatar": avatar,
          "cccd": cccd,
          "gender": gender,
          "birthday": birthday,
          "phone": phone,
          "email": email,
          "password": password,
          "city": city,
          "district": district,
          "ward": ward,
          "address": address,
          "role": role,
        });
      }
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
      print("Fail...");
    }
    print("bb...");
  }

  // Block account
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
      print("Fail...");
    }
    print("bb...");
  }

  _deleteOldProfilePhoto(DocumentSnapshot doc) async {
    if (doc.exists && doc.data() != null) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      String oldDownloadUrl = data['avatar'];
      if (oldDownloadUrl.isNotEmpty) {
        try {
          // Tạo tham chiếu đến file trong Firebase Storage
          Reference storageRef =
              FirebaseStorage.instance.refFromURL(oldDownloadUrl);

          // Kiểm tra URL tải xuống để kiểm tra sự tồn tại của tệp
          await storageRef.getDownloadURL();

          // Nếu không xảy ra lỗi, tệp tồn tại và có thể xóa
          await storageRef.delete();
        } catch (e) {
          // Xử lý lỗi nếu tệp không tồn tại hoặc có lỗi khác
          print("Error deleting file: $e");
        }
      }
    }
  }
}
