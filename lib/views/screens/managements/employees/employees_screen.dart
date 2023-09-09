import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/employees/employees_controller.dart';
import 'package:myorder/views/screens/managements/employees/add_employee_screen.dart';
import 'package:myorder/views/screens/managements/employees/detail_employee_screen.dart';
import 'package:myorder/views/widgets/dialogs.dart';

class ManagementEmployeesPage extends StatefulWidget {
  const ManagementEmployeesPage({Key? key}) : super(key: key);
  @override
  _ManagementEmployeesPageState createState() =>
      _ManagementEmployeesPageState();
}

class _ManagementEmployeesPageState extends State<ManagementEmployeesPage> {
  EmployeeController employeeController = Get.put(EmployeeController());

  @override
  Widget build(BuildContext context) {
    employeeController.getEmployees();

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
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddEmployeePage())),
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
                marginTop10,
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.87,
                  child: Obx(() {
                    return ListView.builder(
                        itemCount: employeeController.employees.length,
                        itemBuilder: (context, index) {
                          final employee = employeeController.employees[index];
                          String string;
                          return Card(
                            child: ListTile(
                              leading: InkWell(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            EmployeeDetailPage(
                                                employeeId:
                                                    employee.employee_id))),
                                child: employee.avatar != ""
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
                              ),
                              title: Row(
                                children: [
                                  InkWell(
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EmployeeDetailPage(
                                                    employeeId:
                                                        employee.employee_id))),
                                    child: Marquee(
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
                                  ),
                                ],
                              ),
                              subtitle: InkWell(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            EmployeeDetailPage(
                                                employeeId:
                                                    employee.employee_id))),
                                child: RichText(
                                  text: TextSpan(
                                    text: employee.role,
                                    style: const TextStyle(
                                        color: Colors
                                            .black), // Đặt kiểu cho văn bản
                                  ),
                                  maxLines: 5, // Giới hạn số dòng hiển thị
                                  overflow: TextOverflow
                                      .ellipsis, // Hiển thị dấu ba chấm khi văn bản quá dài
                                ),
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
