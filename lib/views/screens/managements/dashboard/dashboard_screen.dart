// ignore_for_file: constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/constants/app_constants.dart';
import 'package:myorder/utils.dart';
import 'package:myorder/views/screens/managements/dashboard/home/home_screen.dart';
import 'package:myorder/views/screens/managements/dashboard/take_away/take_away_screen.dart';
import 'package:myorder/views/widgets/dialogs/dialog_confirm_pop_screen.dart';

enum DashBoardScreen { Home, Order, TakeAway, Back }

class MyDashBoard extends StatefulWidget {
  const MyDashBoard({super.key});

  @override
  State<MyDashBoard> createState() => _MyDashBoardState();
}

class _MyDashBoardState extends State<MyDashBoard> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    isHome = true;
    isOrder = false;
    isTakeAway = false;
    isBack = false;
  }

  double height = 0;
  double width = 0;
  bool isHome = true;
  bool isOrder = false;
  bool isTakeAway = false;
  bool isBack = false;

  void setUpScreen(DashBoardScreen dashBoardScreen) {
    switch (dashBoardScreen) {
      case DashBoardScreen.Home:
        setState(() {
          isHome = true;
          isOrder = false;
          isTakeAway = false;
          isBack = false;
        });
      case DashBoardScreen.Order:
        setState(() {
          isHome = false;
          isOrder = true;
          isTakeAway = false;
          isBack = false;
        });
      case DashBoardScreen.TakeAway:
        setState(() {
          isHome = false;
          isOrder = false;
          isTakeAway = true;
          isBack = false;
        });
      case DashBoardScreen.Back:
        setState(() {
          isHome = false;
          isOrder = false;
          isTakeAway = false;
          isBack = true;
        });
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 3,
      child: 
        Scaffold(
          body: Container(
            color: grayColor200,
            child: Row(
              children: [
                Stack(children: [
                  Container(
                    height: height * 0.8,
                    width: 60,
                    color: grayColor200,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: borderContainer8,
                        color: secondColor,
                      ),
                      margin: const EdgeInsets.only(left: 5),
                      height: height * 0.5,
                      width: 50,
                      child: Column(
                        children: [
                          //Home
                          Expanded(
                              child: IconButton(
                            onPressed: () {
                              setUpScreen(DashBoardScreen.Home);
                            },
                            icon: Column(
                              children: [
                                Expanded(
                                  child: Icon(
                                    Icons.home,
                                    color: isHome ? primaryColor : iconColor,
                                  ),
                                ),
                                Container(
                                  width: 50,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    color: isHome
                                        ? primaryColor
                                        : transparentColor,
                                    borderRadius: borderContainer8,
                                  ),
                                ),
                              ],
                            ),
                          )),
                          //ORDER
                          Expanded(
                              child: IconButton(
                            onPressed: () {
                              setUpScreen(DashBoardScreen.Order);
                            },
                            icon: Column(
                              children: [
                                Expanded(
                                  child: Icon(
                                    Icons.dining,
                                    color: isOrder ? primaryColor : iconColor,
                                  ),
                                ),
                                Container(
                                  width: 50,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    color: isOrder
                                        ? primaryColor
                                        : transparentColor,
                                    borderRadius: borderContainer8,
                                  ),
                                ),
                              ],
                            ),
                          )),
                          //TAKE AWAY
                          Expanded(
                              child: IconButton(
                            onPressed: () {
                              setUpScreen(DashBoardScreen.TakeAway);
                            },
                            icon: Column(
                              children: [
                                Expanded(
                                  child: Icon(
                                    Icons.car_rental,
                                    color:
                                        isTakeAway ? primaryColor : iconColor,
                                  ),
                                ),
                                Container(
                                  width: 50,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    color: isTakeAway
                                        ? primaryColor
                                        : transparentColor,
                                    borderRadius: borderContainer8,
                                  ),
                                ),
                              ],
                            ),
                          )),
                          //BACK SCREEN
                          Expanded(
                              child: IconButton(
                            onPressed: () async {
                              setUpScreen(DashBoardScreen.Back);
                              final result = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return const MyDialogMessagePopScreen(
                                    title: 'THOÁT MÀN HÌNH',
                                    discription:
                                        'Bạn có chắc chắn muốn rời khỏi màn hình này?',
                                    
                                  );
                                },
                              );
                              if (result == 'success') {
                                Utils.myPopResult(context, 'success');
                              }
                            },
                            icon: Column(
                              children: [
                                Expanded(
                                  child: Transform.rotate(
                                    angle: isBack
                                        ? 3.14159265359
                                        : 0, // Giá trị 3.14159265359 tương đương với 180 độ
                                    child: Icon(
                                      Icons.exit_to_app,
                                      color: isBack ? colorCancel : iconColor,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 50,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    color:
                                        isBack ? colorCancel : transparentColor,
                                    borderRadius: borderContainer8,
                                  ),
                                ),
                              ],
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                ]),
                isHome ? const Expanded(flex: 1, child: DashboardHome()): const SizedBox(),
                isOrder ? const Expanded(flex: 1, child: DashboardHome()): const SizedBox(),
                isTakeAway ? const Expanded(flex: 1, child: DashboardTakeAway()): const SizedBox()
              ],
            ),
          ),
        ),
      
    );
  }
}
