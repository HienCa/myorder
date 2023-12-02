// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/daily_sales/daily_sale_detail_controller.dart';
import 'package:myorder/models/daily_sales.dart';
import 'package:myorder/utils.dart';
import 'package:myorder/views/screens/managements/daily_sales/dialogs/dialog_confirm_update_daily_sale_detail.dart';
import 'package:myorder/views/widgets/dialogs/dialog_choose_price_calculator_int.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

class ManagementUpdateQuantityForSellScreen extends StatefulWidget {
  final DailySales dailySale;
  const ManagementUpdateQuantityForSellScreen(
      {Key? key, required this.dailySale})
      : super(key: key);
  @override
  State<ManagementUpdateQuantityForSellScreen> createState() =>
      _ManagementUpdateQuantityForSellScreenState();
}

class _ManagementUpdateQuantityForSellScreenState
    extends State<ManagementUpdateQuantityForSellScreen> {
  DailySaleDetailController dailySaleDetailController =
      Get.put(DailySaleDetailController());

  @override
  void initState() {
    super.initState();
    dailySaleDetailController.getDailySaleDetails(
        widget.dailySale.daily_sale_id, "");
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
            "THÔNG TIN CHI TIẾT",
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
          child: Theme(
            data: ThemeData(unselectedWidgetColor: primaryColor),
            child: Container(
              height: MediaQuery.of(context).size.height,
              color: backgroundColor,
              child: Column(
                children: [
                  marginTop10,
                  Container(
                    height: 40,
                    width: 400,
                    margin: const EdgeInsets.all(kDefaultPadding),
                    padding: const EdgeInsets.symmetric(
                      horizontal: kDefaultPadding,
                      vertical: kDefaultPadding / 4, // 5 top and bottom
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.4),
                        borderRadius: borderRadiusTextField30,
                        border: Border.all(width: 1, color: grayColor)),
                    child: TextField(
                      onChanged: (value) {
                        dailySaleDetailController.getDailySaleDetails(
                            widget.dailySale.daily_sale_id, value);
                      },
                      style: const TextStyle(color: grayColor),
                      decoration: const InputDecoration(
                        isDense: true,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        fillColor: grayColor,
                        icon: Icon(
                          Icons.search,
                          color: grayColor,
                        ),
                        hintText: 'Tìm kiếm ',
                        hintStyle: TextStyle(color: grayColor),
                      ),
                      cursorColor: grayColor,
                    ),
                  ),
                  deviderColor10,
                  //DANH SÁCH CÁC MÓN
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 50,
                            child: Row(children: [
                              Expanded(
                                  flex: 4,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      marginRight5,
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text("Món ăn",
                                              style: textStyleLabel14),
                                        ],
                                      ),
                                    ],
                                  )),
                              Expanded(
                                flex: 2,
                                child: Center(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("Số lượng bán",
                                            style: textStyleLabel14),
                                        marginRight5,
                                        Text(
                                          '(*)',
                                          style: textStyleErrorInput,
                                        )
                                      ],
                                    ),
                                  ],
                                )),
                              ),
                            ]),
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.7,
                              child: Obx(() {
                                return ListView.builder(
                                    itemCount: dailySaleDetailController
                                        .dailySaleDetails.length,
                                    itemBuilder: (context, index) {
                                      DailySaleDetail dailySaleDetail =
                                          dailySaleDetailController
                                              .dailySaleDetails[index];

                                      return Column(
                                        children: [
                                          SizedBox(
                                            height: 50,
                                            child: Row(children: [
                                              marginRight5,
                                              Expanded(
                                                flex: 1,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    dailySaleDetail
                                                                .food?.image !=
                                                            ""
                                                        ? ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            child:
                                                                Image.network(
                                                              dailySaleDetail
                                                                      .food
                                                                      ?.image ??
                                                                  defaultFoodImageString,
                                                              width: 50,
                                                              height: 50,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          )
                                                        : ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            child:
                                                                defaultFoodImage),
                                                  ],
                                                ),
                                              ),
                                              marginRight5,
                                              Expanded(
                                                flex: 4,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Marquee(
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
                                                          dailySaleDetail
                                                                  .food?.name ??
                                                              "",
                                                          style:
                                                              textStyleFoodNameBold16,
                                                          textAlign:
                                                              TextAlign.left),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: InkWell(
                                                  onTap: () async {
                                                    final result =
                                                        await showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return MyDialogCalculatorInt(
                                                          value: dailySaleDetail
                                                              .quantity_for_sell,
                                                          label: 'SỐ LƯỢNG',
                                                          min: 0,
                                                          max: 10000,
                                                        );
                                                      },
                                                    );
                                                    if (result != null) {
                                                      setState(() {
                                                        print(result);
                                                        dailySaleDetail
                                                                .new_quantity_for_sell =
                                                            int.parse(result);
                                                      });
                                                    }
                                                  },
                                                  child: Center(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          dailySaleDetail
                                                              .new_quantity_for_sell
                                                              .toString(),
                                                          style:
                                                              textStyleOrange14,
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ]),
                                          ),
                                          marginTop5,
                                        ],
                                      );
                                    });
                              }))
                        ],
                      ),
                    ),
                  )),
                  Container(
                    color: backgroundColor,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Utils.myPop(context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: grayColor200,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                margin: const EdgeInsets.all(8),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 14),
                                child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FaIcon(FontAwesomeIcons.xmark,
                                          color: colorCancel, size: 16),
                                      marginRight5,
                                      Text("HỦY", style: textStyleCanceBoldl16),
                                    ]),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                final result = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CustomDialogUpdateDailySaleDetail(
                                        dailySaleId:
                                            widget.dailySale.daily_sale_id);
                                  },
                                );
                                if (result == 'success') {
                                  Utils.showStylishDialog(
                                      context,
                                      'THÀNH CÔNG!',
                                      'Cập nhật thành công!',
                                      StylishDialogType.SUCCESS);
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: greenColor50,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                margin: const EdgeInsets.all(8),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 14),
                                child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FaIcon(FontAwesomeIcons.plus,
                                          color: colorSuccess, size: 16),
                                      marginRight5,
                                      Text("XÁC NHẬN",
                                          style: textStyleSuccessBold16),
                                    ]),
                              ),
                            ),
                          ),
                        ]),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
