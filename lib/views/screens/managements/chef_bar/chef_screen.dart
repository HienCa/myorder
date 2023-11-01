// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/chef_bar_other/chef_bar_other_controller.dart';
import 'package:myorder/models/chef_bar.dart';
import 'package:myorder/utils.dart';
import 'package:myorder/views/widgets/dialogs/dialog_confirm.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

class ManagementChefDetailPagePage extends StatefulWidget {
  final ChefBar chefBar;
  const ManagementChefDetailPagePage({super.key, required this.chefBar});

  @override
  State<ManagementChefDetailPagePage> createState() =>
      _ManagementChefPagePageState();
}

class _ManagementChefPagePageState extends State<ManagementChefDetailPagePage> {
  ChefBarOtherController chefBarOtherController =
      Get.put(ChefBarOtherController());
  bool isCheckAll = false;
  @override
  void initState() {
    super.initState();
    chefBarOtherController.getCheftByOrder(widget.chefBar.chef_bar_id, '');
    Utils.unCheckAll(chefBarOtherController.orderDetailOfChef.order_details);
    isCheckAll = Utils.isCheckedAll(
        chefBarOtherController.orderDetailOfChef.order_details);
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
          "BẾP - BÀN ${widget.chefBar.table_name}",
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
                chefBarOtherController.getCheftByOrder(
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
                width: 200,
                child: Row(
                  children: [
                    SizedBox(
                      width: 50,
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
                    const Text("ALL", style: textStyleLabel20),
                  ],
                ),
              ),
            ),
            trailing: isCheckAll
                ? InkWell(
                    onTap: () async {
                      final result = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const MyDialogMessage(
                              title: 'XÁC NHẬN CHẾ BIẾN',
                              discription: 'Bạn muốn chế biến tất cả?');
                        },
                      );
                      if (result != null) {
                        setState(() {
                          Utils.showStylishDialog(
                              context,
                              'THÀNH CÔNG',
                              'Đã xác nhận chế biến món.',
                              StylishDialogType.SUCCESS);
                        });
                      }
                    },
                    child: Container(
                        height: 40,
                        width: 150,
                        decoration: BoxDecoration(
                          color: colorSuccess,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text(
                            "CHẾ BIẾN",
                            style: textStyleWhiteBold20,
                          ),
                        )),
                  )
                : const SizedBox(),
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
                        child: ListTile(
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
                                                  .image,
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
                            subtitle: Text(
                              "$FOOD_STATUS_IN_CHEFT_STRING x ${chefBarOtherController.orderDetailOfChef.order_details[index].quantity}",
                              style: textStyleMaking,
                            ),
                            trailing: chefBarOtherController.orderDetailOfChef
                                    .order_details[index].isSelected
                                ? SizedBox(
                                    width: 80,
                                    child: Row(
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            final result = await showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return const MyDialogMessage(
                                                    title:
                                                        'XÁC NHẬN KHÔNG CHẾ BIẾN',
                                                    discription:
                                                        'Không chế biến món này?');
                                              },
                                            );
                                            if (result != null) {
                                              setState(() {
                                                Utils.showStylishDialog(
                                                    context,
                                                    'THÀNH CÔNG',
                                                    'Đã xác nhận không chế biến món này.',
                                                    StylishDialogType.SUCCESS);
                                              });
                                            }
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: colorCancel,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            height: 30,
                                            width: 30,
                                            child: const Align(
                                              alignment: Alignment.center,
                                              child: Icon(Icons.close,
                                                  color: secondColor),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        InkWell(
                                          onTap: () async {
                                            final result = await showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return const MyDialogMessage(
                                                    title: 'XÁC NHẬN CHẾ BIẾN',
                                                    discription:
                                                        'Bạn muốn chế biến món này?');
                                              },
                                            );
                                            if (result != null) {
                                              setState(() {
                                                Utils.showStylishDialog(
                                                    context,
                                                    'THÀNH CÔNG',
                                                    'Đã xác nhận chế biến món này.',
                                                    StylishDialogType.SUCCESS);
                                              });
                                            }
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: colorSuccess,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            height: 30,
                                            width: 30,
                                            child: const Align(
                                              alignment: Alignment.center,
                                              child: Icon(Icons.check,
                                                  color: secondColor),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox()));
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