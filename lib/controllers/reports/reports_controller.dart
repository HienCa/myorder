// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart'; // Correct import for Firestore

import 'package:get/get.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/models/area.dart';
import 'package:myorder/models/bill.dart';
import 'package:myorder/models/category.dart';
import 'package:myorder/models/charts/chart_model.dart';
import 'package:myorder/models/charts/data_chart.dart';
import 'package:myorder/models/food.dart';
import 'package:myorder/models/order_detail.dart';
import 'package:myorder/models/order.dart' as model;
import 'package:myorder/models/report.dart';
import 'package:myorder/models/table.dart';
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

  final Rx<DataChart> _reportFoodSales = Rx<DataChart>(DataChart(
      listDataPieChart: [],
      listDataBarChartFood: [],
      listDataBarChartCategory: [],
      myDataBarChart: MyDataBarChart.empty(),
      listDataBarChartTable: [],
      listDataBarChartArea: []));
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
          List<BarData> listDataBarChartFood = [];
          List<BarData> listDataBarChartCategory = [];
          List<BarData> listDataBarChartTable = [];
          List<BarData> listDataBarChartArea = [];

          DataChart dataChart = DataChart(
              listDataPieChart: [],
              listDataBarChartFood: [],
              listDataBarChartCategory: [],
              myDataBarChart: MyDataBarChart.empty(),
              listDataBarChartTable: [],
              listDataBarChartArea: []);
          List<ChartModel> listChartModelCategory = [];
          List<ChartModel> listChartModelTable = [];
          List<ChartModel> listChartModelArea = [];
          MyDataBarChart myDataBarChart =
              MyDataBarChart.empty(); //bar_chart_sample2

          //category===================
          var categoryCollection = FirebaseFirestore.instance
              .collection('categories')
              .where("active", isEqualTo: ACTIVE);
          var categoryCollectionQuery = await categoryCollection.get();

          for (var categoryData in categoryCollectionQuery.docs) {
            Category category = Category.fromSnap(categoryData);

            ChartModel chartModelItem = ChartModel(
                id: category.category_id,
                total_amount: 0,
                title: category.name,
                quantity: 0,
                price: 0,
                color: Utils.generateRandomColor(),
                image: "");
            listChartModelCategory.add(chartModelItem);
          }
          // TABLE
          var tableCollection = FirebaseFirestore.instance
              .collection('tables')
              .where("active", isEqualTo: ACTIVE);
          var tableCollectionQuery = await tableCollection.get();
          for (var tableData in tableCollectionQuery.docs) {
            Table table = Table.fromSnap(tableData);

            ChartModel chartModelItem = ChartModel(
                id: table.table_id,
                total_amount: 0,
                title: table.name,
                quantity: 0,
                price: 0,
                color: Utils.generateRandomColor(),
                image: "");
            listChartModelTable.add(chartModelItem);
          }

          //AREA
          var areaCollection = FirebaseFirestore.instance
              .collection('areas')
              .where("active", isEqualTo: ACTIVE);
          var areaCollectionQuery = await areaCollection.get();
          for (var areaData in areaCollectionQuery.docs) {
            Area area = Area.fromSnap(areaData);

            ChartModel chartModelItem = ChartModel(
                id: area.area_id,
                total_amount: 0,
                title: area.name,
                quantity: 0,
                price: 0,
                color: Utils.generateRandomColor(),
                image: "");
            listChartModelArea.add(chartModelItem);
          }

          //food===================
          List<ChartModel> listChartModelFood = [];
          var foodCollection = FirebaseFirestore.instance
              .collection('foods')
              .where("active", isEqualTo: ACTIVE);

          var foodCollectionQuery = await foodCollection.get();
          for (var foodlData in foodCollectionQuery.docs) {
            Food food = Food.fromSnap(foodlData);

            ChartModel chartModelItem = ChartModel(
                id: food.food_id,
                total_amount: 0,
                title: food.name,
                quantity: 0,
                price: 0,
                color: Utils.generateRandomColor(),
                image: food.image ?? "");
            listChartModelFood.add(chartModelItem);
          }

          for (var element in query.docs) {
            model.Order order = model.Order.fromSnap(element);

            var orderDetailCollection = firestore
                .collection('orders')
                .doc(order.order_id)
                .collection('orderDetails');

            var orderDetailQuery = await orderDetailCollection.get();

            for (var doc in orderDetailQuery.docs) {
              var orderDetail = OrderDetail.fromSnap(doc);

              // FOOD
              double barDataTotalAmount = 0;
              String foodName = "";
              String foodImage = "";

              for (ChartModel chartModel in listChartModelFood) {
                if (orderDetail.food_id == chartModel.id) {
                  chartModel.total_amount +=
                      (orderDetail.quantity * orderDetail.price);
                  chartModel.quantity += 1;
                  barDataTotalAmount = chartModel.total_amount;
                  foodName = chartModel.title;
                  foodImage = chartModel.image;
                  break;
                }
              }
              BarData barDataFood = BarData(
                Utils.generateRandomColor(),
                barDataTotalAmount,
                0,
                foodImage,
                foodName,
                orderDetail.food_id,
              );
              listDataBarChartFood.add(barDataFood);
              myDataBarChart.bottom_titles.add(foodName);
              myDataBarChart.values.add(barDataTotalAmount);

              // CATEGORY
              double barDataTotalAmountOfCategory = 0;
              String categoryName = "";
              // int totalQuantity = 0;

              for (ChartModel chartModel in listChartModelCategory) {
                if (orderDetail.category_id.toString() == chartModel.id) {
                  chartModel.total_amount +=
                      (orderDetail.quantity * orderDetail.price);
                  chartModel.quantity += 1;
                  // totalQuantity += orderDetail.quantity;
                  barDataTotalAmountOfCategory = chartModel.total_amount;
                  categoryName = chartModel.title;
                  break;
                }
              }

              // kiểm tra đã thêm chưa, nếu rồi thì cấp nhật tổng tiền
              bool isCategoryAdded = false;
              for (BarData item in listDataBarChartCategory) {
                if (item.id == orderDetail.category_id) {
                  isCategoryAdded = true;
                  item.value += (orderDetail.quantity * orderDetail.price);
                }
              }
              // chưa add
              if (!isCategoryAdded) {
                BarData barDataCategory = BarData(
                  Utils.generateRandomColor(),
                  barDataTotalAmountOfCategory,
                  0,
                  "",
                  categoryName,
                  orderDetail.category_id,
                );
                listDataBarChartCategory.add(barDataCategory);
              }
              // END CATERORY================================================

              // START TABLE================================================

              double barDataTotalAmountOfTable = 0;
              String tableName = "";
              // int totalQuantity = 0;
              for (ChartModel chartModel in listChartModelTable) {
                if (chartModel.id == order.table_id) {
                  chartModel.total_amount +=
                      (orderDetail.quantity * orderDetail.price);
                  chartModel.quantity += 1;
                  // totalQuantity += orderDetail.quantity;
                  barDataTotalAmountOfTable = chartModel.total_amount;
                  tableName = chartModel.title;
                  break;
                }
              }
              bool isTableAdded = false;
              for (BarData item in listDataBarChartTable) {
                if (item.id == order.table_id) {
                  isTableAdded = true;
                  item.value += (orderDetail.quantity * orderDetail.price);
                }
              }
              // chưa add
              if (!isTableAdded) {
                BarData barData = BarData(
                  Utils.generateRandomColor(),
                  barDataTotalAmountOfTable,
                  0,
                  "",
                  tableName,
                  order.table_id,
                );
                listDataBarChartTable.add(barData);
              }
              // END TABLE================================================

              // for (BarData barData in listDataBarChartTable) {
              //   if (order.table_id == barData.id) {
              //     barData.value += (orderDetail.quantity * orderDetail.price);
              //   }
              //   // kiểm tra đã thêm chưa, nếu rồi thì cấp nhật tổng tiền
              //   bool isTableAdded = false;
              //   for (BarData item in listDataBarChartArea) {
              //     if (item.id == order.table_id) {
              //       isTableAdded = true;
              //       item.value += (orderDetail.quantity * orderDetail.price);
              //     }
              //   }
              //   // chưa add
              //   if (!isTableAdded) {
              //     BarData barDataTable = BarData(
              //       Utils.generateRandomColor(),
              //       barDataTotalAmountOfCategory,
              //       0,
              //       "",
              //       categoryName,
              //       orderDetail.category_id,
              //     );
              //     listDataBarChartTable.add(barDataTable);
              //   }
              // }
              // for (BarData barData in listDataBarChartArea) {
              //   if (order.table_id != "") {
              //     var areaCollection = await firestore
              //         .collection("tables")
              //         .where("table_id", isEqualTo: order.table_id)
              //         .get();
              //     Area areaData = Area.fromSnap(areaCollection.docs.first);

              //     if (areaData.area_id != barData.id) {
              //       barData.value += (orderDetail.quantity * orderDetail.price);
              //     }
              //     break;
              //   }

              // }
            }
          }
          dataChart.listDataPieChart = [];
          dataChart.listDataBarChartFood = listDataBarChartFood;
          dataChart.listDataBarChartCategory = listDataBarChartCategory;
          dataChart.listDataBarChartTable = listDataBarChartTable;
          dataChart.listDataBarChartArea = listDataBarChartArea;
          dataChart.myDataBarChart = myDataBarChart;
          myDataBarChart.title = "Thống kê số lượng bán";
          return dataChart;
        },
      ),
    );
  }

  //===========================================================================
  //===========================================================================
  //===========================================================================
  //BAR CHART
  //CATEGORY
  final Rx<List<BarData>> _reportBarChartCategory = Rx<List<BarData>>([]);
  List<BarData> get reportBarChartCategory => _reportBarChartCategory.value;

  getReportBarChartCategory(DateTime startOfDay, DateTime endOfDay) async {
    _reportBarChartCategory.bindStream(
      firestore
          .collection('orders')
          .where('order_status', isEqualTo: ORDER_STATUS_PAID)
          .where('payment_at', isGreaterThanOrEqualTo: startOfDay)
          .where('payment_at', isLessThanOrEqualTo: endOfDay)
          .snapshots()
          .asyncMap(
        (QuerySnapshot query) async {
          List<BarData> listDataBarChartCategory = [];

          List<ChartModel> listChartModelCategory = [];
          var foodCollection = FirebaseFirestore.instance
              .collection('categories')
              .where("active", isEqualTo: ACTIVE);

          var categoryCollectionQuery = await foodCollection.get();
          for (var categoryData in categoryCollectionQuery.docs) {
            Category category = Category.fromSnap(categoryData);

            ChartModel chartModelItem = ChartModel(
                id: category.category_id,
                total_amount: 0,
                title: category.name,
                quantity: 0,
                price: 0,
                color: Utils.generateRandomColor(),
                image: "");
            listChartModelCategory.add(chartModelItem);
          }

          for (var element in query.docs) {
            model.Order order = model.Order.fromSnap(element);

            var orderDetailCollection = firestore
                .collection('orders')
                .doc(order.order_id)
                .collection('orderDetails');

            var orderDetailQuery = await orderDetailCollection.get();

            for (var doc in orderDetailQuery.docs) {
              var orderDetail = OrderDetail.fromSnap(doc);

              double barDataTotalAmount = 0;
              String name = "";
              // int totalQuantity = 0;

              for (ChartModel chartModel in listChartModelCategory) {
                if (orderDetail.category_id == chartModel.id) {
                  chartModel.total_amount +=
                      (orderDetail.quantity * orderDetail.price);
                  chartModel.quantity += 1;
                  // totalQuantity += orderDetail.quantity;
                  barDataTotalAmount = chartModel.total_amount;
                  name = chartModel.title;
                  break;
                }
              }

              // kiểm tra đã thêm chưa, nếu rồi thì cấp nhật tổng tiền
              bool isAdded = false;
              for (BarData item in listDataBarChartCategory) {
                if (item.id == orderDetail.category_id) {
                  isAdded = true;
                  item.value += (orderDetail.quantity * orderDetail.price);
                }
              }
              // chưa add
              if (!isAdded) {
                BarData barDataCategory = BarData(
                  Utils.generateRandomColor(),
                  barDataTotalAmount,
                  0,
                  "",
                  name,
                  orderDetail.category_id,
                );
                listDataBarChartCategory.add(barDataCategory);
              }
            }
          }

          return listDataBarChartCategory;
        },
      ),
    );
  }

  //==FOOD
  final Rx<List<BarData>> _reportBarChartFood = Rx<List<BarData>>([]);
  List<BarData> get reportBarChartFood => _reportBarChartFood.value;

  getReportBarChartFood(DateTime startOfDay, DateTime endOfDay) async {
    _reportBarChartFood.bindStream(
      firestore
          .collection('orders')
          .where('order_status', isEqualTo: ORDER_STATUS_PAID)
          .where('payment_at', isGreaterThanOrEqualTo: startOfDay)
          .where('payment_at', isLessThanOrEqualTo: endOfDay)
          .snapshots()
          .asyncMap(
        (QuerySnapshot query) async {
          List<BarData> listDataBarChartFood = [];

          //food===================
          List<ChartModel> listChartModelFood = [];
          var foodCollection = FirebaseFirestore.instance
              .collection('foods')
              .where("active", isEqualTo: ACTIVE);

          var foodCollectionQuery = await foodCollection.get();
          for (var foodlData in foodCollectionQuery.docs) {
            Food food = Food.fromSnap(foodlData);

            ChartModel chartModelItem = ChartModel(
                id: food.food_id,
                total_amount: 0,
                title: food.name,
                quantity: 0,
                price: 0,
                color: Utils.generateRandomColor(),
                image: food.image ?? "");
            listChartModelFood.add(chartModelItem);
          }

          for (var element in query.docs) {
            model.Order order = model.Order.fromSnap(element);

            var orderDetailCollection = firestore
                .collection('orders')
                .doc(order.order_id)
                .collection('orderDetails');

            var orderDetailQuery = await orderDetailCollection.get();

            for (var doc in orderDetailQuery.docs) {
              var orderDetail = OrderDetail.fromSnap(doc);

              double barDataTotalAmount = 0;
              String name = "";
              String image = "";
              // int totalQuantity = 0;

              for (ChartModel chartModel in listChartModelFood) {
                if (orderDetail.food_id == chartModel.id) {
                  chartModel.total_amount +=
                      (orderDetail.quantity * orderDetail.price);
                  chartModel.quantity += 1;
                  // totalQuantity += orderDetail.quantity;
                  barDataTotalAmount = chartModel.total_amount;
                  name = chartModel.title;
                  image = chartModel.image;
                  break;
                }
              }

              // kiểm tra đã thêm chưa, nếu rồi thì cấp nhật tổng tiền
              bool isAdded = false;
              for (BarData item in listDataBarChartFood) {
                if (item.id == orderDetail.food_id) {
                  isAdded = true;
                  item.value += (orderDetail.quantity * orderDetail.price);
                }
              }
              // chưa add
              if (!isAdded) {
                BarData barDataCategory = BarData(
                  Utils.generateRandomColor(),
                  barDataTotalAmount,
                  0,
                  image,
                  name,
                  orderDetail.food_id,
                );
                listDataBarChartFood.add(barDataCategory);
              }
            }
          }

          return listDataBarChartFood;
        },
      ),
    );
  }

  //TABLE
  final Rx<List<BarData>> _reportBarChartTable = Rx<List<BarData>>([]);
  List<BarData> get reportBarChartTable => _reportBarChartTable.value;

  getReportBarChartTable(DateTime startOfDay, DateTime endOfDay) async {
    // final now = DateTime.now();
    // final startOfDay = DateTime(now.year, now.month, now.day);
    // final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
    _reportBarChartTable.bindStream(
      firestore
          .collection('orders')
          .where('order_status', isEqualTo: ORDER_STATUS_PAID)
          .where('payment_at', isGreaterThanOrEqualTo: startOfDay)
          .where('payment_at', isLessThanOrEqualTo: endOfDay)
          .snapshots()
          .asyncMap(
        (QuerySnapshot query) async {
          List<ChartModel> listChartModelTable = [];
          List<BarData> listDataBarChartTable = [];

          // TABLE
          var tableCollection = FirebaseFirestore.instance
              .collection('tables')
              .where("active", isEqualTo: ACTIVE);
          var tableCollectionQuery = await tableCollection.get();
          for (var tableData in tableCollectionQuery.docs) {
            Table table = Table.fromSnap(tableData);

            ChartModel chartModelItem = ChartModel(
                id: table.table_id,
                total_amount: 0,
                title: table.name,
                quantity: 0,
                price: 0,
                color: Utils.generateRandomColor(),
                image: "");
            listChartModelTable.add(chartModelItem);
          }

          for (var element in query.docs) {
            model.Order order = model.Order.fromSnap(element);

            var orderDetailCollection = firestore
                .collection('orders')
                .doc(order.order_id)
                .collection('orderDetails');

            var orderDetailQuery = await orderDetailCollection.get();

            for (var doc in orderDetailQuery.docs) {
              var orderDetail = OrderDetail.fromSnap(doc);

              // START TABLE================================================

              double barDataTotalAmountOfTable = 0;
              String tableName = "";
              // int totalQuantity = 0;
              for (ChartModel chartModel in listChartModelTable) {
                if (chartModel.id == order.table_id) {
                  chartModel.total_amount +=
                      (orderDetail.quantity * orderDetail.price);
                  chartModel.quantity += 1;
                  // totalQuantity += orderDetail.quantity;
                  barDataTotalAmountOfTable = chartModel.total_amount;
                  tableName = chartModel.title;
                  break;
                }
              }
              bool isTableAdded = false;
              for (BarData item in listDataBarChartTable) {
                if (item.id == order.table_id) {
                  isTableAdded = true;
                  item.value += (orderDetail.quantity * orderDetail.price);
                }
              }
              // chưa add
              if (!isTableAdded) {
                BarData barData = BarData(
                  Utils.generateRandomColor(),
                  barDataTotalAmountOfTable,
                  0,
                  "",
                  tableName,
                  order.table_id,
                );
                listDataBarChartTable.add(barData);
              }
            }
          }
          return listDataBarChartTable;
        },
      ),
    );
  }

  // //AREA
  // final Rx<List<BarData>> _reportBarChartArea = Rx<List<BarData>>([]);
  // List<BarData> get reportBarChartArea => _reportBarChartArea.value;

  // getReportBarChartArea(DateTime startOfDay, DateTime endOfDay) async {
  //   // final now = DateTime.now();
  //   // final startOfDay = DateTime(now.year, now.month, now.day);
  //   // final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
  //   _reportBarChartTable.bindStream(
  //     firestore
  //         .collection('orders')
  //         .where('order_status', isEqualTo: ORDER_STATUS_PAID)
  //         .where('payment_at', isGreaterThanOrEqualTo: startOfDay)
  //         .where('payment_at', isLessThanOrEqualTo: endOfDay)
  //         .snapshots()
  //         .asyncMap(
  //       (QuerySnapshot query) async {
  //         List<ChartModel> listChartModelTable = [];
  //         List<BarData> listDataBarChartTable = [];

  //         // TABLE
  //         var areaCollection = FirebaseFirestore.instance
  //             .collection('areas')
  //             .where("active", isEqualTo: ACTIVE);
  //         var areaCollectionQuery = await areaCollection.get();
  //         for (var areaData in areaCollectionQuery.docs) {
  //           Area area = Area.fromSnap(areaData);

  //           ChartModel chartModelItem = ChartModel(
  //               id: area.area_id,
  //               total_amount: 0,
  //               title: area.name,
  //               quantity: 0,
  //               price: 0,
  //               color: Utils.generateRandomColor(),
  //               image: "");
  //           listChartModelTable.add(chartModelItem);
  //         }

  //         for (var element in query.docs) {
  //           model.Order order = model.Order.fromSnap(element);

  //           var orderDetailCollection = firestore
  //               .collection('orders')
  //               .doc(order.order_id)
  //               .collection('orderDetails');

  //           var orderDetailQuery = await orderDetailCollection.get();

  //           for (var doc in orderDetailQuery.docs) {
  //             var orderDetail = OrderDetail.fromSnap(doc);

  //             double barDataTotalAmountOfTable = 0;
  //             String name = "";
  //             String areaId = "";
  //             // int totalQuantity = 0;
  //             for (ChartModel chartModel in listChartModelTable) {
  //               if (chartModel.id == order.table_id) {
  //                 chartModel.total_amount +=
  //                     (orderDetail.quantity * orderDetail.price);
  //                 chartModel.quantity += 1;
  //                 // totalQuantity += orderDetail.quantity;
  //                 barDataTotalAmountOfTable = chartModel.total_amount;
  //                 name = chartModel.title;
  //                 areaId = chartModel.id;
  //                 break;
  //               }
  //             }
  //             bool isAdded = false;
  //             for (BarData item in listDataBarChartTable) {
  //               if (item.id == order.table_id) {
  //                 isAdded = true;
  //                 item.value += (orderDetail.quantity * orderDetail.price);
  //               }
  //             }
  //             // chưa add
  //             if (!isAdded) {
  //               BarData barData = BarData(
  //                 Utils.generateRandomColor(),
  //                 barDataTotalAmountOfTable,
  //                 0,
  //                 "",
  //                 name,
  //                 areaId,
  //               );
  //               listDataBarChartTable.add(barData);
  //             }
  //           }
  //         }
  //         return listDataBarChartTable;
  //       },
  //     ),
  //   );
  // }

  //===========================================================================
  //===========================================================================
  //===========================================================================
  //PIE CHART

  //TỔNG
  final Rx<DataPieChart> _reportPieChartFoodSales = Rx<DataPieChart>(
    DataPieChart(
      listDataPieChartCategory: [],
      listDataBarChartFood: [],
      listDataBarChartTable: [],
      listDataBarChartArea: [],
    ),
  );

  DataPieChart get reportPieChartFoodSales => _reportPieChartFoodSales.value;

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
          DataPieChart listPieChartModel = DataPieChart(
            listDataPieChartCategory: [],
            listDataBarChartFood: [],
            listDataBarChartTable: [],
            listDataBarChartArea: [],
          );

          // CATEGORY
          var categoryCollection = FirebaseFirestore.instance
              .collection('categories')
              .where("active", isEqualTo: ACTIVE);
          var categoryCollectionQuery = await categoryCollection.get();
          for (var categoryData in categoryCollectionQuery.docs) {
            Category category = Category.fromSnap(categoryData);

            DataItemPieChart dataItemPieChart = DataItemPieChart(
              color: Utils.generateRandomColor(),
              value: 0,
              title: category.name,
              icon: "",
              id: category.category_id,
            );
            listPieChartModel.listDataPieChartCategory.add(dataItemPieChart);
          }

          for (var element in query.docs) {
            model.Order order = model.Order.fromSnap(element);
            var orderDetailCollection = firestore
                .collection('orders')
                .doc(order.order_id)
                .collection('orderDetails');

            var orderDetailQuery = await orderDetailCollection.get();
            for (var doc in orderDetailQuery.docs) {
              var orderDetail = OrderDetail.fromSnap(doc);
              for (DataItemPieChart category
                  in listPieChartModel.listDataPieChartCategory) {
                if (orderDetail.category_id == category.id) {
                  // số lượng món thuộc danh mục
                  category.value += orderDetail.quantity;
                }
              }
            }
          }
          // Sắp xếp giảm dần
          listPieChartModel.listDataPieChartCategory
              .sort((a, b) => b.value.compareTo(a.value));
          listPieChartModel.listDataBarChartTable
              .sort((a, b) => b.value.compareTo(a.value));
          listPieChartModel.listDataBarChartArea
              .sort((a, b) => b.value.compareTo(a.value));

          return listPieChartModel;
        },
      ),
    );
  }

  final Rx<List<DataItemPieChart>> _reportPieChartAll =
      Rx<List<DataItemPieChart>>([]);

  List<DataItemPieChart> get reportPieChartAll => _reportPieChartAll.value;

  getReportPieChartAll(DateTime startOfDay, DateTime endOfDay) async {
    _reportPieChartAll.bindStream(
      firestore
          .collection('orders')
          .where('order_status', isEqualTo: ORDER_STATUS_PAID)
          // .where('payment_at', isGreaterThanOrEqualTo: startOfDay)
          // .where('payment_at', isLessThanOrEqualTo: endOfDay)
          .snapshots()
          .asyncMap(
        (QuerySnapshot query) async {
          List<DataItemPieChart> listDataPieChartCategory = [];

          Map<DateTime, double> dailyTotal = {};

          for (var element in query.docs) {
            model.Order order = model.Order.fromSnap(element);
            DateTime datetime = order.create_at.toDate();
            datetime = DateTime(
              datetime.year,
              datetime.month,
              datetime.day,
              0,
              0,
              0,
              0,
            );

            // var orderDetailCollection = firestore
            //     .collection('orders')
            //     .doc(order.order_id)
            //     .collection('orderDetails');
            // var orderDetailQuery = await orderDetailCollection.get();
            double total = 0;
            // for (var doc in orderDetailQuery.docs) {
            //   var orderDetail = OrderDetail.fromSnap(doc);

            //   if (orderDetail.food_status == FOOD_STATUS_FINISH) {
            //     total += (orderDetail.quantity * orderDetail.price);
            //     print(order.order_id);
            //     print(total);
            // print("ggggggg");

            //   }
            // }

            // total =
            //     total + order.total_vat_amount - order.total_discount_amount;
            total = order.total_amount;
            print(total);
            print("yyyyyy");

            // print(order.total_vat_amount);
            // print(order.total_discount_amount);

            if (dailyTotal.containsKey(datetime)) {
              dailyTotal[datetime] = dailyTotal[datetime]! + total;
            } else {
              dailyTotal[datetime] = total;

              DataItemPieChart dataItemPieChart = DataItemPieChart(
                color: Utils.generateRandomColor(),
                value: total,
                title: Utils.formatDateTime(order.payment_at?.toDate()),
                icon: "",
                id: "",
              );
              listDataPieChartCategory.add(dataItemPieChart);
            }
          }
          listDataPieChartCategory.sort((a, b) => b.value.compareTo(a.value));

          return listDataPieChartCategory;
        },
      ),
    );
  }

  //CATEGORY
  final Rx<List<DataItemPieChart>> _reportPieChartCategory =
      Rx<List<DataItemPieChart>>([]);

  List<DataItemPieChart> get reportPieChartCategory =>
      _reportPieChartCategory.value;

  getReportPieChartCategory(DateTime startOfDay, DateTime endOfDay) async {
    _reportPieChartCategory.bindStream(
      firestore
          .collection('orders')
          .where('order_status', isEqualTo: ORDER_STATUS_PAID)
          .where('payment_at', isGreaterThanOrEqualTo: startOfDay)
          .where('payment_at', isLessThanOrEqualTo: endOfDay)
          .snapshots()
          .asyncMap(
        (QuerySnapshot query) async {
          List<DataItemPieChart> listDataPieChartCategory = [];
          // CATEGORY
          var categoryCollection = FirebaseFirestore.instance
              .collection('categories')
              .where("active", isEqualTo: ACTIVE);
          var categoryCollectionQuery = await categoryCollection.get();
          for (var categoryData in categoryCollectionQuery.docs) {
            Category category = Category.fromSnap(categoryData);

            DataItemPieChart dataItemPieChart = DataItemPieChart(
              color: Utils.generateRandomColor(),
              value: 0,
              title: category.name,
              icon: "",
              id: category.category_id,
            );
            listDataPieChartCategory.add(dataItemPieChart);
          }

          for (var element in query.docs) {
            model.Order order = model.Order.fromSnap(element);
            var orderDetailCollection = firestore
                .collection('orders')
                .doc(order.order_id)
                .collection('orderDetails');

            var orderDetailQuery = await orderDetailCollection.get();
            for (var doc in orderDetailQuery.docs) {
              var orderDetail = OrderDetail.fromSnap(doc);
              double totalAmount = 0;
              String name = "";

              for (DataItemPieChart chartModel in listDataPieChartCategory) {
                if (orderDetail.category_id == chartModel.id) {
                  chartModel.value +=
                      (orderDetail.quantity * orderDetail.price);
                  totalAmount = chartModel.value;
                  name = chartModel.title;
                  break;
                }
              }

              // kiểm tra đã thêm chưa, nếu rồi thì cấp nhật tổng tiền
              bool isAdded = false;
              for (DataItemPieChart item in listDataPieChartCategory) {
                if (item.id == orderDetail.category_id) {
                  isAdded = true;
                  item.value += (orderDetail.quantity * orderDetail.price);
                }
              }
              // chưa add
              if (!isAdded) {
                DataItemPieChart barDataCategory = DataItemPieChart(
                    color: Utils.generateRandomColor(),
                    value: totalAmount,
                    title: name,
                    id: orderDetail.category_id,
                    icon: "");
                listDataPieChartCategory.add(barDataCategory);
              }
            }
          }
          listDataPieChartCategory.sort((a, b) => b.value.compareTo(a.value));

          return listDataPieChartCategory;
        },
      ),
    );
  }

  //FOOD
  final Rx<List<DataItemPieChart>> _reportPieChartFood =
      Rx<List<DataItemPieChart>>([]);

  List<DataItemPieChart> get reportPieChartFood => _reportPieChartFood.value;

  getReportPieChartFood(DateTime startOfDay, DateTime endOfDay) async {
    _reportPieChartFood.bindStream(
      firestore
          .collection('orders')
          .where('order_status', isEqualTo: ORDER_STATUS_PAID)
          .where('payment_at', isGreaterThanOrEqualTo: startOfDay)
          .where('payment_at', isLessThanOrEqualTo: endOfDay)
          .snapshots()
          .asyncMap(
        (QuerySnapshot query) async {
          List<DataItemPieChart> listDataPieChart = [];
          var collection = FirebaseFirestore.instance
              .collection('foods')
              .where("active", isEqualTo: ACTIVE);
          var collectionQuery = await collection.get();
          for (var data in collectionQuery.docs) {
            Food food = Food.fromSnap(data);

            DataItemPieChart dataItemPieChart = DataItemPieChart(
              color: Utils.generateRandomColor(),
              value: 0,
              title: food.name,
              icon: food.image ?? "",
              id: food.food_id,
            );
            listDataPieChart.add(dataItemPieChart);
          }

          for (var element in query.docs) {
            model.Order order = model.Order.fromSnap(element);
            var orderDetailCollection = firestore
                .collection('orders')
                .doc(order.order_id)
                .collection('orderDetails');

            var orderDetailQuery = await orderDetailCollection.get();
            for (var doc in orderDetailQuery.docs) {
              var orderDetail = OrderDetail.fromSnap(doc);
              double totalAmount = 0;
              String name = "";
              String image = "";

              for (DataItemPieChart chartModel in listDataPieChart) {
                if (orderDetail.food_id == chartModel.id) {
                  chartModel.value +=
                      (orderDetail.quantity * orderDetail.price);
                  totalAmount = chartModel.value;
                  name = chartModel.title;
                  image = chartModel.icon;
                  break;
                }
              }

              // kiểm tra đã thêm chưa, nếu rồi thì cấp nhật tổng tiền
              bool isAdded = false;
              for (DataItemPieChart item in listDataPieChart) {
                if (item.id == orderDetail.food_id) {
                  isAdded = true;
                  item.value += (orderDetail.quantity * orderDetail.price);
                }
              }
              // chưa add
              if (!isAdded) {
                DataItemPieChart barData = DataItemPieChart(
                    color: Utils.generateRandomColor(),
                    value: totalAmount,
                    title: name,
                    id: orderDetail.food_id,
                    icon: image);
                listDataPieChart.add(barData);
              }
            }
          }
          listDataPieChart.sort((a, b) => b.value.compareTo(a.value));

          return listDataPieChart;
        },
      ),
    );
  }

  //TABLE
  final Rx<List<DataItemPieChart>> _reportPieChartTable =
      Rx<List<DataItemPieChart>>([]);

  List<DataItemPieChart> get reportPieChartTable => _reportPieChartTable.value;

  getReportPieChartTable(DateTime startOfDay, DateTime endOfDay) async {
    _reportPieChartTable.bindStream(
      firestore
          .collection('orders')
          .where('order_status', isEqualTo: ORDER_STATUS_PAID)
          .where('payment_at', isGreaterThanOrEqualTo: startOfDay)
          .where('payment_at', isLessThanOrEqualTo: endOfDay)
          .snapshots()
          .asyncMap(
        (QuerySnapshot query) async {
          List<DataItemPieChart> listDataPieChart = [];
          var collection = FirebaseFirestore.instance
              .collection('tables')
              .where("active", isEqualTo: ACTIVE);
          var collectionQuery = await collection.get();
          for (var data in collectionQuery.docs) {
            Table table = Table.fromSnap(data);

            DataItemPieChart dataItemPieChart = DataItemPieChart(
              color: Utils.generateRandomColor(),
              value: 0,
              title: "BÀN ${table.name}",
              icon: "",
              id: table.table_id,
            );
            listDataPieChart.add(dataItemPieChart);
          }

          for (var element in query.docs) {
            model.Order order = model.Order.fromSnap(element);
            var orderDetailCollection = firestore
                .collection('orders')
                .doc(order.order_id)
                .collection('orderDetails');

            var orderDetailQuery = await orderDetailCollection.get();
            for (var doc in orderDetailQuery.docs) {
              var orderDetail = OrderDetail.fromSnap(doc);
              double totalAmount = 0;
              String name = "";
              String image = "";

              for (DataItemPieChart chartModel in listDataPieChart) {
                if (order.table_id == chartModel.id) {
                  chartModel.value +=
                      (orderDetail.quantity * orderDetail.price);
                  totalAmount = chartModel.value;
                  name = chartModel.title;
                  image = chartModel.icon;
                  break;
                }
              }

              // kiểm tra đã thêm chưa, nếu rồi thì cấp nhật tổng tiền
              bool isAdded = false;
              for (DataItemPieChart item in listDataPieChart) {
                if (item.id == order.table_id) {
                  isAdded = true;
                  item.value += (orderDetail.quantity * orderDetail.price);
                }
              }
              // chưa add
              if (!isAdded) {
                DataItemPieChart barData = DataItemPieChart(
                    color: Utils.generateRandomColor(),
                    value: totalAmount,
                    title: "BÀN $name",
                    id: order.table_id,
                    icon: image);
                listDataPieChart.add(barData);
              }
            }
          }
          listDataPieChart.sort((a, b) => b.value.compareTo(a.value));

          return listDataPieChart;
        },
      ),
    );
  }
}
