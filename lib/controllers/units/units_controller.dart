// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Correct import for Firestore
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/models/unit.dart';
import 'package:myorder/models/unit.dart' as model;
import 'package:myorder/utils.dart';

class UnitController extends GetxController {
  getUnitById(String unit_id) async {
    try {
      DocumentSnapshot unit =
          await firestore.collection('units').doc(unit_id).get();
      if (unit.exists) {
        final userData = unit.data();
        if (userData != null && userData is Map<String, dynamic>) {
          String unit_id = userData['unit_id'] ?? '';
          String name = userData['name'] ?? '';
          String unit_id_conversion = userData['unit_id_conversion'] ?? '';
          String unit_name_conversion = userData['unit_name_conversion'] ?? '';

          int active = userData['active'] ?? 1;
          int value_conversion = userData['value_conversion'] ?? 1;
          return model.Unit(
              unit_id: unit_id,
              name: name,
              active: active,
              value_conversion: value_conversion, unit_id_conversion: unit_id_conversion, unit_name_conversion: unit_name_conversion);
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return Unit(unit_id: unit_id, name: "", active: 1, value_conversion: 1, unit_id_conversion: '', unit_name_conversion: '');
    }
  }

  final Rx<List<Unit>> _units = Rx<List<Unit>>([]);
  List<Unit> get units => _units.value;
  getUnits(String keySearch) async {
    if (keySearch.isEmpty) {
      _units.bindStream(
        firestore.collection('units').snapshots().map(
          (QuerySnapshot query) {
            List<Unit> retValue = [];
            for (var element in query.docs) {
              retValue.add(Unit.fromSnap(element));
              print(element);
            }
            return retValue;
          },
        ),
      );
    } else {
      _units.bindStream(firestore
          .collection('units')
          .orderBy('name')
          .snapshots()
          .map((QuerySnapshot query) {
        List<Unit> retVal = [];
        for (var elem in query.docs) {
          String name = elem['name'].toLowerCase();
          String search = keySearch.toLowerCase().trim();
          if (name.contains(search)) {
            retVal.add(Unit.fromSnap(elem));
          }
        }
        return retVal;
      }));
    }
  }

  void createUnit(
    String name,
    String unit_id_conversion,
    String unit_name_conversion,
    int value_conversion,
  ) async {
    try {
      if (name.isNotEmpty) {
        String id = Utils.generateUUID();

        model.Unit unit = model.Unit(
          unit_id: id,
          name: name.trim(),
          active: 1,
          value_conversion: value_conversion, unit_id_conversion: unit_id_conversion, unit_name_conversion: unit_name_conversion,
        );
        CollectionReference usersCollection =
            FirebaseFirestore.instance.collection('units');

        await usersCollection.doc(id).set(unit.toJson());
        // Get.snackbar(
        //   'THÀNH CÔNG!',
        //   'Thêm đơn vị tính mới thành công!',
        //   backgroundColor: backgroundSuccessColor,
        //   colorText: Colors.white,
        // );
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

  updateUnit(
    String unit_id,
    String name,
    int value_conversion,
    String unit_id_conversion,
    String unit_name_conversion,

  ) async {
    try {
      await firestore.collection('units').doc(unit_id).update({
        "name": name.trim(),
        "value_conversion": value_conversion,
        "unit_id_conversion": unit_id_conversion,
        "unit_name_conversion": unit_name_conversion,
      });
      // Get.snackbar(
      //   'THÀNH CÔNG!',
      //   'Cập nhật thông tin thành công!',
      //   backgroundColor: backgroundSuccessColor,
      //   colorText: Colors.white,
      // );
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
    String unit_id,
    int active,
  ) async {
    try {
      await firestore.collection('units').doc(unit_id).update({
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
