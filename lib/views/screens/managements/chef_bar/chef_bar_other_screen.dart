// ignore_for_file: avoid_print

// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/chef_bar_other/chef_bar_other_controller.dart';
import 'package:myorder/models/order_detail.dart';
import 'package:myorder/views/screens/managements/chef_bar/bar_screen.dart';
import 'package:myorder/views/screens/managements/chef_bar/chef_screen.dart';
import 'package:myorder/views/screens/managements/chef_bar/other_screen.dart';
import 'package:responsive_grid/responsive_grid.dart';

class ManagementChefBarOtherPage extends StatefulWidget {
  const ManagementChefBarOtherPage({Key? key}) : super(key: key);

  @override
  State<ManagementChefBarOtherPage> createState() =>
      _ManagementChefBarOtherPageState();
}

class _ManagementChefBarOtherPageState
    extends State<ManagementChefBarOtherPage> {
  ChefBarOtherController chefBarOtherController =
      Get.put(ChefBarOtherController());
  var keySearch = "";
  // var countChef = 0;
  // var countBar = 0;
  // var countOther = 0;
  List<OrderDetail> orderDetailArray = [];

  @override
  void initState() {
    super.initState();
    chefBarOtherController.getChefs(keySearch);
    chefBarOtherController.getBars(keySearch);
    chefBarOtherController.getOthers(keySearch);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
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
            bottom: TabBar(
              indicator: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: backgroundColor,
                    width: 2.5,
                  ),
                ),
              ),
              tabs: [
                Tab(child: Obx(() {
                  return chefBarOtherController.chefs.isNotEmpty
                      ? Text(
                          'KHU BẾP (${chefBarOtherController.chefs.length})',
                          style: textStyleWhiteBold14,
                        )
                      : const Text(
                          'KHU BẾP',
                          style: textStyleWhiteBold14,
                        );
                })),
                Tab(child: Obx(() {
                  return chefBarOtherController.bars.isNotEmpty
                      ? Text(
                          'QUẦY BAR (${chefBarOtherController.bars.length})',
                          style: textStyleWhiteBold14,
                        )
                      : const Text(
                          'QUẦY BAR',
                          style: textStyleWhiteBold14,
                        );
                })),
                Tab(child: Obx(() {
                  return chefBarOtherController.others.isNotEmpty
                      ? Text(
                          'KHÁC (${chefBarOtherController.others.length})',
                          style: textStyleWhiteBold14,
                        )
                      : const Text(
                          'KHÁC',
                          style: textStyleWhiteBold14,
                        );
                })),
                
              ],
            ),
            title: const Center(
                child: Text(
              "BẾP / BAR",
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
          body: TabBarView(
            children: [
              //CHEF
              Obx(() {
                return SingleChildScrollView(
                  child: Container(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Column(
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
                                border: Border.all(
                                    width: 1, color: borderColorPrimary)),
                            child: TextField(
                              onChanged: (value) {
                                chefBarOtherController.getChefs(value);
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
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.7,
                            child: ResponsiveGridList(
                                desiredItemWidth: 100,
                                minSpacing: 10,
                                children: List.generate(
                                    chefBarOtherController.chefs.length,
                                    (index) => index).map(
                                  (i) {
                                    return InkWell(
                                      onTap: () => {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ManagementChefDetailPage(
                                                      chefBar:
                                                          chefBarOtherController
                                                              .chefs[i],
                                                    )))
                                      },
                                      child: Stack(children: [
                                        Container(
                                          height: 100,
                                          alignment: const Alignment(0, 0),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: activeColor),
                                          child: Text(
                                              chefBarOtherController
                                                  .chefs[i].table_name,
                                              style: textStyleWhiteBold30),
                                        ),
                                        Positioned(
                                            top: 0,
                                            right: 0,
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(10),
                                                    bottomLeft:
                                                        Radius.circular(10),
                                                  ),
                                                  color: colorCancel),
                                              height: 30,
                                              width: 40,
                                              child: Center(
                                                child: Text(
                                                    "${chefBarOtherController.chefs[i].quantity}",
                                                    style:
                                                        textStyleWhiteBold20),
                                              ),
                                            ))
                                      ]),
                                    );
                                  },
                                ).toList()),
                          ),
                        ],
                      )),
                );
              }),
              //BAR
              Obx(() {
                return SingleChildScrollView(
                  child: Container(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Column(
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
                                border: Border.all(
                                    width: 1, color: borderColorPrimary)),
                            child: TextField(
                              onChanged: (value) {
                                chefBarOtherController.getBars(value);
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
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.7,
                            child: ResponsiveGridList(
                                desiredItemWidth: 100,
                                minSpacing: 10,
                                children: List.generate(
                                    chefBarOtherController.bars.length,
                                    (index) => index).map((i) {
                                  return InkWell(
                                    onTap: () => {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ManagementBarDetailPage(
                                                    chefBar:
                                                        chefBarOtherController
                                                            .bars[i],
                                                  )))
                                    },
                                    child: Stack(children: [
                                      Container(
                                        height: 100,
                                        alignment: const Alignment(0, 0),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: activeColor),
                                        child: Text(
                                            chefBarOtherController
                                                .bars[i].table_name,
                                            style: textStyleWhiteBold30),
                                      ),
                                      Positioned(
                                          top: 0,
                                          right: 0,
                                          child: Container(
                                            decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(10),
                                                  bottomLeft:
                                                      Radius.circular(10),
                                                ),
                                                color: colorCancel),
                                            height: 30,
                                            width: 40,
                                            child: Center(
                                              child: Text(
                                                  "${chefBarOtherController.bars[i].quantity}",
                                                  style: textStyleWhiteBold20),
                                            ),
                                          ))
                                    ]),
                                  );
                                }).toList()),
                          ),
                        ],
                      )),
                );
              }),

              //OTHER
              Obx(() {
                return SingleChildScrollView(
                  child: Container(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Column(
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
                                border: Border.all(
                                    width: 1, color: borderColorPrimary)),
                            child: TextField(
                              onChanged: (value) {
                                chefBarOtherController.getOthers(value);
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
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.7,
                            child: ResponsiveGridList(
                                desiredItemWidth: 100,
                                minSpacing: 10,
                                children: List.generate(
                                    chefBarOtherController.others.length,
                                    (index) => index).map((i) {
                                  return InkWell(
                                    onTap: () => {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ManagementOtherDetailPage(
                                                    chefBar:
                                                        chefBarOtherController
                                                            .others[i],
                                                  )))
                                    },
                                    child: Stack(children: [
                                      Container(
                                        height: 100,
                                        alignment: const Alignment(0, 0),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: activeColor),
                                        child: Text(
                                            chefBarOtherController
                                                .others[i].table_name,
                                            style: textStyleWhiteBold30),
                                      ),
                                      Positioned(
                                          top: 0,
                                          right: 0,
                                          child: Container(
                                            decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(10),
                                                  bottomLeft:
                                                      Radius.circular(10),
                                                ),
                                                color: colorCancel),
                                            height: 30,
                                            width: 40,
                                            child: Center(
                                              child: Text(
                                                  "${chefBarOtherController.others[i].quantity}",
                                                  style: textStyleWhiteBold20),
                                            ),
                                          ))
                                    ]),
                                  );
                                }).toList()),
                          ),
                        ],
                      )),
                );
              }),
            ],
          ),
        ));
  }
}
