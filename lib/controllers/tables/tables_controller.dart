// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Correct import for Firestore
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/models/area.dart';
import 'package:myorder/models/table.dart' as model;

class TableController extends GetxController {
  getTableById(String table_id) async {
    try {
      DocumentSnapshot Table =
          await firestore.collection('tables').doc(table_id).get();
      if (Table.exists) {
        final userData = Table.data();
        if (userData != null && userData is Map<String, dynamic>) {
          String table_id = userData['table_id'] ?? '';
          String name = userData['name'] ?? '';
          int total_slot = userData['total_slot'] ?? '';
          int status = userData['status'] ?? '';
          String area_id = userData['area_id'] ?? '';
          int active = userData['active'] ?? 1;
          return model.Table(
              table_id: table_id,
              name: name,
              active: active,
              total_slot: total_slot,
              status: status,
              area_id: area_id);
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
      // return model.Table(table_id: "", name: "", active: 1, total_slot: 1, status: 1, area_id: "");
      return null;
    }
  }

  final Rx<List<model.Table>> _tables = Rx<List<model.Table>>([]);
  List<model.Table> get tables => _tables.value;
  getTables() async {
    _tables.bindStream(
      firestore.collection('tables').snapshots().map(
        (QuerySnapshot query) {
          List<model.Table> retValue = [];
          for (var element in query.docs) {
            retValue.add(model.Table.fromSnap(element));
            print(element);
          }
          return retValue;
        },
      ),
    );
  }

  void createTable(
    String name,
    String total_slot,
    String area_id,
  ) async {
    try {
      if (name.isNotEmpty) {
        final tableCollection = FirebaseFirestore.instance.collection('tables');

        final existingTableQuery =
            await tableCollection.where('name', isEqualTo: name).limit(1).get();

        if (existingTableQuery.docs.isNotEmpty) {
          Get.snackbar(
            'Thất bại!',
            'Tên bàn đã tồn tại!',
            backgroundColor: backgroundFailureColor,
            colorText: Colors.white,
          );
        } else {
          var allDocs = await firestore.collection('tables').get();
          int len = allDocs.docs.length;

          model.Table Table = model.Table(
            table_id: 'Table-$len',
            name: name.trim().toUpperCase(),
            active: ACTIVE,
            total_slot: int.tryParse(total_slot) ?? 0,
            status: TABLE_STATUS_EMPTY, // mặc định là bàn trống
            area_id: area_id, // bàn thuộc khu vực nào
          );
          CollectionReference usersCollection =
              FirebaseFirestore.instance.collection('tables');

          await usersCollection.doc('Table-$len').set(Table.toJson());
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

  updateTable(
    String table_id,
    String name,
    String total_slot,
    String area_id,
    bool active,
  ) async {
    try {
      final tableCollection = FirebaseFirestore.instance.collection('tables');
      bool isFound = false;
      final List<QueryDocumentSnapshot> notMatchingDocs = [];

      final existingTableQuery =
          await tableCollection.where('table_id', isNotEqualTo: table_id).get();
      for (final doc in existingTableQuery.docs) {
        notMatchingDocs.add(doc);
      }
      for (final doc in notMatchingDocs) {
        final String namedb = doc.get('name') as String;
        if (namedb == name) {
          isFound = true;
          break;
        }
      }

      if (isFound) {
        Get.snackbar(
          'Thất bại!',
          'Tên bàn đã tồn tại!',
          backgroundColor: backgroundFailureColor,
          colorText: Colors.white,
        );
      } else {
        await firestore.collection('tables').doc(table_id).update({
          "table_id": table_id,
          "name": name.trim().toUpperCase(),
          "active": active ? ACTIVE : DEACTIVE,
          "total_slot": int.tryParse(total_slot) ?? 0,
          "status": TABLE_STATUS_EMPTY, // mặc định là bàn trống
          "area_id": area_id, // bàn thuộc khu vực nào
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

  Future<List<Area>> getAreas() async {
    List<Area> areaList = [];
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('areas').get();
      // Lặp qua từng tài liệu trong danh sách kết quả truy vấn
      for (final doc in querySnapshot.docs) {
        final table = Area.fromSnap(doc);
        areaList.add(table);
      }
      // In danh sách bàn ra màn hình kiểm tra
      return areaList;
    } catch (e) {
      print('Error fetching tables: $e');
    }
    return areaList;
  }

  // Block account
  updateToggleActive(
    String table_id,
    int active,
  ) async {
    try {
      await firestore.collection('tables').doc(table_id).update({
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