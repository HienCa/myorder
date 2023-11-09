// ignore_for_file: non_constant_identifier_names, avoid_print, prefer_interpolation_to_compose_strings, constant_identifier_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/constants/app_constants.dart';
import 'package:myorder/controllers/foods/foods_controller.dart';
import 'package:myorder/controllers/orders/orders_controller.dart';
import 'package:myorder/models/order.dart';
import 'package:myorder/utils.dart';
import 'package:myorder/views/widgets/buttons/button_icon.dart';
import 'package:responsive_grid/responsive_grid.dart';

enum DashBoardOrderDetail { Food, Drink, Other, Gift }

class MyDialogOrderDetail extends StatefulWidget {
  final Order order;
  const MyDialogOrderDetail({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  State<MyDialogOrderDetail> createState() => _MyDialogOrderDetailState();
}

class _MyDialogOrderDetailState extends State<MyDialogOrderDetail> {
  OrderController orderController = Get.put(OrderController());
  FoodController foodController = Get.put(FoodController());
  String keySearch = "";
  int categoryCodeSelected = 0;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Filter Food
    categoryCodeSelected = CATEGORY_FOOD;
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    isFood = true;
    isDrink = false;
    isOther = false;
    isGift = false;

    //Lây thông tin đơn hàng
    orderController.getOrderDetailById(widget.order);
    foodController.getfoodsToOrder(keySearch, defaultCategory);
  }

  bool isFood = true;
  bool isDrink = false;
  bool isOther = false;
  bool isGift = false;

  void setUpScreen(DashBoardOrderDetail dashBoardOrderDetail) {
    switch (dashBoardOrderDetail) {
      case DashBoardOrderDetail.Food:
        setState(() {
          isFood = true;
          isDrink = false;
          isOther = false;
          isGift = false;
          categoryCodeSelected = CATEGORY_FOOD;
        });
      case DashBoardOrderDetail.Drink:
        setState(() {
          isFood = false;
          isDrink = true;
          isOther = false;
          isGift = false;
          categoryCodeSelected = CATEGORY_DRINK;
        });
      case DashBoardOrderDetail.Other:
        setState(() {
          isFood = false;
          isDrink = false;
          isOther = true;
          isGift = false;
          categoryCodeSelected = CATEGORY_OTHER;
        });
      case DashBoardOrderDetail.Gift:
        setState(() {
          isFood = false;
          isDrink = false;
          isOther = false;
          isGift = true;
          categoryCodeSelected = CATEGORY_GIFT;
        });
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Góc bo tròn
      ),
      elevation: 5, // Độ nâng của bóng đổ
      backgroundColor: grayColor200,
      child: Theme(
        data: ThemeData(unselectedWidgetColor: primaryColor),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          // padding: EdgeInsets.all(4),
                          height: 40,
                          color: backgroundColor,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SizedBox(
                              height: 40,
                              width: MediaQuery.of(context).size.width * 0.45,
                              child: Row(children: [
                                InkWell(
                                  onTap: () {
                                    setUpScreen(DashBoardOrderDetail.Food);
                                  },
                                  child: Column(children: [
                                    Expanded(
                                      child: SizedBox(
                                        width: 100,
                                        child: Center(
                                          child: Text(
                                            "MÓN ĂN",
                                            style: isFood
                                                ? textStyleTabLandscapeActive
                                                : textStyleTabLandscapeDeActive,
                                          ),
                                        ),
                                      ),
                                    ),
                                    isFood
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
                                    setUpScreen(DashBoardOrderDetail.Drink);
                                  },
                                  child: Column(children: [
                                    Expanded(
                                      child: SizedBox(
                                        width: 70,
                                        child: Center(
                                          child: Text(
                                            "ĐỒ UỐNG",
                                            style: isDrink
                                                ? textStyleTabLandscapeActive
                                                : textStyleTabLandscapeDeActive,
                                          ),
                                        ),
                                      ),
                                    ),
                                    isDrink
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
                                    setUpScreen(DashBoardOrderDetail.Other);
                                  },
                                  child: Column(children: [
                                    Expanded(
                                      child: SizedBox(
                                        width: 70,
                                        child: Center(
                                          child: Text(
                                            "KHÁC",
                                            style: isOther
                                                ? textStyleTabLandscapeActive
                                                : textStyleTabLandscapeDeActive,
                                          ),
                                        ),
                                      ),
                                    ),
                                    isOther
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
                                    setUpScreen(DashBoardOrderDetail.Gift);
                                  },
                                  child: Column(children: [
                                    Expanded(
                                      child: SizedBox(
                                        width: 70,
                                        child: Center(
                                          child: Text(
                                            "MÓN TẶNG",
                                            style: isGift
                                                ? textStyleTabLandscapeActive
                                                : textStyleTabLandscapeDeActive,
                                          ),
                                        ),
                                      ),
                                    ),
                                    isGift
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
                              ]),
                            ),
                          ),
                        ),
                        marginTop5,
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.62,
                          child: Container(
                            margin: const EdgeInsets.only(left: 5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Obx(() {
                              return ResponsiveGridList(
                                desiredItemWidth: 100,
                                minSpacing: 5,
                                children: List.generate(
                                    foodController.foodsToOrder.length,
                                    (index) {
                                  var food = foodController.foodsToOrder[index];
                                  if (food.category_code ==
                                      categoryCodeSelected) {
                                    return Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: const BoxDecoration(
                                        color: backgroundColor,
                                        borderRadius: borderContainer8,
                                      ),
                                      margin: const EdgeInsets.only(top: 10),
                                      child: Column(
                                        children: [
                                          //IMAGE
                                          food.image != ""
                                              ? ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  child: Image.network(
                                                    food.image ??
                                                        defaultFoodImageString,
                                                    width: 80,
                                                    height: 80,
                                                    fit: BoxFit.cover,
                                                  ),
                                                )
                                              : ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  child: defaultFoodImage80),
                                          //NAME
                                          Marquee(
                                              direction: Axis.horizontal,
                                              // textDirection: TextDirection.ltr,
                                              animationDuration:
                                                  const Duration(seconds: 1),
                                              backDuration: const Duration(
                                                  milliseconds: 4000),
                                              pauseDuration: const Duration(
                                                  milliseconds: 1000),
                                              directionMarguee:
                                                  DirectionMarguee.TwoDirection,
                                              child: RichText(
                                                  text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                      text: food.name,
                                                      style:
                                                          textStyleTabLandscapeLabel),
                                                  (Utils.isDateTimeInRange(
                                                          food
                                                              .temporary_price_from_date,
                                                          food
                                                              .temporary_price_to_date)
                                                      ? (food.price_with_temporary! >
                                                              0
                                                          ? const WidgetSpan(
                                                              child: Icon(
                                                                Icons
                                                                    .arrow_drop_up,
                                                                size: 10,
                                                                color:
                                                                    colorPriceIncrease,
                                                              ),
                                                            )
                                                          : const WidgetSpan(
                                                              child: Icon(
                                                                Icons
                                                                    .arrow_drop_down,
                                                                size: 10,
                                                                color:
                                                                    colorPriceDecrease,
                                                              ),
                                                            ))
                                                      : const TextSpan()),
                                                ],
                                              ))),
                                          food.price_with_temporary != 0
                                              ? (Utils.isDateTimeInRange(
                                                      food
                                                          .temporary_price_from_date,
                                                      food
                                                          .temporary_price_to_date)
                                                  ? Row(
                                                      children: <Widget>[
                                                        Expanded(
                                                          child: Marquee(
                                                              direction: Axis
                                                                  .horizontal,
                                                              // textDirection:
                                                              //     TextDirection.ltr,
                                                              animationDuration:
                                                                  const Duration(
                                                                      seconds:
                                                                          1),
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
                                                                  style: DefaultTextStyle.of(
                                                                          context)
                                                                      .style,
                                                                  children: <TextSpan>[
                                                                    TextSpan(
                                                                      text:
                                                                          "${Utils.formatCurrency(food.price + food.price_with_temporary!)} / ",
                                                                      style:
                                                                          textStyleTabLandscapeLabel,
                                                                    ),
                                                                    TextSpan(
                                                                      text: Utils
                                                                          .formatCurrency(
                                                                              food.price),
                                                                      style:
                                                                          textStyleTabLandscapeLabel,
                                                                    ),
                                                                  ],
                                                                ),
                                                              )),
                                                        ),
                                                      ],
                                                    )
                                                  : Text(
                                                      Utils.formatCurrency(
                                                          food.price),
                                                      style:
                                                          textStyleTabLandscapeLabel,
                                                    ))
                                              : Text(
                                                  Utils.formatCurrency(
                                                      food.price),
                                                  style: food.isSelected == true
                                                      ? textStyleWhiteBold16
                                                      : textStyleTabLandscapeLabel),
                                        ],
                                      ),
                                    );
                                  } else {
                                    return const SizedBox();
                                  }
                                }).toList(),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //RIGHT
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1,
                          child: Container(
                            margin: const EdgeInsets.only(
                              left: 5,
                            ),
                            padding: const EdgeInsets.only(
                              left: 5,
                              right: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const FaIcon(FontAwesomeIcons.fileInvoice,
                                      color: iconColor, size: 16),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'THÔNG TIN ĐƠN HÀNG',
                                    style: textStyleTabLandscapeLabel,
                                  ),
                                  const SizedBox(width: 16),
                                  const Text(
                                    'BÀN A11',
                                    style: textStyleTabLandscapeLabel,
                                  ),
                                  const Spacer(),
                                  InkWell(
                                    onTap: () => {Utils.myPop(context)},
                                    child: const FaIcon(FontAwesomeIcons.xmark,
                                        color: iconColor, size: 16),
                                  ),
                                ]),
                          ),
                        ),
                        marginTop5,
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                          child: Container(
                            margin: const EdgeInsets.only(
                              left: 5,
                            ),
                            padding: const EdgeInsets.only(
                              left: 5,
                              right: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          FaIcon(FontAwesomeIcons.user,
                                              color: iconColor, size: 10),
                                          marginRight5,
                                          Text(
                                            'Nguyễn Văn Hiền',
                                            style: textStyleTabLandscapeLabel,
                                          ),
                                        ]),
                                  ),
                                ),
                                Expanded(
                                  child: SizedBox(
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          FaIcon(FontAwesomeIcons.phone,
                                              color: iconColor, size: 10),
                                          marginRight5,
                                          Text(
                                            '0384319201',
                                            style: textStyleTabLandscapeLabel,
                                          ),
                                        ]),
                                  ),
                                ),
                                Expanded(
                                  child: SizedBox(
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          FaIcon(FontAwesomeIcons.userGroup,
                                              color: iconColor, size: 10),
                                          marginRight5,
                                          Text(
                                            '10',
                                            style: textStyleTabLandscapeLabel,
                                          ),
                                        ]),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        marginTop5,
                        //DANH SÁCH MÓN ĂN CỦA ĐƠN HÀNG
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: Container(
                              margin: const EdgeInsets.only(
                                left: 5,
                              ),
                              padding: const EdgeInsets.only(
                                left: 5,
                                right: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: orderController
                                      .orderDetail.order_details.length,
                                  itemBuilder: (context, index) {
                                    var orderDetail = orderController
                                        .orderDetail.order_details[index];
                                    return SizedBox(
                                      height: 50,
                                      child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            //Thông tin món ăn
                                            SizedBox(
                                              height: 50,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  //Hình ảnh
                                                  orderDetail.food!.image != ""
                                                      ? ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          child: Image.network(
                                                            orderDetail.food!
                                                                    .image ??
                                                                defaultFoodImageString,
                                                            width: 30,
                                                            height: 30,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        )
                                                      : ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          child:
                                                              defaultFoodImage30),
                                                  marginRight5,
                                                  //Tên món ăn
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      //TÊN MÓN
                                                      Text(
                                                          orderDetail
                                                              .food!.name,
                                                          style:
                                                              textStyleTabLandscapeLabel),
                                                      marginTop5,

                                                      //GIÁ TIỀN
                                                      orderDetail.is_gift ==
                                                              true
                                                          ? Text(
                                                              Utils.formatCurrency(
                                                                  orderDetail
                                                                      .price),
                                                              style:
                                                                  textStyleTabLandscapeLabel)
                                                          : const Icon(
                                                              Icons
                                                                  .card_giftcard,
                                                              color:
                                                                  colorWarning,
                                                              size: 10,
                                                            ),
                                                      marginTop5,
                                                      //TRẠNG THÍA MÓN
                                                      //TRONG BẾP
                                                      orderDetail.food_status ==
                                                              FOOD_STATUS_IN_CHEF
                                                          ? Text(
                                                              FOOD_STATUS_IN_CHEF_STRING,
                                                              style:
                                                                  textStyleCancelLandscape)
                                                          : const SizedBox(),
                                                      //ĐANG CHẾ BIẾN
                                                      orderDetail.food_status ==
                                                              FOOD_STATUS_COOKING
                                                          ? Text(
                                                              FOOD_STATUS_COOKING_STRING,
                                                              style:
                                                                  textStyleCookingLandscape)
                                                          : const SizedBox(),
                                                      //HOÀN THÀNH
                                                      orderDetail.food_status ==
                                                              FOOD_STATUS_FINISH
                                                          ? Text(
                                                              FOOD_STATUS_FINISH_STRING,
                                                              style:
                                                                  textStyleSeccessLandscape)
                                                          : const SizedBox(),
                                                      //ĐÃ HỦY
                                                      orderDetail.food_status ==
                                                              FOOD_STATUS_CANCEL
                                                          ? Text(
                                                              FOOD_STATUS_CANCEL_STRING,
                                                              style:
                                                                  textStyleCancelLandscape)
                                                          : const SizedBox()
                                                    ],
                                                  ),
                                                  //SỐ LƯỢNG - QUANTITY
                                                  (orderDetail.food_status ==
                                                          FOOD_STATUS_IN_CHEF)
                                                      ? SizedBox(
                                                          width: 100,
                                                          child: Row(
                                                            children: [
                                                              InkWell(
                                                                onTap: () {
                                                                  if (orderDetail
                                                                          .quantity >
                                                                      1) {
                                                                    setState(
                                                                        () {
                                                                      orderDetail
                                                                              .quantity =
                                                                          orderDetail.quantity -
                                                                              1;
                                                                    });
                                                                  }
                                                                },
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color:
                                                                        iconColor,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(5),
                                                                  ),
                                                                  height: 25,
                                                                  width: 25,
                                                                  child:
                                                                      const Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child: Icon(
                                                                        Icons
                                                                            .remove,
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  width: 5),
                                                              Text(
                                                                  orderDetail
                                                                      .quantity
                                                                      .toString(),
                                                                  style:
                                                                      textStyleTabLandscapeLabel),
                                                              const SizedBox(
                                                                  width: 5),
                                                              InkWell(
                                                                onTap: () {
                                                                  setState(() {
                                                                    orderDetail
                                                                            .quantity =
                                                                        orderDetail.quantity +
                                                                            1;
                                                                  });
                                                                },
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color:
                                                                        iconColor,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(5),
                                                                  ),
                                                                  height: 25,
                                                                  width: 25,
                                                                  child:
                                                                      const Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child: Icon(
                                                                        Icons
                                                                            .add,
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      : Text(
                                                          orderDetail.quantity
                                                              .toString(),
                                                          style:
                                                              textStyleTabLandscapeLabel),
                                                  //TỔNG TIỀN
                                                  SizedBox(
                                                    width: 100,
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                            Utils.formatCurrency(
                                                                orderDetail
                                                                        .price *
                                                                    orderDetail
                                                                        .quantity),
                                                            style: orderDetail
                                                                        .food_status !=
                                                                    FOOD_STATUS_IN_CHEF
                                                                ? textStyleSeccessLandscape
                                                                : textStyleTabLandscapeLabel),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ]),
                                    );
                                  })),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              marginTop5,
              //THANH TÁC VỤ
              Container(
                height: 45,
                color: backgroundColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {},
                      child: const CustomButtonIcon(
                          label: 'LỊCH SỬ ĐƠN HÀNG',
                          height: 40,
                          icon: FontAwesomeIcons.clockRotateLeft,
                          iconColor: secondColor,
                          backgroundColor: grayColor,
                          textStyle: TextStyle(
                            color: secondColor,
                            fontSize: 10,
                          )),
                    ),
                    InkWell(
                      onTap: () {},
                      child: const CustomButtonIcon(
                          label: 'MÓN KHÁC',
                          height: 40,
                          iconColor: secondColor,
                          icon: FontAwesomeIcons.plus,
                          backgroundColor: grayColor,
                          textStyle: TextStyle(
                            color: secondColor,
                            fontSize: 10,
                          )),
                    ),
                    InkWell(
                      onTap: () {},
                      child: const CustomButtonIcon(
                          label: 'PHỤ THU',
                          height: 40,
                          iconColor: secondColor,
                          icon: FontAwesomeIcons.plus,
                          backgroundColor: grayColor,
                          textStyle: TextStyle(
                            color: secondColor,
                            fontSize: 10,
                          )),
                    ),
                    InkWell(
                      onTap: () {},
                      child: const CustomButtonIcon(
                          label: 'LƯU',
                          height: 40,
                          icon: FontAwesomeIcons.check,
                          iconColor: secondColor,
                          backgroundColor: colorSuccess,
                          textStyle: TextStyle(
                            color: secondColor,
                            fontSize: 10,
                          )),
                    ),
                    InkWell(
                      onTap: () {},
                      child: const CustomButtonIcon(
                          label: 'CHỐT ĐƠN HÀNG',
                          height: 40,
                          icon: FontAwesomeIcons.sackDollar,
                          iconColor: secondColor,
                          backgroundColor: colorSuccess,
                          textStyle: TextStyle(
                            color: secondColor,
                            fontSize: 10,
                          )),
                    ),
                    InkWell(
                      onTap: () {},
                      child: const CustomButtonIcon(
                          label: 'THANH TOÁN',
                          height: 40,
                          icon: FontAwesomeIcons.sackDollar,
                          iconColor: secondColor,
                          backgroundColor: primaryColor,
                          textStyle: TextStyle(
                            color: secondColor,
                            fontSize: 10,
                          )),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
