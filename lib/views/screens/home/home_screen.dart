// ignore_for_file: library_prefixes

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/bills/bills_controller.dart';
import 'package:myorder/controllers/reports/reports_controller.dart';
import 'package:myorder/models/bill.dart';
import 'package:myorder/models/charts/data_chart.dart';
import 'package:myorder/utils.dart';
import 'package:myorder/views/screens/home/chart/bar_chart_sample7.dart';
import 'package:myorder/views/screens/home/chart/color_of_charts/app_colors.dart';
import 'package:myorder/views/screens/home/chart/pie_chart_sample3.dart';
// import 'package:pie_chart/pie_chart.dart' as PieChart;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ReportController reportController = Get.put(ReportController());
  BillController billController = Get.put(BillController());
  Map<String, double> dataMap = {};
  @override
  void initState() {
    super.initState();
    reportController.getReportServingOrders();
    reportController.getBills();
    reportController.getNumberOfCanceledOrders();
    billController.getBills(0, ""); // HÔM NAY
    reportController.getReportFoodSales();
    data = convertListToBarChartGroupData(
        reportController.reportFoodSales.myDataBarChart);
    bottomTitles =
        reportController.reportFoodSales.myDataBarChart.bottom_titles;

    //BAR CHART==============
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
    reportController.getReportBarChartAll(startOfDay, endOfDay);
    reportController.getReportBarChartFood(startOfDay, endOfDay);
    reportController.getReportBarChartTable(startOfDay, endOfDay);
    reportController.getReportBarChartCategory(startOfDay, endOfDay);
    reportController.getReportBarChartEmployee(startOfDay, endOfDay);

    //PIE CHART
    reportController.getReportPieChartAll(startOfDay, endOfDay); //tổng
    reportController.getReportPieChartCategory(startOfDay, endOfDay);
    reportController.getReportPieChartFood(startOfDay, endOfDay);
    reportController.getReportPieChartTable(startOfDay, endOfDay);
    reportController.getReportPieChartEmployee(startOfDay, endOfDay);
  }

  List<BarChartGroupData> data = [];
  List<String> leftTitles = [];
  List<String> bottomTitles = [];
  List<BarChartGroupData> convertListToBarChartGroupData(MyDataBarChart data) {
    return data.values.asMap().entries.map((entry) {
      final int x = entry.key;
      final double y1 = entry.value;
      // final double y2 = y1 * 1.5;

      return makeGroupData(x, y1, 0);
    }).toList();
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: AppColors.contentColorYellow,
          width: 7,
        ),
        // BarChartRodData(
        //   toY: y2,
        //   color: widget.rightBarColor,
        //   width: width,
        // ),
        //LÀ CỘT THỨ 2
      ],
    );
  }

  double getDepositAmount(List<Bill> list) {
    double totalDeposit = 0;
    for (Bill bill in list) {
      totalDeposit += bill.deposit_amount;
    }
    return totalDeposit;
  }

  int selectedIndexBarChartCategory = 0;
  int selectedIndexBarChartFood = 0;
  int selectedIndexBarChartTable = 0;
  int selectedIndexBarChartEmployee = 0;

  int selectedIndexPieChartCategory = 0;
  int selectedIndexPieChartFood = 0;
  int selectedIndexPieChartTable = 0;
  int selectedIndexPieChartEmployee = 0;

  int selectedIndexPieChart = 0;
  int selectedIndexBarChart = 0;

  List options = TIME_OPTION;
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
          body: SafeArea(child: SingleChildScrollView(child: Obx(() {
            return Column(
              children: [
                //ĐƠN HÀNG HÔM NAY
                SizedBox(
                  height: 40,
                  child: ListTile(
                    leading: const Icon(
                      Icons.bookmark,
                      color: iconColor,
                    ),
                    title: const Text("ĐƠN HÀNG HÔM NAY",
                        style: textStyleTitleGrayBold20),
                    subtitle: Text(
                        "${reportController.reportBills.quantity + reportController.reportServingOrder.quantity + reportController.reportCancelOrder.quantity}",
                        style: textStyleSubTitlePrimaryRegular20),
                  ),
                ),
                ListTile(
                  title: const Text("Đang phục vụ",
                      style: textStyleTitleGrayRegular16),
                  trailing: Text(
                      "${reportController.reportServingOrder.quantity}",
                      style: textStylePrimary16),
                ),
                ListTile(
                  title:
                      const Text("Đã hủy", style: textStyleTitleGrayRegular16),
                  trailing: Text(
                      "${reportController.reportCancelOrder.quantity}",
                      style: textStyleCancel16),
                ),
                ListTile(
                  title: const Text("Đã thanh toán",
                      style: textStyleTitleGrayRegular16),
                  trailing: Text("${reportController.reportBills.quantity}",
                      style: textStyleSuccess16),
                ),

                Container(
                  height: 10,
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 248, 246, 246)),
                ),

                //TIỀN THU TRONG NGÀY
                const SizedBox(
                  height: 40,
                  child: ListTile(
                    leading: Icon(
                      Icons.bookmark,
                      color: iconColor,
                    ),
                    title: Text("TIỀN THU TRONG NGÀY",
                        style: textStyleTitleGrayBold20),
                  ),
                ),
                ListTile(
                  title: const Text("Tiền mặt",
                      style: textStyleTitleGrayRegular16),
                  trailing: Text(
                      Utils.formatCurrency(
                          reportController.reportBills.total_amount),
                      style: textStyleTrailingPrimaryRegular16),
                ),

                ListTile(
                  title:
                      const Text("Đặt cọc", style: textStyleTitleGrayRegular16),
                  trailing: Text(
                      Utils.formatCurrency(
                          getDepositAmount(billController.bills)),
                      style: textStyleTrailingPrimaryRegular16),
                ),
                // const ListTile(
                //   title: Text("Thẻ", style: textStyleTitleGrayRegular16),
                //   trailing: Text("0", style: textStyleTrailingPrimaryRegular16),
                // ),
                // const ListTile(
                //   title:
                //       Text("Chuyển khoản", style: textStyleTitleGrayRegular16),
                //   trailing: Text("0", style: textStyleTrailingPrimaryRegular16),
                // ),
                // const ListTile(
                //   title:
                //       Text("Sử dụng điểm", style: textStyleTitleGrayRegular16),
                //   trailing: Text("0", style: textStyleTrailingPrimaryRegular16),
                // ),
                // const ListTile(
                //   title: Text("Bán hàng", style: textStyleTitleGrayRegular16),
                //   trailing: Text("0", style: textStyleTrailingPrimaryRegular16),
                // ),
                Container(
                  height: 10,
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 248, 246, 246)),
                ),

                //DOANH THU TẠM TÍNH HÔM NAY
                SizedBox(
                  height: 50,
                  child: ListTile(
                    leading: const Icon(
                      Icons.bookmark,
                      color: iconColor,
                    ),
                    title: const Text("DOANH THU TẠM TÍNH HÔM NAY",
                        style: textStyleTitleGrayBold20),
                    subtitle: Text(
                        Utils.formatCurrency(reportController
                                .reportBills.total_amount +
                            reportController.reportServingOrder.total_amount +
                            reportController.reportCancelOrder.total_amount),
                        style: textStyleSubTitlePrimaryRegular20),
                  ),
                ),

                ListTile(
                  title: const Text("Đang phục vụ",
                      style: textStyleTitleGrayRegular16),
                  trailing: Text(
                      Utils.formatCurrency(
                          reportController.reportServingOrder.total_amount),
                      style: textStylePrimary16),
                ),
                ListTile(
                  title:
                      const Text("Đã hủy", style: textStyleTitleGrayRegular16),
                  trailing: Text(
                      Utils.formatCurrency(
                          reportController.reportCancelOrder.total_amount),
                      style: textStyleCancel16),
                ),
                ListTile(
                  title: const Text("Đã thanh toán",
                      style: textStyleTitleGrayRegular16),
                  trailing: Text(
                      Utils.formatCurrency(
                          reportController.reportBills.total_amount),
                      style: textStyleSuccess16),
                ),
                //line char
                Container(
                  height: 10,
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 248, 246, 246)),
                ),

                Container(
                  height: 10,
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 248, 246, 246)),
                ),
                //DANH MỤC
                Container(
                  margin: const EdgeInsets.only(left: 5),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 50,
                        child: ListTile(
                          leading: Icon(
                            Icons.bookmark,
                            color: iconColor,
                          ),
                          title: Text("DOANH THU THEO DANH MỤC",
                              style: textStyleTitleGrayBold20),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: kDefaultPadding / 2),
                        height: 35,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: options.length,
                          itemBuilder: (context, index) => GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndexBarChartCategory = index;
                                reportController.getReportBarChartCategory(
                                    Utils.getTimeOption(index).startDate,
                                    Utils.getTimeOption(index).endDate);
                                reportController.getReportPieChartCategory(
                                    Utils.getTimeOption(index).startDate,
                                    Utils.getTimeOption(index).endDate);
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(
                                left: kDefaultPadding,
                                // At end item it add extra 20 right  padding
                                right: index == options.length - 1
                                    ? kDefaultPadding
                                    : 0,
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: kDefaultPadding),
                              decoration: BoxDecoration(
                                  color: index == selectedIndexBarChartCategory
                                      ? primaryColor
                                      : textWhiteColor,
                                  borderRadius: BorderRadius.circular(20),
                                  border: index == selectedIndexBarChartCategory
                                      ? Border.all(
                                          width: 5, color: primaryColor)
                                      : Border.all(
                                          width: 1, color: primaryColor)),
                              child: Text(
                                options[index],
                                style: index == selectedIndexBarChartCategory
                                    ? const TextStyle(
                                        color: textWhiteColor,
                                        fontWeight: FontWeight.bold)
                                    : const TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                        ),
                      ),
                      marginTop20,
                      BarChartSample7(
                        data: reportController.reportBarChartCategory,
                        isShowImage: false,
                      ),
                      marginTop10,
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 5),
                  child: Column(
                    children: [
                      // const SizedBox(
                      //   height: 50,
                      //   child: ListTile(
                      //     leading: Icon(
                      //       Icons.bookmark,
                      //       color: iconColor,
                      //     ),
                      //     title: Text("DOANH THU DANH MỤC",
                      //         style: textStyleTitleGrayBold20),
                      //   ),
                      // ),
                      // Container(
                      //   margin: const EdgeInsets.symmetric(
                      //       vertical: kDefaultPadding / 2),
                      //   height: 35,
                      //   child: ListView.builder(
                      //     scrollDirection: Axis.horizontal,
                      //     itemCount: options.length,
                      //     itemBuilder: (context, index) => GestureDetector(
                      //       onTap: () {
                      //         setState(() {
                      //           selectedIndexPieChartCategory = index;
                      //           reportController.getReportPieChartCategory(
                      //               Utils.getTimeOption(index).startDate,
                      //               Utils.getTimeOption(index).endDate);
                      //         });
                      //       },
                      //       child: Container(
                      //         alignment: Alignment.center,
                      //         margin: EdgeInsets.only(
                      //           left: kDefaultPadding,
                      //           // At end item it add extra 20 right  padding
                      //           right: index == options.length - 1
                      //               ? kDefaultPadding
                      //               : 0,
                      //         ),
                      //         padding: const EdgeInsets.symmetric(
                      //             horizontal: kDefaultPadding),
                      //         decoration: BoxDecoration(
                      //             color: index == selectedIndexPieChartCategory
                      //                 ? primaryColor
                      //                 : textWhiteColor,
                      //             borderRadius: BorderRadius.circular(20),
                      //             border: index == selectedIndexPieChartCategory
                      //                 ? Border.all(
                      //                     width: 5, color: primaryColor)
                      //                 : Border.all(
                      //                     width: 1, color: primaryColor)),
                      //         child: Text(
                      //           options[index],
                      //           style: index == selectedIndexPieChartCategory
                      //               ? const TextStyle(
                      //                   color: textWhiteColor,
                      //                   fontWeight: FontWeight.bold)
                      //               : const TextStyle(
                      //                   color: primaryColor,
                      //                   fontWeight: FontWeight.normal),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      marginTop30,
                      PieChartSample3(
                        data: reportController.reportPieChartCategory,
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 10,
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 248, 246, 246)),
                ),
                //MÓN
                Container(
                  margin: const EdgeInsets.only(left: 5),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 50,
                        child: ListTile(
                          leading: Icon(
                            Icons.bookmark,
                            color: iconColor,
                          ),
                          title: Text("DOANH THU THEO MÓN",
                              style: textStyleTitleGrayBold20),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: kDefaultPadding / 2),
                        height: 35,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: options.length,
                          itemBuilder: (context, index) => GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndexBarChartFood = index;
                                reportController.getReportBarChartFood(
                                    Utils.getTimeOption(index).startDate,
                                    Utils.getTimeOption(index).endDate);

                                reportController.getReportPieChartFood(
                                    Utils.getTimeOption(index).startDate,
                                    Utils.getTimeOption(index).endDate);
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(
                                left: kDefaultPadding,
                                // At end item it add extra 20 right  padding
                                right: index == options.length - 1
                                    ? kDefaultPadding
                                    : 0,
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: kDefaultPadding),
                              decoration: BoxDecoration(
                                  color: index == selectedIndexBarChartFood
                                      ? primaryColor
                                      : textWhiteColor,
                                  borderRadius: BorderRadius.circular(20),
                                  border: index == selectedIndexBarChartFood
                                      ? Border.all(
                                          width: 5, color: primaryColor)
                                      : Border.all(
                                          width: 1, color: primaryColor)),
                              child: Text(
                                options[index],
                                style: index == selectedIndexBarChartFood
                                    ? const TextStyle(
                                        color: textWhiteColor,
                                        fontWeight: FontWeight.bold)
                                    : const TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                        ),
                      ),
                      marginTop20,
                      BarChartSample7(
                        data: reportController.reportBarChartFood,
                        isShowImage: true,
                      ),
                      marginTop10,
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 5),
                  child: Column(
                    children: [
                      // const SizedBox(
                      //   height: 50,
                      //   child: ListTile(
                      //     leading: Icon(
                      //       Icons.bookmark,
                      //       color: iconColor,
                      //     ),
                      //     title: Text("DOANH THU THEO MÓN",
                      //         style: textStyleTitleGrayBold20),
                      //   ),
                      // ),
                      // Container(
                      //   margin: const EdgeInsets.symmetric(
                      //       vertical: kDefaultPadding / 2),
                      //   height: 35,
                      //   child: ListView.builder(
                      //     scrollDirection: Axis.horizontal,
                      //     itemCount: options.length,
                      //     itemBuilder: (context, index) => GestureDetector(
                      //       onTap: () {
                      //         setState(() {
                      //           selectedIndexPieChartFood = index;
                      //           reportController.getReportPieChartFood(
                      //               Utils.getTimeOption(index).startDate,
                      //               Utils.getTimeOption(index).endDate);
                      //         });
                      //       },
                      //       child: Container(
                      //         alignment: Alignment.center,
                      //         margin: EdgeInsets.only(
                      //           left: kDefaultPadding,
                      //           // At end item it add extra 20 right  padding
                      //           right: index == options.length - 1
                      //               ? kDefaultPadding
                      //               : 0,
                      //         ),
                      //         padding: const EdgeInsets.symmetric(
                      //             horizontal: kDefaultPadding),
                      //         decoration: BoxDecoration(
                      //             color: index == selectedIndexPieChartFood
                      //                 ? primaryColor
                      //                 : textWhiteColor,
                      //             borderRadius: BorderRadius.circular(20),
                      //             border: index == selectedIndexPieChartFood
                      //                 ? Border.all(
                      //                     width: 5, color: primaryColor)
                      //                 : Border.all(
                      //                     width: 1, color: primaryColor)),
                      //         child: Text(
                      //           options[index],
                      //           style: index == selectedIndexPieChartFood
                      //               ? const TextStyle(
                      //                   color: textWhiteColor,
                      //                   fontWeight: FontWeight.bold)
                      //               : const TextStyle(
                      //                   color: primaryColor,
                      //                   fontWeight: FontWeight.normal),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      marginTop30,
                      PieChartSample3(
                        data: reportController.reportPieChartFood,
                      ),
                    ],
                  ),
                ),

                Container(
                  height: 10,
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 248, 246, 246)),
                ),
                //BÀN
                Container(
                  margin: const EdgeInsets.only(left: 5),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 50,
                        child: ListTile(
                          leading: Icon(
                            Icons.bookmark,
                            color: iconColor,
                          ),
                          title: Text("DOANH THU THEO BÀN",
                              style: textStyleTitleGrayBold20),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: kDefaultPadding / 2),
                        height: 35,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: options.length,
                          itemBuilder: (context, index) => GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndexBarChartTable = index;
                                reportController.getReportBarChartTable(
                                    Utils.getTimeOption(index).startDate,
                                    Utils.getTimeOption(index).endDate);

                                reportController.getReportPieChartTable(
                                    Utils.getTimeOption(index).startDate,
                                    Utils.getTimeOption(index).endDate);
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(
                                left: kDefaultPadding,
                                // At end item it add extra 20 right  padding
                                right: index == options.length - 1
                                    ? kDefaultPadding
                                    : 0,
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: kDefaultPadding),
                              decoration: BoxDecoration(
                                  color: index == selectedIndexBarChartTable
                                      ? primaryColor
                                      : textWhiteColor,
                                  borderRadius: BorderRadius.circular(20),
                                  border: index == selectedIndexBarChartTable
                                      ? Border.all(
                                          width: 5, color: primaryColor)
                                      : Border.all(
                                          width: 1, color: primaryColor)),
                              child: Text(
                                options[index],
                                style: index == selectedIndexBarChartTable
                                    ? const TextStyle(
                                        color: textWhiteColor,
                                        fontWeight: FontWeight.bold)
                                    : const TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                        ),
                      ),
                      marginTop10,
                      BarChartSample7(
                        data: reportController.reportBarChartTable,
                        isShowImage: false,
                      ),
                      marginTop10,
                    ],
                  ),
                ),
                Container(
                  height: 10,
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 248, 246, 246)),
                ),
                //EMPLOYEE
                Container(
                  margin: const EdgeInsets.only(left: 5),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 50,
                        child: ListTile(
                          leading: Icon(
                            Icons.bookmark,
                            color: iconColor,
                          ),
                          title: Text("DOANH THU THEO NHÂN VIÊN",
                              style: textStyleTitleGrayBold20),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: kDefaultPadding / 2),
                        height: 35,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: options.length,
                          itemBuilder: (context, index) => GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndexBarChartEmployee = index;
                                reportController.getReportBarChartEmployee(
                                    Utils.getTimeOption(index).startDate,
                                    Utils.getTimeOption(index).endDate); 

                                reportController.getReportPieChartEmployee(
                                    Utils.getTimeOption(index).startDate,
                                    Utils.getTimeOption(index).endDate);
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(
                                left: kDefaultPadding,
                                // At end item it add extra 20 right  padding
                                right: index == options.length - 1
                                    ? kDefaultPadding
                                    : 0,
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: kDefaultPadding),
                              decoration: BoxDecoration(
                                  color: index == selectedIndexBarChartEmployee
                                      ? primaryColor
                                      : textWhiteColor,
                                  borderRadius: BorderRadius.circular(20),
                                  border: index == selectedIndexBarChartEmployee
                                      ? Border.all(
                                          width: 5, color: primaryColor)
                                      : Border.all(
                                          width: 1, color: primaryColor)),
                              child: Text(
                                options[index],
                                style: index == selectedIndexBarChartEmployee
                                    ? const TextStyle(
                                        color: textWhiteColor,
                                        fontWeight: FontWeight.bold)
                                    : const TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                        ),
                      ),
                      marginTop10,
                      BarChartSample7(
                        data: reportController.reportBarChartEmployee,
                        isShowImage: true,
                      ),
                      marginTop10,
                    ],
                  ),
                ),

                Container(
                  margin: const EdgeInsets.only(left: 5),
                  child: Column(
                    children: [
                      // const SizedBox(
                      //   height: 50,
                      //   child: ListTile(
                      //     leading: Icon(
                      //       Icons.bookmark,
                      //       color: iconColor,
                      //     ),
                      //     title: Text("DOANH THU THEO BÀN",
                      //         style: textStyleTitleGrayBold20),
                      //   ),
                      // ),
                      // Container(
                      //   margin: const EdgeInsets.symmetric(
                      //       vertical: kDefaultPadding / 2),
                      //   height: 35,
                      //   child: ListView.builder(
                      //     scrollDirection: Axis.horizontal,
                      //     itemCount: options.length,
                      //     itemBuilder: (context, index) => GestureDetector(
                      //       onTap: () {
                      //         setState(() {
                      //           selectedIndexPieChartTable = index;
                      //           reportController.getReportPieChartTable(
                      //               Utils.getTimeOption(index).startDate,
                      //               Utils.getTimeOption(index).endDate);
                      //         });
                      //       },
                      //       child: Container(
                      //         alignment: Alignment.center,
                      //         margin: EdgeInsets.only(
                      //           left: kDefaultPadding,
                      //           // At end item it add extra 20 right  padding
                      //           right: index == options.length - 1
                      //               ? kDefaultPadding
                      //               : 0,
                      //         ),
                      //         padding: const EdgeInsets.symmetric(
                      //             horizontal: kDefaultPadding),
                      //         decoration: BoxDecoration(
                      //             color: index == selectedIndexPieChartTable
                      //                 ? primaryColor
                      //                 : textWhiteColor,
                      //             borderRadius: BorderRadius.circular(20),
                      //             border: index == selectedIndexPieChartTable
                      //                 ? Border.all(
                      //                     width: 5, color: primaryColor)
                      //                 : Border.all(
                      //                     width: 1, color: primaryColor)),
                      //         child: Text(
                      //           options[index],
                      //           style: index == selectedIndexPieChartTable
                      //               ? const TextStyle(
                      //                   color: textWhiteColor,
                      //                   fontWeight: FontWeight.bold)
                      //               : const TextStyle(
                      //                   color: primaryColor,
                      //                   fontWeight: FontWeight.normal),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      marginTop30,
                      PieChartSample3(
                        data: reportController.reportPieChartEmployee,
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 10,
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 248, 246, 246)),
                ),
                //DOANH THU TỔNG
                Container(
                  margin: const EdgeInsets.only(left: 5),
                  color: backgroundColor,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 50,
                        child: ListTile(
                          leading: Icon(
                            Icons.bookmark,
                            color: iconColor,
                          ),
                          title: Text("DOANH THU TỔNG THEO NGÀY",
                              style: textStyleTitleGrayBold20),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: kDefaultPadding / 2),
                        height: 35,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: options.length,
                          itemBuilder: (context, index) => GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndexBarChart = index;
                                reportController.getReportBarChartAll(
                                    Utils.getTimeOption(index).startDate,
                                    Utils.getTimeOption(index).endDate);

                                reportController.getReportPieChartAll(
                                    Utils.getTimeOption(index).startDate,
                                    Utils.getTimeOption(index).endDate);
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(
                                left: kDefaultPadding,
                                right: index == options.length - 1
                                    ? kDefaultPadding
                                    : 0,
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: kDefaultPadding),
                              decoration: BoxDecoration(
                                  color: index == selectedIndexBarChart
                                      ? primaryColor
                                      : textWhiteColor,
                                  borderRadius: BorderRadius.circular(20),
                                  border: index == selectedIndexBarChart
                                      ? Border.all(
                                          width: 5, color: primaryColor)
                                      : Border.all(
                                          width: 1, color: primaryColor)),
                              child: Text(
                                options[index],
                                style: index == selectedIndexBarChart
                                    ? const TextStyle(
                                        color: textWhiteColor,
                                        fontWeight: FontWeight.bold)
                                    : const TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                        ),
                      ),
                      marginTop20,
                      BarChartSample7(
                        data: reportController.reportBarChart,
                        isShowImage: false,
                      ),
                      // marginTop10,
                      // Container(
                      //   margin: const EdgeInsets.symmetric(
                      //       vertical: kDefaultPadding / 2),
                      //   height: 35,
                      //   child: ListView.builder(
                      //     scrollDirection: Axis.horizontal,
                      //     itemCount: options.length,
                      //     itemBuilder: (context, index) => GestureDetector(
                      //       onTap: () {
                      //         setState(() {
                      //           selectedIndexPieChart = index;
                      //           reportController.getReportPieChartAll(
                      //               Utils.getTimeOption(index).startDate,
                      //               Utils.getTimeOption(index).endDate);
                      //         });
                      //       },
                      //       child: Container(
                      //         alignment: Alignment.center,
                      //         margin: EdgeInsets.only(
                      //           left: kDefaultPadding,
                      //           // At end item it add extra 20 right  padding
                      //           right: index == options.length - 1
                      //               ? kDefaultPadding
                      //               : 0,
                      //         ),
                      //         padding: const EdgeInsets.symmetric(
                      //             horizontal: kDefaultPadding),
                      //         decoration: BoxDecoration(
                      //             color: index == selectedIndexPieChart
                      //                 ? primaryColor
                      //                 : textWhiteColor,
                      //             borderRadius: BorderRadius.circular(20),
                      //             border: index == selectedIndexPieChart
                      //                 ? Border.all(
                      //                     width: 5, color: primaryColor)
                      //                 : Border.all(
                      //                     width: 1, color: primaryColor)),
                      //         child: Text(
                      //           options[index],
                      //           style: index == selectedIndexPieChart
                      //               ? const TextStyle(
                      //                   color: textWhiteColor,
                      //                   fontWeight: FontWeight.bold)
                      //               : const TextStyle(
                      //                   color: primaryColor,
                      //                   fontWeight: FontWeight.normal),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      marginTop30,
                      PieChartSample3(
                        data: reportController.reportPieChartAll,
                      ),
                    ],
                  ),
                ),

                //CHỌN LỊCH BÁO CÁO DOANH THU - CHI PHÍ - LỢI NHUẬN
                Container(
                  // height: 240,
                  margin: const EdgeInsets.all(0),
                  child: const Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.bookmark,
                          color: iconColor,
                        ),
                        title: Text("DOANH THU - CHI PHÍ - LỢI NHUẬN",
                            style: textStyleTitleGrayBold20),
                        subtitle: Text("100,000,000",
                            style: textStyleSubTitlePrimaryRegular20),
                      ),
                      ListTile(
                        title: Text("Doanh thu",
                            style: textStyleTrailingPrimaryRegular16),
                        trailing: Text("999,000,000",
                            style: textStyleTrailingPrimaryRegular16),
                      ),
                      ListTile(
                        title: Text("Chi phí",
                            style: textStyleTrailingCostRegular16),
                        trailing: Text("100,000,000",
                            style: textStyleTrailingCostRegular16),
                      ),
                      ListTile(
                        title: Text("Lợi nhuận",
                            style: textStyleTrailingProfitRegular16),
                        trailing: Text("800,000,000",
                            style: textStyleTrailingProfitRegular16),
                      ),

                      // BarChartSample2(
                      //   data: data,
                      //   maxY: 20,
                      //   title: 'Thống kê số lượng bán',
                      //   bottomTitle: bottomTitles,
                      // ),
                    ],
                  ),
                ),
              ],
            );
          }))),
        ));
  }
}
