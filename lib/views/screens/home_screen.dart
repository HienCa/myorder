// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myorder/caches/caches.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/daily_sales/daily_sales_controller.dart';
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

  @override
  void initState() {
    super.initState();
    firstSetUp();
  }

  int pageIdx = 0;

  Future<void> firstSetUp() async {
    DateTime now = Timestamp.now().toDate();
    //vì daily sale ở firebase luôn 12h, vì chỉ chọn ngày
    now = DateTime(now.year, now.month, now.day, 0, 0, 0, 0);
    print(now);
    MyCacheManager myCacheManager = MyCacheManager();

    //ngày đã áp dụng
    if (await myCacheManager.isInCache(DAILY_SALE_KEY)) {
      String? dateDailySaleString =
          await myCacheManager.getFromCache(DAILY_SALE_KEY);

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

          await myCacheManager.addToCache(DAILY_SALE_KEY, now.toString());

            //đã được set up
            dailySalesController.setUpDailySalesByDateTime(now);
          } else {
            dailySalesController.reSetDailySale();
            Utils.showStylishDialog(
                context,
                "LƯU Ý",
                "QUÁN CHƯA THIẾT LẬP SỐ LƯỢNG BÁN CỦA CÁC MÓN ĂN",
                StylishDialogType.WARNING);
          }
        }
      }
    } else {
      //kiểm tra xem đã thiết lập lịch cho hôm nay chưa
      if (await dailySalesController.isDailySalesByDateTime(now)) {
        //đã được set up
        await myCacheManager.addToCache(DAILY_SALE_KEY, now.toString());

        dailySalesController.setUpDailySalesByDateTime(now);
      } else {
        dailySalesController.reSetDailySale();
        Utils.showStylishDialog(
            context,
            "LƯU Ý",
            "QUÁN CHƯA THIẾT LẬP SỐ LƯỢNG BÁN CỦA CÁC MÓN ĂN",
            StylishDialogType.WARNING);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (idx) {
          setState(() {
            pageIdx = idx;
          });
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
