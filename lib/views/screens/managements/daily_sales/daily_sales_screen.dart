// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/daily_sales/daily_sales_controller.dart';
import 'package:myorder/utils.dart';
import 'package:myorder/views/screens/managements/daily_sales/dialogs/dialog_copy_daily_sale.dart';
import 'package:myorder/views/screens/managements/daily_sales/update_daily_sale_detail_screen.dart';
import 'package:myorder/views/screens/managements/daily_sales/dialogs/dialog_add_update_daily_sale.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

class ManagementDailySalesScreen extends StatefulWidget {
  const ManagementDailySalesScreen({Key? key}) : super(key: key);
  @override
  State<ManagementDailySalesScreen> createState() =>
      _ManagementDailySalesScreenState();
}

class _ManagementDailySalesScreenState
    extends State<ManagementDailySalesScreen> {
  DailySalesController dailySalesController = Get.put(DailySalesController());

  @override
  void initState() {
    super.initState();
    dailySalesController.getDailySales("");
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
              onTap: () => {Navigator.pop(context)},
              child: const Icon(Icons.arrow_back_ios)),
          title: const Center(child: Text("QUẢN LÝ LỊCH BÁN")),
          actions: [
            Container(
                margin: const EdgeInsets.only(right: 10),
                child: InkWell(
                    onTap: () async {
                      final result = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const MyDialogAddUpdateDailySale();
                        },
                      );
                      if (result == "add") {
                        Utils.showStylishDialog(
                            context,
                            'THÀNH CÔNG!',
                            'Thêm mới lịch thành công!',
                            StylishDialogType.SUCCESS);
                      }
                      if (result == "update") {
                        Utils.showStylishDialog(
                            context,
                            'THÀNH CÔNG!',
                            'Cập nhật lịch thành công!',
                            StylishDialogType.SUCCESS);
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(Icons.add_circle_outline),
                    )))
          ],
          backgroundColor: primaryColor,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                marginTop10,
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
                      border: Border.all(width: 1, color: borderColorPrimary)),
                  child: TextField(
                    onChanged: (value) {
                      dailySalesController.getDailySales(value);
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
                      hintText: 'Tìm kiếm',
                      hintStyle: TextStyle(color: borderColorPrimary),
                    ),
                    cursorColor: borderColorPrimary,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: Obx(() {
                    return ListView.builder(
                        itemCount: dailySalesController.dailySales.length,
                        itemBuilder: (context, index) {
                          final dailySale =
                              dailySalesController.dailySales[index];
                          return InkWell(
                            onTap: () async {
                              final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ManagementUpdateQuantityForSellScreen(
                                            dailySale: dailySale,
                                          )));
                              if (result == 'success') {
                                Utils.showStylishDialog(
                                    context,
                                    'THÀNH CÔNG!',
                                    'Thêm mới thành công!',
                                    StylishDialogType.SUCCESS);
                              }
                            },
                            child: Card(
                              color: dailySale.active == ACTIVE
                                  ? backgroundColor
                                  : grayColor,
                              child: ListTile(
                                title: Row(
                                  children: [
                                    Marquee(
                                      direction: Axis.horizontal,
                                      textDirection: TextDirection.ltr,
                                      animationDuration:
                                          const Duration(seconds: 1),
                                      backDuration:
                                          const Duration(milliseconds: 4000),
                                      pauseDuration:
                                          const Duration(milliseconds: 1000),
                                      directionMarguee:
                                          DirectionMarguee.TwoDirection,
                                      child: Text(
                                        dailySale.name,
                                        style: textStyleNameBlackRegular,
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: RichText(
                                  text: TextSpan(
                                    text: Utils.formatTimestamp(
                                        dailySale.date_apply),
                                    style: const TextStyle(color: Colors.green),
                                  ),
                                  maxLines: 5,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: Container(
                                  width: 120,
                                  margin: const EdgeInsets.all(0),
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          final result = await showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return MyDialogAddUpdateDailySale(
                                                dailySale: dailySale,
                                              );
                                            },
                                          );
                                          if (result == "add") {
                                            Utils.showStylishDialog(
                                                context,
                                                'THÀNH CÔNG!',
                                                'Thêm mới lịch thành công!',
                                                StylishDialogType.SUCCESS);
                                          }
                                          if (result == "update") {
                                            Utils.showStylishDialog(
                                                context,
                                                'THÀNH CÔNG!',
                                                'Cập nhật lịch thành công!',
                                                StylishDialogType.SUCCESS);
                                          }
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(20),
                                          child: const FaIcon(
                                              FontAwesomeIcons.penToSquare,
                                              color: colorWarning,
                                              size: 20),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          final result = await showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return MyDialogCopyDailySale(
                                                dailySale: dailySale,
                                              );
                                            },
                                          );
                                          if (result == "add") {
                                            Utils.showStylishDialog(
                                                context,
                                                'THÀNH CÔNG!',
                                                'Thêm mới lịch bán thành công!',
                                                StylishDialogType.SUCCESS);
                                          }
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(20),
                                          child: const FaIcon(
                                              FontAwesomeIcons.copy,
                                              color: primaryColor,
                                              size: 20),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        });
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
