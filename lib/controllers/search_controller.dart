// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/models/Employee.dart';

class SearchControllerCustom extends GetxController {
  final Rx<List<Employee>> _searchedEmployees = Rx<List<Employee>>([]);

  List<Employee> get searchedEmployees => _searchedEmployees.value;
  List<Employee> friendsList = []; // Danh sách các đối tượng Employee

  searchEmployee(String typedEmployee) async {
    if (typedEmployee.isEmpty) {
      _searchedEmployees.bindStream(firestore
          .collection('Employees')
          .limit(20)
          .snapshots()
          .map((QuerySnapshot query) {
        List<Employee> retVal = [];
        for (var elem in query.docs) {
          retVal.add(Employee.fromSnap(elem));
        }
        return retVal;
      }));
    } else {
      _searchedEmployees.bindStream(firestore
          .collection('Employees')
          .orderBy('name')
          .snapshots()
          .map((QuerySnapshot query) {
        List<Employee> retVal = [];
        for (var elem in query.docs) {
          String EmployeeName = elem['name'].toLowerCase();
          String searchEmployee = typedEmployee.toLowerCase().trim();
          if (EmployeeName.startsWith(searchEmployee)) {
            retVal.add(Employee.fromSnap(elem));
          }
        }
        return retVal;
      }));
    }
  }

  Future<void> fetchFriends() async {
    try {
      String EmployeeUid = authController.user.uid;
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('Employees')
          .doc(EmployeeUid)
          .get();

      if (snapshot.exists && snapshot.data() != null) {
        List<dynamic>? friends = snapshot.data()!['friends'];
        friends = friends?.cast<String>() ?? [];
        List<Employee> employees = []; // Tạo danh sách Employee

        for (String employeeId in friends) {
          DocumentSnapshot<Map<String, dynamic>> employeeSnapshot =
              await FirebaseFirestore.instance
                  .collection('Employees')
                  .doc(employeeId)
                  .get();
          if (employeeSnapshot.exists && employeeSnapshot.data() != null) {
            // Tạo đối tượng Employee từ thông tin lấy được
            Employee employee = Employee(
              employee_id: employeeId,
              name: employeeSnapshot.data()!['name'] ?? '',
              avatar: employeeSnapshot.data()!['avatar'] ?? '',
              cccd: employeeSnapshot.data()!['cccd'] ?? '',
              gender: employeeSnapshot.data()!['gender'] ?? '',
              birthday: employeeSnapshot.data()!['birthday'] ?? '',
              phone: employeeSnapshot.data()!['phone'] ?? '',
              email: employeeSnapshot.data()!['email'] ?? '',
              password: employeeSnapshot.data()!['password'] ?? '',
            
              address: employeeSnapshot.data()!['address'] ?? '',
              role: employeeSnapshot.data()!['role'] ?? '',
              active: employeeSnapshot.data()!['active'] ?? '',
            );
            employees.add(employee);
          }
        }

        friendsList = employees;
      } else {
        friendsList = [];
      }
    } catch (e) {
      print('Error fetching received friend requests: $e');
    }
  }
}
