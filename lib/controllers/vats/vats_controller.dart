// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Correct import for Firestore
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/models/vat.dart';
import 'package:myorder/models/vat.dart' as model;

class VatController extends GetxController {
  getVatById(String vat_id) async {
    try {
      DocumentSnapshot Vat =
          await firestore.collection('vats').doc(vat_id).get();
      if (Vat.exists) {
        final userData = Vat.data();
        if (userData != null && userData is Map<String, dynamic>) {
          String vat_id = userData['vat_id'] ?? '';
          String name = userData['name'] ?? '';
          int vat_percent = userData['vat_percent'] ?? 0;

          int active = userData['active'] ?? 1;
          return model.Vat(
              vat_id: vat_id,
              name: name,
              active: active,
              vat_percent: vat_percent);
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return Vat(vat_id: vat_id, name: "", active: 1, vat_percent: 0);
    }
  }

  final Rx<List<Vat>> _vats = Rx<List<Vat>>([]);
  List<Vat> get vats => _vats.value;
  getVats(String keySearch) async {
    if (keySearch.isEmpty) {
      _vats.bindStream(
        firestore.collection('vats').snapshots().map(
          (QuerySnapshot query) {
            List<Vat> retValue = [];
            for (var element in query.docs) {
              retValue.add(Vat.fromSnap(element));
              print(element);
            }
            return retValue;
          },
        ),
      );
    } else {
      _vats.bindStream(firestore
          .collection('vats')
          .orderBy('name')
          .snapshots()
          .map((QuerySnapshot query) {
        List<Vat> retVal = [];
        for (var elem in query.docs) {
          String name = elem['name'].toLowerCase();
          String search = keySearch.toLowerCase().trim();
          if (name.contains(search)) {
            retVal.add(Vat.fromSnap(elem));
          }
        }
        return retVal;
      }));
    }
  }

  final Rx<List<Vat>> _activeVats = Rx<List<Vat>>([]);
  List<Vat> get activeVats => _activeVats.value;
  getActiveVats() async {
    _activeVats.bindStream(
      firestore
          .collection('vats')
          .where('active', isEqualTo: ACTIVE)
          .snapshots()
          .map(
        (QuerySnapshot query) {
          List<Vat> retValue = [];
          for (var element in query.docs) {
            retValue.add(Vat.fromSnap(element));
            print(element);
          }
          return retValue;
        },
      ),
    );
  }

  void createVat(
    String name,
    String vat_percent,
  ) async {
    try {
      if (name.isNotEmpty) {
        var allDocs = await firestore.collection('vats').get();
        int len = allDocs.docs.length;

        model.Vat Vat = model.Vat(
          vat_id: 'Vat-$len',
          name: name.trim().toUpperCase(),
          active: 1,
          vat_percent: int.tryParse(vat_percent) ?? 0,
        );
        CollectionReference usersCollection =
            FirebaseFirestore.instance.collection('vats');

        await usersCollection.doc('Vat-$len').set(Vat.toJson());
        Get.snackbar(
          'THÀNH CÔNG!',
          'Thêm vat mới thành công!',
          backgroundColor: backgroundSuccessColor,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error!',
          'Thêm vat thất bại!',
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

  updateVat(
    String vat_id,
    String name,
    String vat_percent,
  ) async {
    try {
      await firestore.collection('vats').doc(vat_id).update({
        "name": name.trim().toUpperCase(),
        "vat_percent": int.tryParse(vat_percent) ?? 0,
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

  // Block account
  updateToggleActive(
    String vat_id,
    int active,
  ) async {
    try {
      await firestore.collection('vats').doc(vat_id).update({
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
