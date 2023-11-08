// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/constants/app_constants.dart';

enum DashBoardHome { Serving, Booking, Finish }

class DashboardHome extends StatefulWidget {
  const DashboardHome({super.key});

  @override
  State<DashboardHome> createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome> {
  @override
  void initState() {
    super.initState();
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    isServing = true;
    isBooking = false;
    isFinish = false;
  }

  bool isServing = true;
  bool isBooking = false;
  bool isFinish = false;

  void setUpScreen(DashBoardHome dashBoardHome) {
    switch (dashBoardHome) {
      case DashBoardHome.Serving:
        setState(() {
          isServing = true;
          isBooking = false;
          isFinish = false;
        });
      case DashBoardHome.Booking:
        setState(() {
          isServing = false;
          isBooking = true;
          isFinish = false;
        });
      case DashBoardHome.Finish:
        setState(() {
          isServing = false;
          isBooking = false;
          isFinish = true;
        });

      default:
    }
  }

  var keySearch = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 50,
            color: backgroundColor,
            child: Row(children: [
              InkWell(
                onTap: () {
                  setUpScreen(DashBoardHome.Serving);
                },
                child: Column(children: [
                  Expanded(
                    child: SizedBox(
                      width: 100,
                      child: Center(
                        child: Text(
                          "ĐANG HOẠT ĐỘNG",
                          style: isServing
                              ? textStyleTabLandscapeActive
                              : textStyleTabLandscapeDeActive,
                        ),
                      ),
                    ),
                  ),
                  isServing
                      ? Container(
                          height: 5,
                          width: 80,
                          decoration: const BoxDecoration(
                            color: primaryColor,
                            borderRadius: borderContainer8,
                          ),
                        )
                      : const SizedBox()
                ]),
              ),
              InkWell(
                onTap: () {
                  setUpScreen(DashBoardHome.Booking);
                },
                child: Column(children: [
                  Expanded(
                    child: SizedBox(
                      width: 100,
                      child: Center(
                        child: Text(
                          "ĐẶT CHỖ",
                          style: isBooking
                              ? textStyleTabLandscapeActive
                              : textStyleTabLandscapeDeActive,
                        ),
                      ),
                    ),
                  ),
                  isBooking
                      ? Container(
                          height: 5,
                          width: 80,
                          decoration: const BoxDecoration(
                            color: primaryColor,
                            borderRadius: borderContainer8,
                          ),
                        )
                      : const SizedBox()
                ]),
              ),
              InkWell(
                onTap: () {
                  setUpScreen(DashBoardHome.Finish);
                },
                child: Column(children: [
                  Expanded(
                    child: SizedBox(
                      width: 100,
                      child: Center(
                        child: Text(
                          "HOÀN TẤT",
                          style: isFinish
                              ? textStyleTabLandscapeActive
                              : textStyleTabLandscapeDeActive,
                        ),
                      ),
                    ),
                  ),
                  isFinish
                      ? Container(
                          height: 5,
                          width: 80,
                          decoration: const BoxDecoration(
                            color: primaryColor,
                            borderRadius: borderContainer8,
                          ),
                        )
                      : const SizedBox()
                ]),
              ),
              const Spacer(),
              Container(
                height: 40,
                width: 300,
                padding: const EdgeInsets.only(left: 4,),
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                    borderRadius: borderRadiusTextField30,
                    border: Border.all(width: 1, color: borderColorPrimary)),
                child: TextField(
                  onChanged: (value) {
                    // areaController.getAreas(value);
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
                    hintText: 'Tìm kiếm đơn hàng ...',
                    hintStyle: TextStyle(color: borderColorPrimary),
                  ),
                  cursorColor: borderColorPrimary,
                ),
              ),
            ]),
          ),
          Expanded(
              child: Container(
            color: primaryColor,
          )),
        ],
      ),
    );
  }
}
