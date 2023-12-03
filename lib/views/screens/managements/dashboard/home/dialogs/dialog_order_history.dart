// ignore_for_file: non_constant_identifier_names, avoid_print, prefer_interpolation_to_compose_strings, constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:myorder/constants.dart';

import 'package:myorder/controllers/order_history/order_history_controller.dart';

import 'package:myorder/models/order.dart';
import 'package:myorder/utils.dart';

import 'package:myorder/views/widgets/icons/icon_close.dart';
import 'package:myorder/views/widgets/videos/rotate_phone.dart';

class MyDialogOrderHistory extends StatefulWidget {
  final Order order;
  const MyDialogOrderHistory({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  State<MyDialogOrderHistory> createState() => _MyDialogOrderHistoryState();
}

class _MyDialogOrderHistoryState extends State<MyDialogOrderHistory> {
  final searchTextEditingController = TextEditingController();

  OrderHistoryController orderHistoryController =
      Get.put(OrderHistoryController());

  String keySearch = "";
  int categoryCodeSelected = 0;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    orderHistoryController.getAllOrderHistory(widget.order.order_id, keySearch);
  }

  @override
  Widget build(BuildContext context) {
    return Utils.isLandscapeOrientation(context) ? Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Góc bo tròn
      ),
      elevation: 5, // Độ nâng của bóng đổ
      backgroundColor: grayColor200,
      child: Theme(
        data: ThemeData(unselectedWidgetColor: primaryColor),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  color: backgroundColor,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 50,
                        margin: const EdgeInsets.only(left: 8, right: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "LỊCH SỬ HOẠT ĐỘNG CỦA ĐƠN HÀNG",
                              style: textStyleTabLandscapeLabelBold,
                            ),
                            marginRight20,
                            Text(
                              "#${widget.order.order_code}",
                              style: textStylePrimaryLandscapeBold,
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 40,
                          padding: const EdgeInsets.only(left: 16),
                          margin: const EdgeInsets.only(right: 8, left: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.4),
                            borderRadius: borderRadiusTextField30,
                            border:
                                Border.all(width: 1, color: borderColorPrimary),
                          ),
                          child: TextField(
                            controller: searchTextEditingController,
                            onChanged: (value) {
                              setState(() {
                                orderHistoryController.getAllOrderHistory(
                                    widget.order.order_id, value);
                              });
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
                              hintText: 'Tìm kiếm ...',
                              hintStyle: TextStyle(color: borderColorPrimary),
                            ),
                            cursorColor: borderColorPrimary,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Padding(
                        padding: EdgeInsets.only(right: 6),
                        child: MyCloseIcon(heightWidth: 30, sizeIcon: 20),
                      )
                    ],
                  ),
                ),
                marginTop5,
                Container(
                  height: MediaQuery.of(context).size.height  * 0.7,
                  color: backgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        marginTop5,
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                                flex: 1,
                                child: Text("THỜI GIAN",
                                    style: textStyleCookingLandscape)),
                            Expanded(
                                flex: 1,
                                child: Text("NGƯỜI DÙNG",
                                    style: textStyleCookingLandscape)),
                            Expanded(
                                flex: 2,
                                child: Text("CHI TIẾT",
                                    style: textStyleCookingLandscape))
                          ],
                        ),
                        marginTop10,
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.58,
                          child: Obx(() {
                            return ListView.builder(
                                itemCount:
                                    orderHistoryController.orderHistory.length,
                                itemBuilder: (context, index) {
                                  final orderHistory = orderHistoryController
                                      .orderHistory[index];

                                  return Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                              flex: 1,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      Utils.formatTimestamp(
                                                          orderHistory
                                                              .create_at),
                                                      style:
                                                          textStyleTabLandscapeLabel),
                                                  Text(
                                                      Utils.formatTime(
                                                          orderHistory
                                                              .create_at),
                                                      style:
                                                          textStyleTabLandscapeLabel),
                                                ],
                                              )),
                                          Expanded(
                                              flex: 1,
                                              child: Text(
                                                  orderHistory.employee_name,
                                                  style:
                                                      textStyleTabLandscapeLabel)),
                                          Expanded(
                                              flex: 2,
                                              child: Text(
                                                  softWrap:
                                                      true, // Cho phép xuống dòng
                                                  overflow:
                                                      TextOverflow.visible,
                                                  orderHistory.description
                                                      .replaceAll("\\\n", "\n"),
                                                  style:
                                                      textStyleTabLandscapeLabel))
                                        ],
                                      ),
                                      marginTop5,
                                    ],
                                  );
                                });
                          }),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ) : Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Góc bo tròn
      ),
      elevation: 5, // Độ nâng của bóng đổ
      backgroundColor: grayColor200,
      child: const RequiredRotatePhoneToLanscape());
  }
}
