// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/chef_bar_other/chef_bar_other_controller.dart';
import 'package:myorder/models/chef_bar.dart';

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

  @override
  void initState() {
    super.initState();
    chefBarOtherController.getCheftByOrder(widget.chefBar.chef_bar_id, '');
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
                hintText: 'Tìm kiếm bàn ...',
                hintStyle: TextStyle(color: borderColorPrimary),
              ),
              cursorColor: borderColorPrimary,
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
                      margin:
                          const EdgeInsets.all(4), // Khoảng cách dưới dạng đệm

                      decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(width: 0.1, color: borderColor)),
                      ),
                      child: GestureDetector(
                          onTap: () {},
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            child: InkWell(
                                onTap: () => {},
                                child: ListTile(
                                    selectedColor: primaryColor,
                                    leading: chefBarOtherController
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
                                    title: Text(
                                        chefBarOtherController.orderDetailOfChef
                                            .order_details[index].food!.name,
                                        style: textStyleFoodNameBold16),
                                    subtitle: Text(
                                      "$FOOD_STATUS_IN_CHEFT_STRING x ${chefBarOtherController.orderDetailOfChef.order_details[index].quantity}",
                                      style: textStyleMaking,
                                    ),
                                    trailing: SizedBox(
                                      width: 80,
                                      child: Row(
                                        children: [
                                          InkWell(
                                            onTap: () {},
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
                                            onTap: () {},
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
                                    ))),
                          )),
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
