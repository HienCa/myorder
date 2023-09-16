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
import 'package:myorder/models/food.dart' as model;

class FoodController extends GetxController {
  late Rx<File?> _pickedImage;

  File? get profilePhoto => _pickedImage.value;

  void pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      Get.snackbar('Upload image', 'Bạn đã tải lên image thành công!');
    }
    _pickedImage = Rx<File?>(File(pickedImage!.path));
  }

  void pickImageFromCamera() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      Get.snackbar('Upload image', 'Bạn đã tải lên image thành công!');
    }
    _pickedImage = Rx<File?>(File(pickedImage!.path));
  }

  // upload to firebase storage
  Future<String> _uploadToStorage(File image) async {
    Reference ref = firebaseStorage.ref().child('profilePics');
    // .child(firebaseAuth.currentUser!.uid);

    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  getFoodById(String foodId) async {
    try {
      DocumentSnapshot Food =
          await firestore.collection('foods').doc(foodId).get();
      if (Food.exists) {
        final foodData = Food.data();
        if (foodData != null && foodData is Map<String, dynamic>) {
          String food_id = foodData['food_id'] ?? "";
          String name = foodData['name'] ?? "";
          String image = foodData['image'] ?? "";
          double price = foodData['price'] ?? 0;
          double price_with_temporary = foodData['price_with_temporary'] ?? 0;
          print(price_with_temporary);
          print(foodData['price_with_temporary']);
          Timestamp temporary_price_from_date =
              foodData['temporary_price_from_date'];
          Timestamp temporary_price_to_date =
              foodData['temporary_price_to_date'];
          // double temporary_price = foodData['temporary_price'] ?? 0;
          // double temporary_percent = foodData['temporary_percent'] ?? 0;
          String category_id = foodData['category_id'] ?? "";
          String unit_id = foodData['unit_id'] ?? "";
          String vat_id = foodData['vat_id'] ?? "";
          int temporary_percent = foodData['temporary_percent'];
          int active = foodData['active'];

          return model.Food(
            food_id: food_id,
            name: name,
            image: image,
            price: price,
            price_with_temporary: price_with_temporary,
            temporary_price_from_date: temporary_price_from_date,
            temporary_price_to_date: temporary_price_to_date,
            // temporary_price: temporary_price,
            // temporary_percent: temporary_percent,
            category_id: category_id,
            unit_id: unit_id,
            vat_id: vat_id,
            temporary_percent: temporary_percent,
            active: active,
          );
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }

  final Rx<List<model.Food>> _foods = Rx<List<model.Food>>([]);
  List<model.Food> get foods => _foods.value;
  getfoods() async {
    _foods.bindStream(
      firestore.collection('foods').snapshots().map(
        (QuerySnapshot query) {
          List<model.Food> retValue = [];
          for (var element in query.docs) {
            retValue.add(model.Food.fromSnap(element));
          }
          return retValue;
        },
      ),
    );
  }

  void createFood(
    String name,
    File? image,
    String price,
    String? price_with_temporary,
    DateTime? temporary_price_from_date,
    DateTime? temporary_price_to_date,
    String category_id,
    String unit_id,
    String? vat_id,
    int temporary_percent
  ) async {
    try {
      if (name.isNotEmpty && category_id.isNotEmpty && unit_id.isNotEmpty) {
        String downloadUrl = "";
        if (image != null) {
          downloadUrl = await _uploadToStorage(image);
        }

        var allDocs = await firestore.collection('foods').get();
        int len = allDocs.docs.length;
        if (price_with_temporary != "") {
          model.Food Food = model.Food(
            food_id: 'Food-$len',
            name: name,
            image: downloadUrl,
            price: double.tryParse(price) ?? 0.0,
            price_with_temporary: double.tryParse(price_with_temporary!) ?? 0.0,
            temporary_price_from_date:
                Timestamp.fromDate(temporary_price_from_date!),
            temporary_price_to_date:
                Timestamp.fromDate(temporary_price_to_date!),
            category_id: category_id,
            unit_id: unit_id,
            vat_id: vat_id,
            temporary_percent: temporary_percent,
            active: 1,
          );
          CollectionReference foodsCollection =
              FirebaseFirestore.instance.collection('foods');

          await foodsCollection.doc('Food-$len').set(Food.toJson());
        } else {
          model.Food Food = model.Food(
            food_id: 'Food-$len',
            name: name,
            image: downloadUrl,
            price: double.tryParse(price) ?? 0.0,
            price_with_temporary: double.tryParse(price_with_temporary!) ?? 0.0,
            temporary_price_from_date: null,
            temporary_price_to_date: null,
            category_id: category_id,
            unit_id: unit_id,
            vat_id: vat_id,
            temporary_percent: temporary_percent ,
            active: 1,
          );
          CollectionReference foodsCollection =
              FirebaseFirestore.instance.collection('foods');

          await foodsCollection.doc('Food-$len').set(Food.toJson());
        }

        Get.snackbar(
          'THÀNH CÔNG!',
          'Thêm món mới thành công!',
          backgroundColor: backgroundSuccessColor,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error!',
          'Thêm món thất bại!',
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
      print(e.toString());
      Get.snackbar(
        'Error!',
        e.toString(),
      );
    }
  }

  updateFood(
    String food_id,
    String name,
    String? image,
    File? newImage,
    String price,
    String? price_with_temporary,
    DateTime? temporary_price_from_date,
    DateTime? temporary_price_to_date,
    String category_id,
    String unit_id,
    String vat_id,
    int temporary_percent

  ) async {
    // var doc = await firestore.collection('foods').doc(Food_id).get();
    String downloadUrl = "";
    try {
      print("food_id $food_id");
      print("category_id $category_id");
      print("unit_id $unit_id");
      print("image $image");
      print("price $price");
      print("price_with_temporary $price_with_temporary");
      if (newImage != null) {
        print("Image Selected");

        // Xóa ảnh cũ nếu có
        // await _deleteOldProfilePhoto(doc);// nếu xóa thì dùng chung ảnh có thể mất hết

        // Tải ảnh mới lên Firebase Storage và nhận URL
        downloadUrl = await _uploadToStorage(newImage);
        // Cập nhật tên và URL hình đại diện vào tài liệu người dùng
        await firestore.collection('foods').doc(food_id).update({
          "food_id": food_id.trim(),
          "name": name.trim(),
          "image": downloadUrl,
          "price": double.tryParse(price) ?? 0.0,
          "vat_id": vat_id.trim(),
          "price_with_temporary": double.tryParse(price_with_temporary!) ?? 0.0,
          "temporary_price_from_date": temporary_price_from_date,
          "temporary_price_to_date": temporary_price_to_date,

          // "active": active,
          "category_id": category_id.trim(),
          "unit_id": unit_id.trim(),
          "temporary_percent": temporary_percent,

        });
      } else {
        print("NO Image Selected");

        // Cập nhật tên và URL hình đại diện vào tài liệu người dùng
        await firestore.collection('foods').doc(food_id).update({
          "food_id": food_id.trim(),
          "name": name.trim(),
          "image": image,
          "price": double.tryParse(price) ?? 0.0,
          "vat_id": vat_id.trim(),
          "price_with_temporary": double.tryParse(price_with_temporary!) ?? 0.0,
          "temporary_price_from_date": temporary_price_from_date,
          "temporary_price_to_date": temporary_price_to_date,

          // "active": active,
          "category_id": category_id.trim(),
          "unit_id": unit_id.trim(),
          "temporary_percent":temporary_percent,

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
    }
  }

  // Block account
  updateToggleActive(
    String Food_id,
    int active,
  ) async {
    try {
      await firestore.collection('foods').doc(Food_id).update({
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
      String oldDownloadUrl = data['image'];
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
