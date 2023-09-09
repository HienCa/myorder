// // ignore_for_file: non_constant_identifier_names, avoid_print

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart'; // Correct import for Firestore
// import 'package:flutter/material.dart';

// import 'package:get/get.dart';
// import 'package:myorder/config.dart';
// import 'package:myorder/constants.dart';
// import 'package:myorder/models/table.dart';
// import 'package:myorder/models/table.dart' as model;

// class TableController extends GetxController {
//   getTableById(String table_id) async {
//     try {
//       DocumentSnapshot Table =
//           await firestore.collection('Tables').doc(table_id).get();
//       if (Table.exists) {
//         final userData = Table.data();
//         if (userData != null && userData is Map<String, dynamic>) {
//           String table_id = userData['table_id'] ?? '';
//           String name = userData['name'] ?? '';

//           int active = userData['active'] ?? 1;
//           return model.Table(table_id: table_id, name: name, active: active);
//         }
//       }
//     } catch (e) {
//       print('Error fetching user data: $e');
//       return Table(table_id: table_id, name: "", active: 1);
//     }
//   }

//   final Rx<List<Table>> _Tables = Rx<List<Table>>([]);
//   List<Table> get Tables => _Tables.value;
//   getTables() async {
//     _Tables.bindStream(
//       firestore.collection('Tables').snapshots().map(
//         (QuerySnapshot query) {
//           List<Table> retValue = [];
//           for (var element in query.docs) {
//             retValue.add(Table.fromSnap(element));
//             print(element);
//           }
//           return retValue;
//         },
//       ),
//     );
//   }

//   void createTable(
//     String name,
//   ) async {
//     try {
//       if (name.isNotEmpty) {
//         var allDocs = await firestore.collection('Tables').get();
//         int len = allDocs.docs.length;

//         model.Table Table = model.Table(
//           table_id: 'Table-$len',
//           name: name,
//           active: 1,
//         );
//         CollectionReference usersCollection =
//             FirebaseFirestore.instance.collection('Tables');

//         await usersCollection.doc('Table-$len').set(Table.toJson());
//         Get.snackbar(
//           'THÀNH CÔNG!',
//           'Thêm đơn vị tính mới thành công!',
//           backgroundColor: backgroundSuccessColor,
//           colorText: Colors.white,
//         );
//       } else {
//         Get.snackbar(
//           'Error!',
//           'Thêm đơn vị tính thất bại!',
//           backgroundColor: backgroundFailureColor,
//           colorText: Colors.white,
//         );
//       }
//     } on FirebaseAuthException catch (e) {
//       Get.snackbar(
//         'Error!',
//         e.message ?? 'Có lỗi xãy ra.',
//       );
//     } catch (e) {
//       Get.snackbar(
//         'Error!',
//         e.toString(),
//       );
//     }
//   }

//   updateTable(
//     String table_id,
//     String name,
//   ) async {
//     try {
//       await firestore.collection('Tables').doc(table_id).update({
//         "name": name,
//       });
//       Get.snackbar(
//         'THÀNH CÔNG!',
//         'Cập nhật thông tin thành công!',
//         backgroundColor: backgroundSuccessColor,
//         colorText: Colors.white,
//       );
//       update();
//     } catch (e) {
//       Get.snackbar(
//         'Cập nhật thất bại!',
//         e.toString(),
//         backgroundColor: backgroundFailureColor,
//         colorText: Colors.white,
//       );
//     }
//   }

//   // Block account
//   updateToggleActive(
//     String table_id,
//     int active,
//   ) async {
//     try {
//       await firestore.collection('Tables').doc(table_id).update({
//         "active": active == ACTIVE ? DEACTIVE : ACTIVE,
//       });

//       Get.snackbar(
//         'THÀNH CÔNG!',
//         'Cập nhật thông tin thành công!',
//         backgroundColor: backgroundSuccessColor,
//         colorText: Colors.white,
//       );
//       update();
//     } catch (e) {
//       Get.snackbar(
//         'Cập nhật thất bại!',
//         e.toString(),
//         backgroundColor: backgroundFailureColor,
//         colorText: Colors.white,
//       );
//     }
//   }
// }
