// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart'; // Correct import for Firestore

import 'package:get/get.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/models/bill.dart';
import 'package:myorder/models/charts/chart_model.dart';
import 'package:myorder/models/charts/data_chart.dart';
import 'package:myorder/models/food.dart';
import 'package:myorder/models/order_detail.dart';
import 'package:myorder/models/order.dart' as model;
import 'package:myorder/models/report.dart';
import 'package:myorder/models/table.dart' as table;
import 'package:myorder/utils.dart';
import 'package:myorder/views/screens/home/chart/bar_chart_sample7.dart';
import 'package:myorder/views/screens/home/chart/pie_chart_sample3.dart';

class ReportController extends GetxController {
  final Rx<Report> _reportServingOrder = Rx<Report>(Report.empty());
  Report get reportServingOrder => _reportServingOrder.value;

  void getReportServingOrders() {
    Report report = Report.empty();
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
    FirebaseFirestore.instance
        .collection('orders')
        .where("active", isEqualTo: ACTIVE)
        .where('order_status', isEqualTo: ORDER_STATUS_SERVING)
        // .where('create_at', isGreaterThanOrEqualTo: startOfDay)
        // .where('create_at', isLessThanOrEqualTo: endOfDay)
        .snapshots()
        .listen((QuerySnapshot query) {
      final int count = query.size;
      report.quantity = count;

      print("Đơn hàng đang phục vụ hôm nay: $count");
      double totalAmount = 0;
      for (var element in query.docs) {
        model.Order order =
            model.Order.fromSnap(element); // map đơn hàng chi tiết
        totalAmount += order.total_amount;
      }
      report.total_amount = totalAmount;

      _reportServingOrder.value = report;
    });
  }

  final Rx<Report> _reportBills = Rx<Report>(Report.empty());
  Report get reportBills => _reportBills.value;
  void getBills() {
    Report report = Report.empty();

    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
    FirebaseFirestore.instance
        .collection('bills')
        .where('payment_at', isGreaterThanOrEqualTo: startOfDay)
        .where('payment_at', isLessThanOrEqualTo: endOfDay)
        .snapshots()
        .listen((QuerySnapshot query) {
      final int count = query.size;
      report.quantity = count;

      print("Đơn hàng đã thanh toán hôm nay: $count");
      double totalAmount = 0;
      for (var element in query.docs) {
        Bill bill = Bill.fromSnap(element); // map đơn hàng chi tiết
        totalAmount += bill.total_amount;
      }
      report.total_amount = totalAmount;

      _reportBills.value = report;
    });
  }

  //Đơn hàng đã hủy

  final Rx<Report> _reportCancelOrder = Rx<Report>(Report.empty());
  Report get reportCancelOrder => _reportCancelOrder.value;

  void getNumberOfCanceledOrders() {
    Report report = Report.empty();

    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
    FirebaseFirestore.instance
        .collection('orders')
        .where("active", isEqualTo: DEACTIVE)
        .where('order_status', isEqualTo: ORDER_STATUS_CANCEL)
        .where('payment_at', isGreaterThanOrEqualTo: startOfDay)
        .where('payment_at', isLessThanOrEqualTo: endOfDay)
        .snapshots()
        .listen((QuerySnapshot query) {
      final int count = query.size;
      report.quantity = count;

      print("Đơn hàng đã hủy hôm nay: $count");
      double totalAmount = 0;
      for (var element in query.docs) {
        model.Order order =
            model.Order.fromSnap(element); // map đơn hàng chi tiết
        totalAmount += order.total_amount;
      }
      report.total_amount = totalAmount;

      _reportCancelOrder.value = report;
    });
  }

  final Rx<DataChart> _reportFoodSales =
      Rx<DataChart>(DataChart(listDataPieChart: [], listDataBarChart: []));
  DataChart get reportFoodSales => _reportFoodSales.value;

