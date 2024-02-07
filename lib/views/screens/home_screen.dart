// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myorder/caches/caches.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/daily_sales/daily_sales_controller.dart';
import 'package:myorder/controllers/employees/employees_controller.dart';
import 'package:myorder/models/employee.dart';
import 'package:myorder/utils.dart';
import 'package:myorder/views/widgets/custom_icon.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DailySalesController dailySalesController = Get.put(DailySalesController());
  EmployeeController employeeController = Get.put(EmployeeController());
  MyCacheManager myCacheManager = MyCacheManager();

  @override
  void initState() {
    super.initState();
    setDailySale(); //CACHE - THIẾT LẬP SỐ LƯỢNG BÁN TRONG NGÀY
    setCurrentEmployee(); //CACHE - THÔNG TIN NHÂN VIÊN
    employeeController.updateTokenDevice();
  }

  int pageIdx = 0;

  Future<void> setDailySale() async {
    DateTime now = Timestamp.now().toDate();
    //vì daily sale ở firebase luôn 12h, vì chỉ chọn ngày
    now = DateTime(now.year, now.month, now.day, 0, 0, 0, 0);
    print(now);

    //ngày đã áp dụng
    if (await myCacheManager.isInCache(CACHE_DAILY_SALE_KEY)) {
      String? dateDailySaleString =
          await myCacheManager.getFromCache(CACHE_DAILY_SALE_KEY);

      if (dateDailySaleString != "") {
        DateTime dateDailySale = DateTime.parse(dateDailySaleString ?? "");
        //kiểm tra hôm nay đã set up chưa
        if (Utils.isSameDay(now, dateDailySale)) {
          print("HÔM NAY ĐÃ SET UP DAILY SALE");
        } else {
          print("HÔM NAY CHƯA SET UP DAILY SALE");

          //kiểm tra xem đã thiết lập lịch cho hôm nay chưa
          if (await dailySalesController.isDailySalesByDateTime(now)) {
            print("SETTING UP...");

            await myCacheManager.addToCache(
                CACHE_DAILY_SALE_KEY, now.toString());

            //đã được set up
            dailySalesController.setUpDailySalesByDateTime(now);
          } else {
            dailySalesController.reSetDailySale();
            Utils.showStylishDialog(
                context,
                "CẢNH BÁO",
                "QUÁN CHƯA THIẾT LẬP SỐ LƯỢNG BÁN CỦA CÁC MÓN ĂN HÔM NAY.\n VUI LÒNG NHẮC QUẢN LÝ THIẾT LẬP NGAY!",
                StylishDialogType.WARNING);
          }
        }
      }
    } else {
      //kiểm tra xem đã thiết lập lịch cho hôm nay chưa

      if (await dailySalesController.isDailySalesByDateTime(now)) {
        //đã được set up
        await myCacheManager.addToCache(CACHE_DAILY_SALE_KEY, now.toString());

        dailySalesController.setUpDailySalesByDateTime(now);
      } else {
        dailySalesController.reSetDailySale();
        Utils.showStylishDialog(
            context,
            "CẢNH BÁO",
            "QUÁN CHƯA THIẾT LẬP SỐ LƯỢNG BÁN CỦA CÁC MÓN ĂN HÔM NAY.\nVUI LÒNG NHẮC QUẢN LÝ THIẾT LẬP NGAY!",
            StylishDialogType.WARNING);
      }
    }
  }

  Future<void> setCurrentEmployee() async {
    try {
      Employee currentEmployee =
          await employeeController.getEmployeeById(authController.user.uid);
      myCacheManager.addToCache(
          CACHE_EMPLOYEE_ID_KEY, currentEmployee.employee_id);

      myCacheManager.addToCache(CACHE_EMPLOYEE_NAME_KEY, currentEmployee.name);
      myCacheManager.addToCache(CACHE_EMPLOYEE_ROLE_KEY, currentEmployee.role);
    } catch (e) {
      print("Không tìm thấy thông tin nhân viên");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (idx) async {
          /*
            0 TỔNG QUAN: QUẢN LÝ, CHỦ QUÁN
            1 ĐƠN HÀNG: QUẢN LÝ, CHỦ QUÁN, NHÂN VIÊN PHỤC VỤ
            2
            3 KHU VỰC: QUẢN LÝ, CHỦ QUÁN, NHÂN VIÊN PHỤC VỤ
            4 TIỆN ÍCH: QUẢN LÝ, CHỦ QUÁN, BẾP/BAR/OTHER
            
          */
          int? role = int.tryParse(
              await myCacheManager.getFromCache(CACHE_EMPLOYEE_ROLE_KEY) ??
                  "0");
          if (idx == 0) {
            //TỔNG QUAN: QUẢN LÝ, CHỦ QUÁN
            if (role == ROLE_OWNER || role == ROLE_MANAGER) {
              setState(() {
                pageIdx = idx;
              });
            } else {
              Utils.showStylishDialog(
                  context,
                  "THÔNG BÁO",
                  "Bạn chưa có quyền truy cập tính năng này!",
                  StylishDialogType.WARNING);
            }
          } else if (idx == 1 || idx == 3) {
            //ĐƠN HÀNG: QUẢN LÝ, CHỦ QUÁN, NHÂN VIÊN PHỤC VỤ
            // KHU VỰC: QUẢN LÝ, CHỦ QUÁN, NHÂN VIÊN PHỤC VỤ
            if (role == ROLE_OWNER ||
                role == ROLE_MANAGER ||
                role == ROLE_STAFF) {
              setState(() {
                pageIdx = idx;
              });
            } else {
              Utils.showStylishDialog(
                  context,
                  "THÔNG BÁO",
                  "Bạn chưa có quyền truy cập tính năng này!",
                  StylishDialogType.WARNING);
            }
          } else if (idx == 4) {
            //TIỆN ÍCH: QUẢN LÝ, CHỦ QUÁN, BẾP/BAR/OTHER
            if (role == ROLE_OWNER ||
                role == ROLE_MANAGER ||
                role == ROLE_CHEF ||
                role == ROLE_BAR ||
                role == ROLE_OTHER ||
                role == ROLE_CASHIER) {
              setState(() {
                pageIdx = idx;
              });
            } else {
              Utils.showStylishDialog(
                  context,
                  "THÔNG BÁO",
                  "Bạn chưa có quyền truy cập tính năng này!",
                  StylishDialogType.WARNING);
            }
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: backgroundColor,
        selectedItemColor: iconColorPrimary,
        unselectedItemColor: unselectedItemColor,
        currentIndex: pageIdx,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30),
            label: 'Tổng quan',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.notes, size: 30),
            label: 'Đơn hàng',
          ),
          BottomNavigationBarItem(
            // icon: CustomIcon(),
            icon: IconButton(
              onPressed: () => {
                // pickVideo(ImageSource.gallery, context)
              },
              icon: const CustomIcon(),
            ),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.table_bar_sharp, size: 30),
            label: 'Khu vực',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 30),
            label: 'Tiện ích',
          ),
        ],
      ),
      body: pages[pageIdx],
    );
  }
}
