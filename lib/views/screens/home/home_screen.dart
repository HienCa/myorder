// ignore_for_file: library_prefixes

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/bills/bills_controller.dart';
import 'package:myorder/controllers/reports/reports_controller.dart';
import 'package:myorder/models/bill.dart';
import 'package:myorder/models/charts/data_chart.dart';
import 'package:myorder/utils.dart';
import 'package:myorder/views/screens/home/chart/bar_chart_sample2.dart';
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
    reportController.getReportPieChartFoodSales();
    reportController.getReportFoodSales();
    data = convertListToBarChartGroupData(
        reportController.reportFoodSales.myDataBarChart);
    bottomTitles =
        reportController.reportFoodSales.myDataBarChart.bottom_titles;
    // myDataBarChart = reportController.reportFoodSales.myDataBarChart;
  }

  // MyDataBarChart myDataBarChart = MyDataBarChart(
  //     title: "Thống kê", left_titles: [], bottom_titles: [], values: []);
  List<BarChartGroupData> data = [];
  List<String> leftTitles = [];
  List<String> bottomTitles = [];
  List<BarChartGroupData> convertListToBarChartGroupData(MyDataBarChart data) {
    return data.values.asMap().entries.map((entry) {
      final int x = entry.key;
      final double y1 = entry.value;
      final double y2 = y1 * 1.5;

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
                          Utils.getSumTotalAmount(billController.bills)),
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

                //DOANH THU HÔM QUA
                const SizedBox(
                  height: 60,
                  child: ListTile(
                    leading: Icon(
                      Icons.bookmark,
                      color: iconColor,
                    ),
                    title: Text("DOANH THU HÔM QUA",
                        style: textStyleTitleGrayBold20),
                    subtitle:
                        Text("0", style: textStyleSubTitlePrimaryRegular20),
                  ),
                ),

                //line char
                Container(
                  height: 10,
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 248, 246, 246)),
                ),

                //DOANH THU TUẦN NÀY
                const SizedBox(
                  height: 60,
                  child: ListTile(
                    leading: Icon(
                      Icons.bookmark,
                      color: iconColor,
                    ),
                    title: Text("DOANH THU TUẦN NÀY",
                        style: textStyleTitleGrayBold20),
                    subtitle:
                        Text("0", style: textStyleSubTitlePrimaryRegular20),
                  ),
                ),

                //line char
                Container(
                  height: 10,
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 248, 246, 246)),
                ),

                //DOANH THU THÁNG NÀY
                const SizedBox(
                  height: 60,
                  child: ListTile(
                    leading: Icon(
                      Icons.bookmark,
                      color: iconColor,
                    ),
                    title: Text("DOANH THU THÁNG NÀY",
                        style: textStyleTitleGrayBold20),
                    subtitle:
                        Text("0", style: textStyleSubTitlePrimaryRegular20),
                  ),
                ),

                //line char
                Container(
                  height: 10,
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 248, 246, 246)),
                ),

                //DOANH THU 3 THÁNG GẦN NHẤT
                const SizedBox(
                  height: 60,
                  child: ListTile(
                    leading: Icon(
                      Icons.bookmark,
                      color: iconColor,
                    ),
                    title: Text("DOANH THU 3 THÁNG GẦN NHẤT",
                        style: textStyleTitleGrayBold20),
                    subtitle:
                        Text("0", style: textStyleSubTitlePrimaryRegular20),
                  ),
                ),

                //line char
                Container(
                  height: 10,
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 248, 246, 246)),
                ),

                //DOANH THU NĂM NAY
                const SizedBox(
                  height: 60,
                  child: ListTile(
                    leading: Icon(
                      Icons.bookmark,
                      color: iconColor,
                    ),
                    title: Text("DOANH THU NĂM NAY",
                        style: textStyleTitleGrayBold20),
                    subtitle:
                        Text("0", style: textStyleSubTitlePrimaryRegular20),
                  ),
                ),

                //line char
                Container(
                  height: 10,
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 248, 246, 246)),
                ),
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
                      marginTop10,
                      BarChartSample7(
                        data: reportController.reportFoodSales.listDataBarChartFood,
                      ),
                      marginTop10,
                    ],
                  ),
                ),
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
                      marginTop10,
                      BarChartSample7(
                        data: reportController.reportFoodSales.listDataBarChartCategory,
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
                      marginTop30,
                      PieChartSample3(
                        data: reportController.reportPieChartFoodSales,
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
