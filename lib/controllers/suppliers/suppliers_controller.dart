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
import 'package:myorder/models/supplier.dart';
import 'package:myorder/models/supplier.dart' as model;
import 'package:myorder/utils.dart';

class SupplierController extends GetxController {
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

  final Rx<List<Supplier>> _suppliers = Rx<List<Supplier>>([]);
  List<Supplier> get suppliers => _suppliers.value;

  getSuppliers(String keySearch) async {
    if (keySearch.isEmpty) {
      _suppliers.bindStream(
        firestore.collection('suppliers').snapshots().map(
          (QuerySnapshot query) {
            List<Supplier> retValue = [];
            for (var element in query.docs) {
              retValue.add(Supplier.fromSnap(element));
            }
            return retValue;
          },
        ),
      );
    } else {
      _suppliers.bindStream(firestore
          .collection('suppliers')
          .orderBy('name')
          .snapshots()
          .map((QuerySnapshot query) {
        List<Supplier> retVal = [];
        for (var elem in query.docs) {
          String name = elem['name'].toLowerCase();
          String search = keySearch.toLowerCase().trim();
          if (name.contains(search)) {
            retVal.add(Supplier.fromSnap(elem));
          }
        }
        return retVal;
      }));
    }
  }

  void createSupplier(
    String name,
    File? image,
    String phone,
    String email,
    String address,
    String note,
  ) async {
    try {
      if (name.isNotEmpty &&
          email.isNotEmpty &&
          phone.isNotEmpty &&
          address.isNotEmpty) {
        String downloadUrl = "";
        if (image != null) {
          downloadUrl = await _uploadToStorage(image);
        }
        String id = Utils.generateUUID();
        model.Supplier Supplier = model.Supplier(
          supplier_id: id,
          name: name.trim(),
          avatar: downloadUrl,
          phone: phone.trim(),
          email: email.trim(),
          address: address.trim(),
          active: 1,
          note: note.trim(),
        );
        CollectionReference usersCollection =
            FirebaseFirestore.instance.collection('suppliers');

        await usersCollection.doc(id).set(Supplier.toJson());
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

  updateSupplier(String supplier_id, String name, File? image, String phone,
      String email, String address, String note) async {
    // var doc = await firestore.collection('Suppliers').doc(Supplier_id).get();
    String downloadUrl = "";
    try {
      if (image != null) {
        print("Image Selected");
        // Tải ảnh mới lên Firebase Storage và nhận URL
        downloadUrl = await _uploadToStorage(image);
        // Cập nhật tên và URL hình đại diện vào tài liệu người dùng
        await firestore.collection('suppliers').doc(supplier_id).update({
          "name": name.trim(),
          "avatar": downloadUrl,
          "phone": phone.trim(),
          "email": email.trim(),
          "address": address.trim(),
          "note": note.trim(),
        });
      } else {
        print("NO Image Selected");
        print("Supplier_id $name");

        // Cập nhật tên và URL hình đại diện vào tài liệu người dùng
        await firestore.collection('suppliers').doc(supplier_id).update({
          "name": name.trim(),
          "phone": phone.trim(),
          "email": email.trim(),
          "address": address.trim(),
          "note": note.trim(),
        });
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

  // Block account
  updateToggleActive(
    String Supplier_id,
    int active,
  ) async {
    try {
      await firestore.collection('suppliers').doc(Supplier_id).update({
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
}
