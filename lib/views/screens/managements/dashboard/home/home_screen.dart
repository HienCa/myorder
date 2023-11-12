// ignore_for_file: constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/constants/app_constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myorder/controllers/orders/orders_controller.dart';
import 'package:myorder/utils.dart';
import 'package:myorder/views/screens/area/dialogs/dialog_confirm_table_booking.dart';
import 'package:myorder/views/screens/managements/dashboard/home/dialogs/dialog_order_detail.dart';
import 'package:myorder/views/widgets/dialogs.dart';
import 'package:responsive_grid/responsive_grid.dart';

enum DashBoardHome { Serving, Booking, Finish }

class DashboardHome extends StatefulWidget {
  const DashboardHome({super.key});

  @override
  State<DashboardHome> createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome> {
  final TextEditingController slotTextEditingController =
      TextEditingController();
  OrderController orderController = Get.put(OrderController());
  var keySearch = "";
  String employeeIdSelected = defaultEmployee;
  @override
  void initState() {
    super.initState();
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    //Set up tab bar
    isServing = true;
    isBooking = false;
    isFinish = false;

    //Lấy đơn hàng
    orderController.getOrders(defaultEmployee, keySearch);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 50,
            color: backgroundColor,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                height: 50,
                width: 750,
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
                              "ĐANG PHỤC VỤ",
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
                          width: 70,
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
                          width: 70,
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
                  Container(
                    height: 40,
                    width: 250,
                    padding: const EdgeInsets.only(
                      left: 8,
                    ),
                    margin: const EdgeInsets.only(right: 8, left: 8),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.4),
                        borderRadius: borderRadiusTextField30,
                        border:
                            Border.all(width: 1, color: borderColorPrimary)),
                    child: TextField(
                      onChanged: (value) {
                        orderController.getOrders(employeeIdSelected, value);
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
                  const Spacer(),
                  Container(
                    height: 40,
                    padding: const EdgeInsets.only(left: 4, right: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FaIcon(FontAwesomeIcons.sackDollar,
                                color: iconColor, size: 16),
                            marginRight10,
                            Text("DOANH THU TẠM TÍNH",
                                style: textStyleTabLandscapeLabel),
                          ],
                        ),
                        Obx(() {
                          return Text(
                              Utils.formatCurrency(Utils.getSumTotalAmount(
                                  orderController.orders)),
                              style: textStylePriceBold16);
                        })
                      ],
                    ),
                  )
                ]),
              ),
            ),
          ),
          Obx(() {
            return Expanded(
              child: ResponsiveGridList(
                desiredItemWidth: 200,
                minSpacing: 10,
                children: List.generate(
                    orderController.orders.length, (index) => index).map((i) {
                  DateTime createTime = orderController.orders[i].create_at
                      .toDate(); // Điền vào thời gian tạo đơn hàng từ Firebase
                  DateTime now = DateTime.now();

                  Duration timeDifference = now.difference(createTime);

                  String formattedTime = DateFormat('HH:mm').format(DateTime(
                      0,
                      0,
                      timeDifference.inDays,
                      timeDifference.inHours % 24,
                      timeDifference.inMinutes % 60,
                      timeDifference.inSeconds % 60));
                  return Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      margin: const EdgeInsets.only(top: 10),
                      height: 205,
                      child: Column(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              color: primaryColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                            ),
                            height: 30,
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      marginRight10,
                                      const FaIcon(FontAwesomeIcons.clock,
                                          color: secondColor, size: 16),
                                      marginRight5,
                                      Text(
                                        formattedTime, // thời gian khách đã ăn
                                        style: textStyleWhiteBold16,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        Utils.formatCurrency(orderController
                                            .orders[i].total_amount),
                                        style: textStyleWhiteBold20,
                                      ),
                                      marginRight10,
                                    ],
                                  ),
                                ]),
                          ),
                          marginTop5,
                          InkWell(
                            onTap: () => {
                              showCustomAlertDialogConfirmOrder(
                                  context,
                                  "SỐ LƯỢNG KHÁCH ${orderController.orders[i].table!.name}",
                                  "",
                                  colorInformation,
                                  slotTextEditingController, //số khách muốn đặt
                                  orderController.orders[i].table!
                                      .total_slot, // số lượng khách tối đa có thể tiếp của 1 bàn
                                  () async {
                                // order theo table_id
                                print(
                                    "SỐ KHÁCH MỚI CỦA ĐƠN HÀNG NÀY: ${slotTextEditingController.text}");
                                if (int.tryParse(
                                            slotTextEditingController.text)! >
                                        1 &&
                                    int.tryParse(
                                            slotTextEditingController.text)! <=
                                        orderController
                                            .orders[i].table!.total_slot) {
                                  //Nếu là đơn hàng mới thì phải nhập số khách
                                  orderController.updateSlot(
                                      orderController.orders[i],
                                      int.tryParse(
                                              slotTextEditingController.text) ??
                                          orderController.orders[i].total_slot,
                                      context);
                                } else {
                                  Utils.showErrorFlushbar(context, '',
                                      'Số lượng khách không hợp lệ!');
                                }
                              }, true)
                            },
                            child: Container(
                              height: 30,
                              decoration: const BoxDecoration(
                                color: primaryColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              child: Center(
                                  child: orderController
                                              .orders[i].order_status ==
                                          ORDER_STATUS_BOOKING
                                      ? Text(
                                          "BOOKING (${orderController.orders[i].total_slot})",
                                          style: textStyleOrderTitleBold16)
                                      : orderController
                                                  .orders[i].order_status ==
                                              ORDER_STATUS_SERVING
                                          ? Text(
                                              "ĐANG PHỤC VỤ (${orderController.orders[i].total_slot})",
                                              style: textStyleOrderTitleBold16)
                                          : Text(
                                              "ĐANG PHỤC VỤ (${orderController.orders[i].total_slot})",
                                              style:
                                                  textStyleOrderTitleBold16)),
                            ),
                          ),
                          marginTop5,
                          InkWell(
                            onTap: () async {
                              if (orderController.orders[i].order_status ==
                                  ORDER_STATUS_BOOKING) {
                                //BOOKING
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CustomDialogConfirmTableBooking(
                                      targetTable:
                                          orderController.orders[i].table!,
                                    );
                                  },
                                );
                              } else {
                                final result = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return MyDialogOrderDetail(
                                      order: orderController.orders[i],
                                    );
                                  },
                                );
                                if (result == 'success') {
                                  Utils.myPopResult(context, 'success');
                                }
                              }
                            },
                            child: Container(
                              height: 80,
                              decoration: const BoxDecoration(
                                color: primaryColor,
                                borderRadius: borderContainer8,
                              ),
                              child: Center(
                                  child: orderController
                                          .orders[i].table_merge_ids.isEmpty
                                      ? Text(
                                          orderController.orders[i].table!.name,
                                          style: textStyleOrderSuccessBold24)
                                      : Column(
                                          children: [
                                            Text(
                                                orderController
                                                    .orders[i].table!.name,
                                                style:
                                                    textStyleOrderSuccessBold24),
                                            Text(
                                                "(${orderController.orders[i].table_merge_names.join(', ')})",
                                                style:
                                                    textStyleOrderSuccessBold24),
                                          ],
                                        )),
                            ),
                          ),
                          marginTop5,
                          SizedBox(
                            height: 30,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: orderController
                                                  .orders[i].order_status ==
                                              ORDER_STATUS_SERVING
                                          ? primaryColor
                                          : grayColor200,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Center(
                                      child: FaIcon(
                                          FontAwesomeIcons.clockRotateLeft,
                                          color: secondColor,
                                          size: 16),
                                    ),
                                  ),
                                ),
                                marginRight5,
                                Expanded(
                                  child: Container(
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: orderController
                                                  .orders[i].order_status ==
                                              ORDER_STATUS_SERVING
                                          ? primaryColor
                                          : grayColor200,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Center(
                                      child: FaIcon(FontAwesomeIcons.print,
                                          color: secondColor, size: 16),
                                    ),
                                  ),
                                ),
                                marginRight5,
                                Expanded(
                                  child: Container(
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: orderController
                                                  .orders[i].order_status ==
                                              ORDER_STATUS_SERVING
                                          ? primaryColor
                                          : grayColor200,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Center(
                                      child: FaIcon(FontAwesomeIcons.sackDollar,
                                          color: secondColor, size: 16),
                                    ),
                                  ),
                                ),
                                marginRight5,
                                Expanded(
                                  child: Container(
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: orderController
                                                  .orders[i].order_status ==
                                              ORDER_STATUS_SERVING
                                          ? primaryColor
                                          : grayColor200,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Center(
                                      child: FaIcon(
                                          FontAwesomeIcons.fileInvoiceDollar,
                                          color: secondColor,
                                          size: 16),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ));
                }).toList(),
              ),
            );
          })
        ],
      ),
    );
  }
}
