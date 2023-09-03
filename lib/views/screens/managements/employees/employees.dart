import 'package:flutter/material.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/views/screens/managements/employees/custom/dialog_create_employee.dart';
import 'package:myorder/views/screens/managements/employees/employee_detail.dart';
import 'package:responsive_grid/responsive_grid.dart';

class ManagementEmployeesPage extends StatefulWidget {
  const ManagementEmployeesPage({Key? key}) : super(key: key);
  @override
  _ManagementEmployeesPageState createState() =>
      _ManagementEmployeesPageState();
}

class _ManagementEmployeesPageState extends State<ManagementEmployeesPage> {
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
          title: const Center(child: Text("QUẢN KÝ NHÂN VIÊN")),
          actions: [
            Container(
                margin: const EdgeInsets.only(right: 10),
                child: InkWell(
                    onTap: () => {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const CustomDialogCreateEmployeee(); // Hiển thị hộp thoại tùy chỉnh
                            },
                          )
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
                marginTop10,
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.87,
                  child: ResponsiveGridList(
                    desiredItemWidth: 150,
                    minSpacing: 10,
                    children: List.generate(50, (index) => index + 1).map((i) {
                      return InkWell(
                          onTap: () => {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            EmployeeDetailPage(
                                              uid: i.toString(),
                                            )))
                              },
                          child: Container(
                              height: 150,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: backgroundColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(
                                        0.5), // Màu của bóng và độ trong suốt.
                                    spreadRadius:
                                        5, // Khoảng cách mà bóng lan rộng.
                                    blurRadius: 7, // Độ mờ của bóng.
                                    offset: const Offset(
                                        0, 3), // Vị trí của bóng (dx, dy).
                                  ),
                                ],
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ClipRRect(
                                        child: Image.asset(
                                          'assets/images/logo.jpg',
                                          width: 100,
                                          height: 100,
                                        ),
                                      ),
                                      marginTop10,
                                      Marquee(
                                          direction: Axis.horizontal,
                                          textDirection: TextDirection.ltr,
                                          animationDuration:
                                              const Duration(seconds: 1),
                                          backDuration: const Duration(
                                              milliseconds: 4000),
                                          pauseDuration: const Duration(
                                              milliseconds: 1000),
                                          directionMarguee:
                                              DirectionMarguee.TwoDirection,
                                          child: const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              'Nguyễn Văn Hiền Nguyễn Văn Hiền',
                                              style: textStyleBlackRegular,
                                            ),
                                          )),
                                    ],
                                  ),
                                ],
                              )));
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
