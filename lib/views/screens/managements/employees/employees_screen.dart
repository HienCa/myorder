// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/employees/employees_controller.dart';
import 'package:myorder/utils.dart';
import 'package:myorder/views/screens/managements/employees/add_employee_screen.dart';
import 'package:myorder/views/screens/managements/employees/detail_employee_screen.dart';
import 'package:myorder/views/widgets/dialogs.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

class ManagementEmployeesPage extends StatefulWidget {
  const ManagementEmployeesPage({Key? key}) : super(key: key);
  @override
  _ManagementEmployeesPageState createState() =>
      _ManagementEmployeesPageState();
}

class _ManagementEmployeesPageState extends State<ManagementEmployeesPage> {
  EmployeeController employeeController = Get.put(EmployeeController());
  @override
  void initState() {
    super.initState();
    employeeController.getEmployees("");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: primaryColor,
          secondary: primaryColor,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          leading: InkWell(
              onTap: () => {Navigator.pop(context)},
              child: const Icon(Icons.arrow_back_ios)),
          title: const Center(child: Text("QUẢN LÝ NHÂN VIÊN")),
          actions: [
            Container(
                margin: const EdgeInsets.only(right: 10),
                child: InkWell(
                    onTap: () async {
                      final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddEmployeePage()));
                      if (result == 'success') {
                        Utils.showStylishDialog(
                            context,
                            'THÀNH CÔNG!',
                            'Thêm mới nhân viên thành công!',
                            StylishDialogType.SUCCESS);
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(Icons.add_circle_outline),
                    )))
          ],
          backgroundColor: primaryColor,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 50,
                  width: 400,
                  margin: const EdgeInsets.all(kDefaultPadding),
                  padding: const EdgeInsets.symmetric(
                    horizontal: kDefaultPadding,
                    vertical: kDefaultPadding / 4, // 5 top and bottom
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.4),
                      borderRadius: borderRadiusTextField30,
                      border: Border.all(width: 1, color: borderColorPrimary)),
                  child: TextField(
                    onChanged: (value) {
                      employeeController.getEmployees(value);
                    },
                    style: const TextStyle(color: borderColorPrimary),
                    decoration: const InputDecoration(
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      fillColor: borderColorPrimary,
                      icon: Icon(
                        Icons.search,
                        color: iconColorPrimary,
                      ),
                      hintText: 'Tìm kiếm nhân viên ...',
                      hintStyle: TextStyle(color: borderColorPrimary),
                    ),
                    cursorColor: borderColorPrimary,
                  ),
                ),
                marginTop10,
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.87,
                  child: Obx(() {
                    return ListView.builder(
                        itemCount: employeeController.employees.length,
                        itemBuilder: (context, index) {
                          final employee = employeeController.employees[index];
                          String string;
                          return InkWell(
                            onTap: () async {
                              final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          StaffDetailPage(employee: employee)));
                              if (result == 'success') {
                                Utils.showStylishDialog(
                                    context,
                                    'THÀNH CÔNG!',
                                    'Cập nhật thông tin nhân viên thành công!',
                                    StylishDialogType.SUCCESS);
                              }
                            },
                            child: Card(
                              child: ListTile(
                                leading: employee.avatar != ""
                                    ? CircleAvatar(
                                        radius: 25,
                                        backgroundColor: Colors.black,
                                        backgroundImage:
                                            NetworkImage(employee.avatar!),
                                      )
                                    : CircleAvatar(
                                        child: Image.asset(
                                          'assets/images/user-default.png',
                                          width: 100,
                                          height: 100,
                                        ),
                                      ),
                                title: Row(
                                  children: [
                                    Marquee(
                                      direction: Axis.horizontal,
                                      textDirection: TextDirection.ltr,
                                      animationDuration:
                                          const Duration(seconds: 1),
                                      backDuration:
                                          const Duration(milliseconds: 4000),
                                      pauseDuration:
                                          const Duration(milliseconds: 1000),
                                      directionMarguee:
                                          DirectionMarguee.TwoDirection,
                                      child: Text(
                                        employee.name,
                                        style: textStyleNameBlackRegular,
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: RichText(
                                  text: TextSpan(
                                    text: employee.role == ROLE_CUSTOMER
                                        ? ROLE_CUSTOMER_STRING
                                        : employee.role == ROLE_STAFF
                                            ? ROLE_STAFF_STRING
                                            : employee.role == ROLE_MANAGER
                                                ? ROLE_MANAGER_STRING
                                                : employee.role == ROLE_CASHIER
                                                    ? ROLE_CASHIER_STRING
                                                    : employee.role ==
                                                            ROLE_OWNER
                                                        ? ROLE_OWNER_STRING
                                                        : ROLE_STAFF_STRING,
                                    style: const TextStyle(
                                        color: Colors
                                            .black), // Đặt kiểu cho văn bản
                                  ),
                                  maxLines: 5, // Giới hạn số dòng hiển thị
                                  overflow: TextOverflow
                                      .ellipsis, // Hiển thị dấu ba chấm khi văn bản quá dài
                                ),
                                trailing: InkWell(
                                  onTap: () => {
                                    string = employee.active == ACTIVE
                                        ? "khóa"
                                        : "bỏ khóa",
                                    showCustomAlertDialogConfirm(
                                      context,
                                      "TRẠNG THÁI HOẠT ĐỘNG",
                                      "Bạn có chắc chắn muốn $string người dùng này?",
                                      colorWarning,
                                      () async {
                                        await employeeController
                                            .updateToggleActive(
                                                employee.employee_id,
                                                employee.active);
                                      },
                                    )
                                  },
                                  child: employee.active == ACTIVE
                                      ? const Icon(
                                          Icons.key,
                                          size: 25,
                                          color: activeColor,
                                        )
                                      : const Icon(
                                          Icons.key_off,
                                          size: 25,
                                          color: deActiveColor,
                                        ),
                                ),
                              ),
                            ),
                          );
                        });
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
