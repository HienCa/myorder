// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class Employee {
  String employee_id;
  String name;
  String? avatar;
  String cccd;
  String gender;
  String birthday;
  String phone;
  String email;
  String password;

  String address;
  String device_token;
  int role;
  int active;

  Employee({
    required this.employee_id,
    required this.name,
    this.avatar,
    required this.cccd,
    required this.gender,
    required this.birthday,
    required this.phone,
    required this.email,
    required this.password,
    required this.address,
    required this.device_token,
    required this.role,
    required this.active,
  });

  Map<String, dynamic> toJson() => {
        "employee_id": employee_id,
        "name": name,
        "avatar": avatar,
        "cccd": cccd,
        "gender": gender,
        "birthday": birthday,
        "phone": phone,
        "email": email,
        "password": password,
        "address": address,
        "device_token": device_token,
        "role": role,
        "active": active,
      };

  static Employee fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Employee(
      employee_id: snapshot['employee_id'] ?? "",
      name: snapshot['name'] ?? "",
      avatar: snapshot['avatar'] ?? "",
      cccd: snapshot['cccd'] ?? "",
      gender: snapshot['gender'] ?? "",
      birthday: snapshot['birthday'] ?? "",
      phone: snapshot['phone'] ?? "",
      email: snapshot['email'] ?? "",
      password: snapshot['password'] ?? "",
      address: snapshot['address'] ?? "",
      device_token: snapshot['device_token'] ?? "",
      role: snapshot['role'] ?? "",
      active: snapshot['active'] ?? "",
    );
  }
}
