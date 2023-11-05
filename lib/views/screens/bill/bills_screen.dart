// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/bills/bills_controller.dart';
import 'package:myorder/controllers/orders/orders_controller.dart';
import 'package:myorder/utils.dart';
import 'package:myorder/views/screens/bill/detail_bill_screen.dart';

class BillPage extends StatefulWidget {
  const BillPage({super.key});

  @override
  State<BillPage> createState() => _BillPageState();
}

class _BillPageState extends State<BillPage> {
  BillController billController = Get.put(BillController());
  OrderController orderController = Get.put(OrderController());
  String keySearch = "";
  String timeSelected = defaultEmployee;
  int selectedIndex = 0;
  List options = TIME_OPTION;

  @override
  void initState() {
    super.initState();
    billController.getBills(selectedIndex, keySearch);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: primaryColor,
            secondary: primaryColor,
          ),
        ),
        home: Scaffold(
          appBar: AppBar(
            leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back_ios,
                color: secondColor,
              ),
            ),
            title: const Center(
                child: Text(
              "QUẢN LÝ HÓA ĐƠN",
              style: TextStyle(color: secondColor),
            )),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 10),
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    Icons.add_circle_outline,
                    color: transparentColor,
                  ),
                ),
              ),
            ],
            backgroundColor: primaryColor,
          ),
          body: SafeArea(
            bottom: false,
            child: Column(
              children: <Widget>[
                Container(
                  height: 50,
                  width: 400,
                  margin: const EdgeInsets.all(kDefaultPadding),
                  padding: const EdgeInsets.symmetric(
                    horizontal: kDefaultPadding,
                    vertical: kDefaultPadding / 4, // 5 top and bottom
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.4),
                      borderRadius: borderRadiusTextField30,
                      border: Border.all(width: 1, color: colorSuccess)),
                  child: TextField(
                    onChanged: (value) => {
                      setState(() {
                        keySearch = value;
                        billController.getBills(selectedIndex, value);
                      }),
                      print(value)
                    },
                    style: const TextStyle(color: colorSuccess),
                    decoration: const InputDecoration(
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      fillColor: borderColorPrimary,
                      icon: Icon(
                        Icons.search,
                        color: colorSuccess,
                      ),
                      hintText: 'Tìm kiếm đơn hàng ...',
                      hintStyle: TextStyle(color: colorSuccess),
                    ),
                    cursorColor: borderColorPrimary,
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
                  height: 35,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: options.length,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;

                          billController.getBills(index, keySearch);

                          print(timeSelected);
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(
                          left: kDefaultPadding,
                          // At end item it add extra 20 right  padding
                          right:
                              index == options.length - 1 ? kDefaultPadding : 0,
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: kDefaultPadding),
                        decoration: BoxDecoration(
                            color: index == selectedIndex
                                ? colorSuccess
                                : textWhiteColor,
                            borderRadius: BorderRadius.circular(20),
                            border: index == selectedIndex
                                ? Border.all(width: 5, color: colorSuccess)
                                : Border.all(width: 1, color: colorSuccess)),
                        child: Text(
                          options[index],
                          style: index == selectedIndex
                              ? const TextStyle(
                                  color: textWhiteColor,
                                  fontWeight: FontWeight.bold)
                              : const TextStyle(
                                  color: colorSuccess,
                                  fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                  ),
                ),
                marginTop10,
                Expanded(
                  child: Obx(() {
                    return ListView.builder(
                      itemCount: billController.bills.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: backgroundBillColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          margin: const EdgeInsets.symmetric(
                            horizontal: kDefaultPadding,
                            vertical: kDefaultPadding / 2,
                          ),
                          // color: Colors.blueAccent,
                          height: 160,
                          child: InkWell(
                            onTap: () => {},
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: <Widget>[
                                // Those are our background
                                Container(
                                  height: 136,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(22),
                                    color: backgroundBillColor,
                                    boxShadow: const [kDefaultShadow],
                                  ),
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(22),
                                    ),
                                  ),
                                ),
                                // our order image
                                Positioned(
                                  bottom: 10,
                                  left: 0,
                                  child: Hero(
                                    tag: 1,
                                    child: InkWell(
                                      onTap: () => {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    BillDetailPage(
                                                      bill: billController
                                                          .bills[index],
                                                    )))
                                      },
                                      child: Container(
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(22),
                                              topRight: Radius.circular(22),
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: kDefaultPadding),
                                          height: 120,
                                          width: 180,
                                          child: Column(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                  height: 120,
                                                  width: 180,
                                                  decoration:
                                                      const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(10),
                                                    ),
                                                    color: backgroundBillColor,
                                                  ),
                                                  child: const Center(
                                                      child: Text("HOÀN THÀNH",
                                                          style:
                                                              textStyleBillSuccessBold20)),
                                                ),
                                              ),
                                              marginTop10,
                                              Expanded(
                                                flex: 2,
                                                child: Container(
                                                  height: 120,
                                                  width: 180,
                                                  decoration:
                                                      const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(10),
                                                    ),
                                                    color: backgroundBillColor,
                                                  ),
                                                  child: billController
                                                          .bills[index]
                                                          .order!
                                                          .table_merge_ids
                                                          .isNotEmpty
                                                      ? Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Expanded(
                                                              child: Center(
                                                                  child: Text(
                                                                      billController
                                                                          .bills[
                                                                              index]
                                                                          .order!
                                                                          .table!
                                                                          .name,
                                                                      style:
                                                                          textStyleBillSuccessBold20)),
                                                            ),
                                                            Expanded(
                                                              child: Center(
                                                                  child: Text(
                                                                      billController
                                                                              .bills[
                                                                                  index]
                                                                              .order!
                                                                              .table_merge_names
                                                                              .isNotEmpty
                                                                          ? "(${billController.bills[index].order!.table_merge_names.join(', ')})"
                                                                          : "",
                                                                      style:
                                                                          textStyleBillTableMergeName16)),
                                                            ),
                                                          ],
                                                        )
                                                      : Center(
                                                          child: Text(
                                                              billController
                                                                  .bills[index]
                                                                  .order!
                                                                  .table!
                                                                  .name,
                                                              style:
                                                                  textStyleBillSuccessBold20)),
                                                ),
                                              ),
                                            ],
                                          )),
                                    ),
                                  ),
                                ),
                                // order title and price
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: SizedBox(
                                    height: 100,
                                    width: size.width - 200,
                                    child: const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        // Container(
                                        //   padding: const EdgeInsets.symmetric(
                                        //     horizontal: kDefaultPadding,
                                        //   ),
                                        //   decoration: const BoxDecoration(
                                        //     color: backgroundBillColor,
                                        //     borderRadius: BorderRadius.only(
                                        //       bottomLeft: Radius.circular(22),
                                        //     ),
                                        //   ),
                                        //   child: Text(
                                        //     formattedTime, // thời gian khách đã ăn
                                        //     style: textStyleWhiteBold20,
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 24,
                                  right: 10,
                                  child: SizedBox(
                                    height: 136,
                                    // our image take 200 width, thats why we set out total width - 200
                                    width: size.width - 200,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal:
                                                kDefaultPadding, // 30 padding
                                            vertical: kDefaultPadding /
                                                4, // 5 top and bottom
                                          ),
                                          decoration: const BoxDecoration(
                                            color: backgroundBillColor,
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(22),
                                            ),
                                          ),
                                          child: Text(
                                            Utils.formatCurrency(billController
                                                .bills[index].total_amount),
                                            style: textStyleWhiteBold20,
                                          ),
                                        ),
                                        const Spacer(),
                                        marginTop10,
                                        Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: kDefaultPadding),
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  width: 200,
                                                  height: 26,
                                                  child: Row(children: [
                                                    const Icon(
                                                        Icons.info_outline_rounded,
                                                        color: iconColor),
                                                    marginRight10,
                                                    Text(
                                                        "#${billController.bills[index].order!.order_code}"),
                                                  ]),
                                                ),
                                                SizedBox(
                                                  width: 200,
                                                  height: 26,
                                                  child: Row(children: [
                                                    const Icon(
                                                        Icons
                                                            .date_range_outlined,
                                                        color: iconColor),
                                                    marginRight10,
                                                    Text(Utils
                                                        .convertTimestampToFormatDateVN(
                                                            billController
                                                                .bills[index]
                                                                .payment_at)),
                                                  ]),
                                                ),
                                                SizedBox(
                                                  width: 200,
                                                  height: 26,
                                                  child: Row(children: [
                                                    const Icon(
                                                        Icons
                                                            .person_outline_rounded,
                                                        color: iconColor),
                                                    marginRight10,
                                                    SizedBox(
                                                      width: 130,
                                                      child: Marquee(
                                                        direction:
                                                            Axis.horizontal,
                                                        textDirection:
                                                            TextDirection.ltr,
                                                        animationDuration:
                                                            const Duration(
                                                                seconds: 1),
                                                        backDuration:
                                                            const Duration(
                                                                milliseconds:
                                                                    4000),
                                                        pauseDuration:
                                                            const Duration(
                                                                milliseconds:
                                                                    1000),
                                                        directionMarguee:
                                                            DirectionMarguee
                                                                .TwoDirection,
                                                        child: Text(
                                                          billController
                                                                  .bills[index]
                                                                  .order!
                                                                  .employee_name ??
                                                              "Chủ nhà hàng",
                                                          textAlign:
                                                              TextAlign.left,
                                                        ),
                                                      ),
                                                    ),
                                                  ]),
                                                ),
                                              ],
                                            )),
                                        const Spacer(),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
                marginTop10,
                Container(
                  height: 60,
                  padding: const EdgeInsets.all(
                    8,
                  ),
                  decoration: const BoxDecoration(
                    color: backgroundBillColor,
                    // borderRadius: BorderRadius.only(
                    //   topLeft: Radius.circular(22),
                    //   topRight: Radius.circular(22),
                    // ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Doanh thu tạm tính",
                            style: textStyleWhiteBold16,
                          ),
                          Obx(() {
                            return Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                Utils.formatCurrency(Utils.getSumTotalAmount(
                                    billController.bills)),
                                style: textStyleWhiteBold16,
                              ),
                            );
                          }),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            "Tổng hóa đơn",
                            style: textStyleWhiteBold16,
                          ),
                          Obx(() {
                            return Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "${billController.bills.length}",
                                style: textStyleWhiteBold16,
                              ),
                            );
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