  getReportFoodSales() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
    _reportFoodSales.bindStream(
      firestore
          .collection('orders')
          .where('order_status', isEqualTo: ORDER_STATUS_PAID)
          .where('payment_at', isGreaterThanOrEqualTo: startOfDay)
          .where('payment_at', isLessThanOrEqualTo: endOfDay)
          .snapshots()
          .asyncMap(
        (QuerySnapshot query) async {
          List<BarData> listDataBarChart = [];

          DataChart dataChart =
              DataChart(listDataPieChart: [], listDataBarChart: []);
          List<ChartModel> listChartModel = [];

          var foodCollection = FirebaseFirestore.instance
              .collection('foods')
              .where("active", isEqualTo: ACTIVE);
          //food
          var foodCollectionQuery = await foodCollection.get();
          for (var foodlData in foodCollectionQuery.docs) {
            Food food = Food.fromSnap(foodlData);

            ChartModel chartModelItem = ChartModel(
                id: food.food_id,
                total_amount: 0,
                title: food.name,
                quantity: 0,
                price: 0,
                color: Utils.generateRandomColor());
            listChartModel.add(chartModelItem);
          }

          for (var element in query.docs) {
            String order_id = element["order_id"].toString();

            // model.Order order = model.Order.fromSnap(element);

            var orderDetailCollection = firestore
                .collection('orders')
                .doc(order_id)
                .collection('orderDetails');

            var orderDetailQuery = await orderDetailCollection.get();
            for (var doc in orderDetailQuery.docs) {
              var orderDetail = OrderDetail.fromSnap(doc);
              double barDataTotalAmount = 0;
              for (ChartModel food in listChartModel) {
                if (orderDetail.food_id == food.id) {
                  food.total_amount +=
                      (orderDetail.quantity * orderDetail.price);
                  food.quantity += 1;
                  barDataTotalAmount = food.total_amount;
                }
              }
              BarData barData =
                  BarData(Utils.generateRandomColor(), barDataTotalAmount, 0);
              listDataBarChart.add(barData);
            }
          }
          dataChart.listDataPieChart = [];
          dataChart.listDataBarChart = listDataBarChart;
          return dataChart;
        },
      ),
    );
  }

  final Rx<List<DataItemPieChart>> _reportPieChartFoodSales =
      Rx<List<DataItemPieChart>>([]);
  List<DataItemPieChart> get reportPieChartFoodSales =>
      _reportPieChartFoodSales.value;

  getReportPieChartFoodSales() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
    _reportPieChartFoodSales.bindStream(
      firestore
          .collection('orders')
          .where('order_status', isEqualTo: ORDER_STATUS_PAID)
          .where('payment_at', isGreaterThanOrEqualTo: startOfDay)
          .where('payment_at', isLessThanOrEqualTo: endOfDay)
          .snapshots()
          .asyncMap(
        (QuerySnapshot query) async {
          List<DataItemPieChart> listChartModel = [];

          var foodCollection = FirebaseFirestore.instance
              .collection('foods')
              .where("active", isEqualTo: ACTIVE);
          //food
          var foodCollectionQuery = await foodCollection.get();
          for (var foodlData in foodCollectionQuery.docs) {
            Food food = Food.fromSnap(foodlData);

            DataItemPieChart dataItemPieChart = DataItemPieChart(
                color: Utils.generateRandomColor(),
                value: 0,
                title: food.name,
                icon: food.image ?? "",
                id: food.food_id);
            listChartModel.add(dataItemPieChart);
          }

          for (var element in query.docs) {
            String order_id = element["order_id"].toString();

            // model.Order order = model.Order.fromSnap(element);

            var orderDetailCollection = firestore
                .collection('orders')
                .doc(order_id)
                .collection('orderDetails');

            var orderDetailQuery = await orderDetailCollection.get();
            for (var doc in orderDetailQuery.docs) {
              var orderDetail = OrderDetail.fromSnap(doc);
              for (DataItemPieChart food in listChartModel) {
                if (orderDetail.food_id == food.id) {
                  food.value += 1;
                }
              }
            }
          }

          listChartModel.sort((a, b) => b.value.compareTo(a.value));
          return listChartModel;
        },
      ),
    );
  }
}
