// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/chef_bar_other/chef_bar_other_controller.dart';
import 'package:myorder/models/chef_bar.dart';
import 'package:myorder/utils.dart';
import 'package:myorder/views/screens/chef_bar/dialogs.dart/change_all_status_food_dialog.dart';
import 'package:myorder/views/screens/chef_bar/dialogs.dart/change_cancel_food_dialog.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

class ManagementChefDetailPage extends StatefulWidget {
  final ChefBar chefBar;
  const ManagementChefDetailPage({super.key, required this.chefBar});

  @override
  State<ManagementChefDetailPage> createState() => _ManagementChefPageState();
}

class _ManagementChefPageState extends State<ManagementChefDetailPage> {
  ChefBarOtherController chefBarOtherController =
      Get.put(ChefBarOtherController());
  bool isCheckAll = false;
  @override
  void initState() {
    super.initState();
    chefBarOtherController.getChefByOrder(widget.chefBar.chef_bar_id, '');
    Utils.unCheckAll(chefBarOtherController.orderDetailOfChef.order_details);

    // isCheckAll = Utils.isCheckedAll(
    //     chefBarOtherController.orderDetailOfChef.order_details);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
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
        title: Center(
            child: Text(
          "KHU BẾP - BÀN ${widget.chefBar.table_name}",
          style: const TextStyle(color: secondColor),
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
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
                chefBarOtherController.getChefByOrder(
                    widget.chefBar.chef_bar_id, value);
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
                hintText: 'Tìm kiếm món ...',
                hintStyle: TextStyle(color: borderColorPrimary),
              ),
              cursorColor: borderColorPrimary,
            ),
          ),
          ListTile(
            leading: Theme(
              data: ThemeData(unselectedWidgetColor: primaryColor),
              child: SizedBox(
                width: 360,
                child: Row(
                  children: [
                    SizedBox(
                      width: 47,
                      child: Checkbox(
                        value: isCheckAll,
                        onChanged: (bool? value) {
                          setState(() {
                            if (Utils.isCheckedAll(chefBarOtherController
                                .orderDetailOfChef.order_details)) {
                              Utils.unCheckAll(chefBarOtherController
                                  .orderDetailOfChef.order_details);
                              isCheckAll = false;
                              print("Unckecked All");
                            } else {
                              Utils.checkAll(chefBarOtherController
                                  .orderDetailOfChef.order_details);
                              print("Check All");
                              isCheckAll = true;
                            }
                            print(isCheckAll);
                          });
                        },
                        activeColor: primaryColor,
                      ),
                    ),
                    const Text("TẤT CẢ", style: textStyleLabel16),
                    Utils.isAnySelected(chefBarOtherController
                            .orderDetailOfChef.order_details)
                        ? Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                marginRight20,
                                InkWell(
                                  onTap: () async {
                                    final result = await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ChangeAllStatusFoodConfirmDialog(
                                            chefBarId:
                                                widget.chefBar.chef_bar_id,
                                            orderDetailList:
                                                chefBarOtherController
                                                    .orderDetailOfChef
                                                    .order_details, tableName: widget.chefBar.table_name,);
                                      },
                                    );
                                    if (result == 'success') {
                                      setState(() {
                                        Utils.showStylishDialog(
                                            context,
                                            'THÀNH CÔNG',
                                            'Cập nhật trạng thái món thành công.',
                                            StylishDialogType.SUCCESS);
                                      });
                                    }
                                  },
                                  child: Container(
                                      height: 40,
                                      width: 140,
                                      decoration: BoxDecoration(
                                        color: colorWarning,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "TRẠNG THÁI (${Utils.counterOrderDetailSelected(chefBarOtherController.orderDetailOfChef.order_details)})",
                                          style: textStyleWhiteBold16,
                                        ),
                                      )),
                                ),
                                marginRight10,
                                InkWell(
                                  onTap: () async {
                                    if (Utils
                                            .counterCancelStatusOrderDetailSelected(
                                                chefBarOtherController
                                                    .orderDetailOfChef
                                                    .order_details) >
                                        0) {
                                      final result = await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return ChangeCancelFoodConfirmDialog(
                                            chefBarId:
                                                widget.chefBar.chef_bar_id,
                                            orderDetailList:
                                                chefBarOtherController
                                                    .orderDetailOfChef
                                                    .order_details,tableName: widget.chefBar.table_name
                                          );
                                        },
                                      );
                                      if (result != null) {
                                        setState(() {
                                          Utils.showStylishDialog(
                                              context,
                                              'THÀNH CÔNG',
                                              'Đã xác nhận không thực hiện món này.',
                                              StylishDialogType.SUCCESS);
                                        });
                                      }
                                    }
                                  },
                                  child: Container(
                                      height: 40,
                                      width: 90,
                                      decoration: BoxDecoration(
                                        color: colorCancel,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "HỦY (${Utils.counterCancelStatusOrderDetailSelected(chefBarOtherController.orderDetailOfChef.order_details)})",
                                          style: textStyleWhiteBold16,
                                        ),
                                      )),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin:
                  const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
              decoration: BoxDecoration(
                color: Colors.white,
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
              child: Obx(() {
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: chefBarOtherController
                      .orderDetailOfChef.order_details.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(
                          left: 0, right: 0, top: 0, bottom: 5),
                      decoration: chefBarOtherController.orderDetailOfChef
                                  .order_details[index].isSelected ==
                              true
                          ? BoxDecoration(
                              color: const Color(0xFF40BAD5).withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            )
                          : const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 0.1, color: borderColor)),
                            ),
                      child: Column(
                        children: [
                          ListTile(
                            selectedColor: primaryColor,
                            leading: Theme(
                              data: ThemeData(
                                  unselectedWidgetColor: primaryColor),
                              child: SizedBox(
                                width: 100,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Checkbox(
                                      value: chefBarOtherController
                                          .orderDetailOfChef
                                          .order_details[index]
                                          .isSelected,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          setState(() {
                                            chefBarOtherController
                                                .orderDetailOfChef
                                                .order_details[index]
                                                .isSelected = value ?? false;

                                            isCheckAll = Utils.isCheckedAll(
                                                chefBarOtherController
                                                    .orderDetailOfChef
                                                    .order_details);

                                            print(
                                                "isChecked - $value: ${chefBarOtherController.orderDetailOfChef.order_details[index].food!.name}");
                                          });
                                        });
                                      },
                                      activeColor: primaryColor,
                                    ),
                                    chefBarOtherController
                                                .orderDetailOfChef
                                                .order_details[index]
                                                .food!
                                                .image !=
                                            ''
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            child: Image.network(
                                              chefBarOtherController
                                                  .orderDetailOfChef
                                                  .order_details[index]
                                                  .food!
                                                  .image!,
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : ClipRRect(
                                            child:
                                                defaultFoodImage, // ảnh trong constants
                                          ),
                                  ],
                                ),
                              ),
                            ),
                            title: Marquee(
                              direction: Axis.horizontal,
                              textDirection: TextDirection.ltr,
                              animationDuration: const Duration(seconds: 1),
                              backDuration: const Duration(milliseconds: 4000),
                              pauseDuration: const Duration(milliseconds: 1000),
                              directionMarguee: DirectionMarguee.TwoDirection,
                              child: Text(
                                  chefBarOtherController.orderDetailOfChef
                                      .order_details[index].food!.name,
                                  style: textStyleFoodNameBold16),
                            ),
                            subtitle: chefBarOtherController.orderDetailOfChef
                                        .order_details[index].food_status ==
                                    FOOD_STATUS_IN_CHEF
                                ? Text(
                                    "$FOOD_STATUS_IN_CHEF_STRING x ${chefBarOtherController.orderDetailOfChef.order_details[index].quantity}",
                                    style: textStyleMaking,
                                  )
                                : Text(
                                    "$FOOD_STATUS_COOKING_STRING x ${chefBarOtherController.orderDetailOfChef.order_details[index].quantity}",
                                    style: textStyleCooking,
                                  ),
                            // trailing: chefBarOtherController.orderDetailOfChef
                            //         .order_details[index].isSelected
                            //     ? SizedBox(
                            //         width: 30,
                            //         child: Row(
                            //           children: [
                            //             InkWell(
                            //               onTap: () async {
                            //                 final result = await showDialog(
                            //                   context: context,
                            //                   builder: (BuildContext context) {
                            //                     return ChangeCancelFoodConfirmDialog(
                            //                       chefBarId: widget
                            //                           .chefBar.chef_bar_id,
                            //                       orderDetailList:
                            //                           chefBarOtherController
                            //                               .orderDetailOfChef
                            //                               .order_details,
                            //                     );
                            //                   },
                            //                 );
                            //                 if (result != null) {
                            //                   setState(() {
                            //                     Utils.showStylishDialog(
                            //                         context,
                            //                         'THÀNH CÔNG',
                            //                         'Đã xác nhận không chế biến món này.',
                            //                         StylishDialogType.SUCCESS);
                            //                   });
                            //                 }
                            //               },
                            //               child: Container(
                            //                 decoration: BoxDecoration(
                            //                   color: colorCancel,
                            //                   borderRadius:
                            //                       BorderRadius.circular(5),
                            //                 ),
                            //                 height: 30,
                            //                 width: 30,
                            //                 child: const Align(
                            //                   alignment: Alignment.center,
                            //                   child: Icon(Icons.close,
                            //                       color: secondColor),
                            //                 ),
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //       )
                            //     : const SizedBox()
                          ),
                          //Danh sách Combo
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            child: Container(
                              margin: const EdgeInsets.only(left: 70),
                              height: chefBarOtherController.orderDetailOfChef
                                      .order_details[index].listCombo.length *
                                  62,
                              child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: chefBarOtherController
                                    .orderDetailOfChef
                                    .order_details[index]
                                    .listCombo
                                    .length,
                                itemBuilder: (context, indexCombo) {
                                  return Container(
                                    margin: const EdgeInsets.all(
                                        4), // Khoảng cách dưới dạng đệm

                                    decoration: const BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              width: 0.1, color: borderColor)),
                                    ),
                                    child: GestureDetector(
                                        onTap: () {
                                          setState(() {});
                                        },
                                        child: AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 300),
                                          curve: Curves.easeInOut,
                                          // Chiều cao của ListTile thay đổi
                                          child: InkWell(
                                            onTap: () => {setState(() {})},
                                            child: Column(
                                              children: [
                                                ListTile(
                                                  selectedColor: primaryColor,
                                                  leading: Theme(
                                                    data: ThemeData(
                                                        unselectedWidgetColor:
                                                            primaryColor),
                                                    child: SizedBox(
                                                      width: 40,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          chefBarOtherController
                                                                      .orderDetailOfChef
                                                                      .order_details[
                                                                          index]
                                                                      .listCombo[
                                                                          indexCombo]
                                                                      .image !=
                                                                  ""
                                                              ? ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                  child: Image
                                                                      .network(
                                                                    chefBarOtherController
                                                                            .orderDetailOfChef
                                                                            .order_details[index]
                                                                            .listCombo[indexCombo]
                                                                            .image ??
                                                                        defaultFoodImageString,
                                                                    width: 40,
                                                                    height: 40,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                )
                                                              : ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                  child:
                                                                      defaultFoodImage40),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  title: Marquee(
                                                      direction:
                                                          Axis.horizontal,
                                                      textDirection: TextDirection
                                                          .ltr,
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
                                                      child: RichText(
                                                          text: TextSpan(
                                                        children: [
                                                          TextSpan(
                                                              text: chefBarOtherController
                                                                  .orderDetailOfChef
                                                                  .order_details[
                                                                      index]
                                                                  .listCombo[
                                                                      indexCombo]
                                                                  .name,
                                                              style: chefBarOtherController
                                                                          .orderDetailOfChef
                                                                          .order_details[
                                                                              index]
                                                                          .listCombo[
                                                                              indexCombo]
                                                                          .isSelected ==
                                                                      true
                                                                  ? textStyleWhiteRegular16
                                                                  : textStyleFoodNameBold16),
                                                        ],
                                                      ))),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )),
                                  );
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
