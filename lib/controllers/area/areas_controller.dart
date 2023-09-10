// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Correct import for Firestore
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/models/Area.dart';
import 'package:myorder/models/Area.dart' as model;

class AreaController extends GetxController {
  getAreaById(String area_id) async {
    try {
      DocumentSnapshot Area =
          await firestore.collection('areas').doc(area_id).get();
      if (Area.exists) {
        final userData = Area.data();
        if (userData != null && userData is Map<String, dynamic>) {
          String area_id = userData['area_id'] ?? '';
          String name = userData['name'] ?? '';

          int active = userData['active'] ?? 1;
          return model.Area(area_id: area_id, name: name, active: active);
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return Area(area_id: area_id, name: "", active: 1);
    }
  }

  final Rx<List<Area>> _areas = Rx<List<Area>>([]);
  List<Area> get areas => _areas.value;
  getAreas() async {
    _areas.bindStream(
      firestore.collection('areas').snapshots().map(
        (QuerySnapshot query) {
          List<Area> retValue = [];
          for (var element in query.docs) {
            retValue.add(Area.fromSnap(element));
            print(element);
          }
          return retValue;
        },
      ),
    );
  }

  void createArea(
    String name,
  ) async {
    try {
      if (name.isNotEmpty) {
        final tableCollection = FirebaseFirestore.instance.collection('areas');

        final existingTableQuery =
            await tableCollection.where('name', isEqualTo: name).limit(1).get();

        if (existingTableQuery.docs.isNotEmpty) {
          Get.snackbar(
            'Thất bại!',
            'Tên khu vực đã tồn tại!',
            backgroundColor: backgroundFailureColor,
            colorText: Colors.white,
          );
        } else {
          var allDocs = await firestore.collection('areas').get();
          int len = allDocs.docs.length;

          model.Area Area = model.Area(
            area_id: 'Area-$len',
            name: name.trim().toUpperCase(),
            active: 1,
          );
          CollectionReference usersCollection =
              FirebaseFirestore.instance.collection('areas');

          await usersCollection.doc('Area-$len').set(Area.toJson());
          Get.snackbar(
            'THÀNH CÔNG!',
            'Thêm đơn vị tính mới thành công!',
            backgroundColor: backgroundSuccessColor,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          'Error!',
          'Thêm đơn vị tính thất bại!',
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

  updateArea(
    String area_id,
    String name,
    bool active,
  ) async {
    try {
      final tableCollection = FirebaseFirestore.instance.collection('areas');
      bool isFound = false;
      final List<QueryDocumentSnapshot> notMatchingAreaDocs = [];

      final existingTableQuery =
          await tableCollection.where('area_id', isNotEqualTo: area_id).get();
      for (final doc in existingTableQuery.docs) {
        notMatchingAreaDocs.add(doc);
      }
      for (final doc in notMatchingAreaDocs) {
        final String namedb = doc.get('name') as String;
        if (namedb == name) {
          isFound = true;
          break; 
        }
      }

      if (isFound) {
        Get.snackbar(
          'Thất bại!',
          'Tên khu vực đã tồn tại!',
          backgroundColor: backgroundFailureColor,
          colorText: Colors.white,
        );
      } else {
        await firestore.collection('areas').doc(area_id).update({
          "name": name.trim(),
          "active": active ? ACTIVE : DEACTIVE,
        });
        Get.snackbar(
          'THÀNH CÔNG!',
          'Cập nhật thông tin thành công!',
          backgroundColor: backgroundSuccessColor,
          colorText: Colors.white,
        );
        update();
      }
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
    String area_id,
    int active,
  ) async {
    try {
      await firestore.collection('areas').doc(area_id).update({
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
}
