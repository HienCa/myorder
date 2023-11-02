// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class Test {
  String test_id;
  String name;
  List<Test> listTest;

  Test({
    required this.test_id,
    required this.name,
    required this.listTest,
  });

  Map<String, dynamic> toJson() => {
        "test_id": test_id,
        "name": name,
        "listFood": listTest.map((food) => food.toJson()).toList(),
      };

  factory Test.fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    // Kiểm tra nếu có danh sách thực phẩm
    List<Test> listTest = [];
    if (snapshot['listTest'] != null) {
      listTest = (snapshot['listTest'] as List)
          .map((food) => Test.fromSnap(food))
          .toList();
    }

    return Test(
      test_id: snapshot['test_id'],
      name: snapshot['name'],
      listTest: listTest,
    );
  }
}

