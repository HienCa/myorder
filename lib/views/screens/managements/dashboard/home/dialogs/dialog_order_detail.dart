// ignore_for_file: non_constant_identifier_names, avoid_print, prefer_interpolation_to_compose_strings, constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/constants/app_constants.dart';
import 'package:myorder/controllers/bills/bills_controller.dart';
import 'package:myorder/controllers/foods/foods_controller.dart';
import 'package:myorder/controllers/orders/orders_controller.dart';
import 'package:myorder/models/food.dart';
import 'package:myorder/models/order.dart';
import 'package:myorder/models/order_detail.dart';
import 'package:myorder/utils.dart';
import 'package:myorder/views/screens/managements/dashboard/home/dialogs/dialog_change_table_booking.dart';
import 'package:myorder/views/screens/managements/dashboard/home/dialogs/dialog_confirm_update_new_quantity.dart';
import 'package:myorder/views/screens/managements/dashboard/home/dialogs/dialog_order_history.dart';
import 'package:myorder/views/screens/order/orderdetail/dialogs/dialog_confirm_finish_foos.dart';
import 'package:myorder/views/screens/payment/dialog_decrease_price.dart';
import 'package:myorder/views/widgets/buttons/button_icon.dart';
import 'package:myorder/views/widgets/dialogs.dart';
import 'package:myorder/views/widgets/dialogs/dialog_choose_price_calculator_int.dart';
import 'package:myorder/views/widgets/icons/icon_close.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

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
  BillController billController = Get.put(BillController());

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
    orderController.getTotalAmountById(widget.order);
    foodController.getfoodsToOrder(keySearch, defaultCategory);

    //set up checkbox
    isCheckedGTGT = widget.order.is_vat == ACTIVE ? true : false;
    isCheckedDecrease = widget.order.is_discount == ACTIVE ? true : false;
    isSurcharge = widget.order.total_surcharge_amount > 0 ? true : false;
  }

  //Giảm giá
  bool isCheckedChooseTypeDiscrease = false;
  bool isCheckedGTGT = false;
  bool isCheckedDecrease = false;
  bool isSurcharge = false;

  //Tabbar
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
                  //GỌI MÓN - GỢI Ý
                  Expanded(
                    child: Column(
                      children: [
                        Container(
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
                        //DANH SÁCH MÓN CẦN ORDER
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
                                  if (categoryCodeSelected == CATEGORY_GIFT) {
                                    return InkWell(
                                      onTap: () => {
                                        //Khi nhấn chọn thì sẽ thêm vào danh sách bên món ăn,
                                        //Khi món đã được chọn rồi thì sẽ tăng số lượng
                                        //Xóa món đã thêm bên giao diện order detail
                                        setState(() {
                                          if (food.isSelected == false) {
                                            food.isSelected = true;
                                          } else {
                                            food.quantity =
                                                (food.quantity ?? 1) + 1;
                                          }
                                          //Nếu ở tab
                                          if (isGift == true) {
                                            food.isGift = true;
                                          } else {
                                            food.isGift = false;
                                          }

                                          print(
                                              "THÊM MÓN: ${food.name} - SL: ${food.quantity}");
                                        })
                                      },
                                      child: Container(
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
                                                        BorderRadius.circular(
                                                            5),
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
                                                        BorderRadius.circular(
                                                            5),
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
                                                    DirectionMarguee
                                                        .TwoDirection,
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
                                                                  text:
                                                                      TextSpan(
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
                                                                        text: Utils.formatCurrency(
                                                                            food.price),
                                                                        style:
                                                                            textStyleLandscapeTemporaryPriceActive,
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
                                                    style:
                                                        textStyleTabLandscapeLabel),
                                          ],
                                        ),
                                      ),
                                    );
                                  } else if (food.category_code ==
                                          categoryCodeSelected &&
                                      categoryCodeSelected != CATEGORY_GIFT) {
                                    return InkWell(
                                      onTap: () => {
                                        //Khi nhấn chọn thì sẽ thêm vào danh sách bên món ăn,
                                        //Khi món đã được chọn rồi thì sẽ tăng số lượng
                                        //Xóa món đã thêm bên giao diện order detail
                                        setState(() {
                                          if (food.isSelected == false) {
                                            food.isSelected = true;
                                          } else {
                                            food.quantity =
                                                (food.quantity ?? 1) + 1;
                                          }
                                          //Nếu ở tab
                                          if (isGift == true) {
                                            food.isGift = true;
                                          } else {
                                            food.isGift = false;
                                          }

                                          print(
                                              "THÊM MÓN: ${food.name} - SL: ${food.quantity}");
                                        })
                                      },
                                      child: Container(
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
                                                        BorderRadius.circular(
                                                            5),
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
                                                        BorderRadius.circular(
                                                            5),
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
                                                    DirectionMarguee
                                                        .TwoDirection,
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
                                                                  text:
                                                                      TextSpan(
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
                                                                        text: Utils.formatCurrency(
                                                                            food.price),
                                                                        style:
                                                                            textStyleLandscapeTemporaryPriceActive,
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
                                                    style:
                                                        textStyleTabLandscapeLabel),
                                          ],
                                        ),
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
                                  InkWell(
                                    onTap: () => {
                                      //show dialog
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return MyDialogChangeTableBooking(
                                            order: orderController.orderDetail,
                                          );
                                        },
                                      )
                                    },
                                    child: Text(
                                      '${widget.order.table!.name} - Số lượng tối đa: ${widget.order.table!.total_slot} khách',
                                      style: textStyleTabLandscapeLabelBold,
                                    ),
                                  ),
                                  const Spacer(),
                                  InkWell(
                                      onTap: () => {Utils.myPop(context)},
                                      child: const MyCloseIcon(
                                          heightWidth: 30, sizeIcon: 16)),
                                  const SizedBox(width: 4),
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
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const FaIcon(FontAwesomeIcons.user,
                                              color: iconColor, size: 10),
                                          marginRight5,
                                          Text(
                                            widget.order.customer_name,
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
                                          const FaIcon(FontAwesomeIcons.phone,
                                              color: iconColor, size: 10),
                                          marginRight5,
                                          Text(
                                            widget.order.customer_phone,
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
                                            MainAxisAlignment.end,
                                        children: [
                                          const FaIcon(
                                              FontAwesomeIcons.userGroup,
                                              color: iconColor,
                                              size: 10),
                                          marginRight5,
                                          Text(
                                            '${widget.order.total_slot}',
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
                          height: MediaQuery.of(context).size.height * 0.3,
                          width: MediaQuery.of(context).size.width * 0.5,
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
                              child: Obx(() {
                                print("SỐ MÓN MUỐN THÊM");
                                print(Utils.counterSelected(
                                    foodController.foods));
                                //Nếu không order thêm
                                return (Utils.counterSelected(
                                            foodController.foodsToOrder) ==
                                        0)
                                    ? ListView.builder(
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
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  //Thông tin món ăn
                                                  SizedBox(
                                                    height: 50,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.43,
                                                    child: Row(
                                                      children: [
                                                        //Hình ảnh - Tên món ăn
                                                        SizedBox(
                                                          height: 50,
                                                          width: 150,
                                                          child: Row(
                                                            children: [
                                                              //Hình ảnh
                                                              orderDetail.food!
                                                                          .image !=
                                                                      ""
                                                                  ? ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5),
                                                                      child: Image
                                                                          .network(
                                                                        orderDetail.food!.image ??
                                                                            defaultFoodImageString,
                                                                        width:
                                                                            30,
                                                                        height:
                                                                            30,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    )
                                                                  : ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5),
                                                                      child:
                                                                          defaultFoodImage30),
                                                              marginRight5,
                                                              Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  //TÊN MÓN

                                                                  Marquee(
                                                                      direction:
                                                                          Axis
                                                                              .horizontal,
                                                                      textDirection:
                                                                          TextDirection
                                                                              .ltr,
                                                                      animationDuration: const Duration(
                                                                          seconds:
                                                                              1),
                                                                      backDuration: const Duration(
                                                                          milliseconds:
                                                                              4000),
                                                                      pauseDuration: const Duration(
                                                                          milliseconds:
                                                                              1000),
                                                                      directionMarguee:
                                                                          DirectionMarguee
                                                                              .TwoDirection,
                                                                      child: RichText(
                                                                          text: TextSpan(
                                                                        children: [
                                                                          TextSpan(
                                                                              text: orderDetail.food!.name,
                                                                              style: textStyleTabLandscapeLabel),
                                                                        ],
                                                                      ))),

                                                                  marginTop5,

                                                                  //GIÁ TIỀN
                                                                  orderDetail.is_gift ==
                                                                          false
                                                                      ? Text(
                                                                          Utils.formatCurrency(orderDetail
                                                                              .price),
                                                                          style:
                                                                              textStyleTabLandscapeLabel)
                                                                      : const Icon(
                                                                          Icons
                                                                              .card_giftcard,
                                                                          color:
                                                                              colorWarning,
                                                                          size:
                                                                              10,
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
                                                            ],
                                                          ),
                                                        ),
                                                        const Spacer(),

                                                        //SỐ LƯỢNG - QUANTITY
                                                        (orderDetail.food_status ==
                                                                FOOD_STATUS_IN_CHEF)
                                                            ? SizedBox(
                                                                child: Row(
                                                                  children: [
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        if (orderDetail.new_quantity >
                                                                            1) {
                                                                          setState(
                                                                              () {
                                                                            orderDetail.new_quantity =
                                                                                orderDetail.new_quantity - 1;

                                                                            if (orderDetail.quantity !=
                                                                                orderDetail.new_quantity) {
                                                                              orderDetail.isSelected = true;
                                                                            } else {
                                                                              orderDetail.isSelected = false;
                                                                            }
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
                                                                              BorderRadius.circular(5),
                                                                        ),
                                                                        height:
                                                                            25,
                                                                        width:
                                                                            25,
                                                                        child:
                                                                            const Align(
                                                                          alignment:
                                                                              Alignment.center,
                                                                          child: Icon(
                                                                              Icons.remove,
                                                                              color: Colors.white),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                        width:
                                                                            5),
                                                                    orderDetail.quantity ==
                                                                            orderDetail.new_quantity
                                                                        ? InkWell(
                                                                            onTap:
                                                                                () async {
                                                                              final result = await showDialog(
                                                                                context: context,
                                                                                builder: (BuildContext context) {
                                                                                  return MyDialogCalculatorInt(
                                                                                    value: orderDetail.quantity, label: '', min: 1, max:  MAX_PRICE,
                                                                                  );
                                                                                },
                                                                              );
                                                                              if (result != null) {
                                                                                orderDetail.new_quantity = int.parse(result);

                                                                                setState(() {});
                                                                              }
                                                                            },
                                                                            child:
                                                                                Text(orderDetail.quantity.toString(), style: textStyleTabLandscapeLabel),
                                                                          )
                                                                        : InkWell(
                                                                            onTap:
                                                                                () async {
                                                                              final result = await showDialog(
                                                                                context: context,
                                                                                builder: (BuildContext context) {
                                                                                  return MyDialogCalculatorInt(
                                                                                    value: orderDetail.new_quantity, label: '', min: 1, max:  MAX_PRICE,
                                                                                  );
                                                                                },
                                                                              );
                                                                              if (result != null) {
                                                                                orderDetail.new_quantity = int.parse(result);

                                                                                setState(() {});
                                                                              }
                                                                            },
                                                                            child:
                                                                                Text(orderDetail.new_quantity.toString(), style: textStyleTabLandscapeLabel),
                                                                          ),
                                                                    const SizedBox(
                                                                        width:
                                                                            5),
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          orderDetail.new_quantity =
                                                                              orderDetail.new_quantity + 1;

                                                                          if (orderDetail.quantity !=
                                                                              orderDetail.new_quantity) {
                                                                            orderDetail.isSelected =
                                                                                true;
                                                                          } else {
                                                                            orderDetail.isSelected =
                                                                                false;
                                                                          }
                                                                        });
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              iconColor,
                                                                          borderRadius:
                                                                              BorderRadius.circular(5),
                                                                        ),
                                                                        height:
                                                                            25,
                                                                        width:
                                                                            25,
                                                                        child:
                                                                            const Align(
                                                                          alignment:
                                                                              Alignment.center,
                                                                          child: Icon(
                                                                              Icons.add,
                                                                              color: Colors.white),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            : Text(
                                                                orderDetail
                                                                    .quantity
                                                                    .toString(),
                                                                style:
                                                                    textStyleTabLandscapeLabel),
                                                        const Spacer(),
                                                        //TỔNG TIỀN
                                                        SizedBox(
                                                          width: orderDetail
                                                                      .food_status ==
                                                                  FOOD_STATUS_IN_CHEF
                                                              ? 80
                                                              : 40,
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              const Spacer(),
                                                              Text(
                                                                  Utils.formatCurrency(orderDetail
                                                                          .price *
                                                                      (Utils.counterSelected(orderController.orderDetail.order_details) > 0
                                                                          ? orderDetail
                                                                              .new_quantity
                                                                          : orderDetail
                                                                              .quantity)),
                                                                  style: orderDetail
                                                                              .food_status !=
                                                                          FOOD_STATUS_IN_CHEF
                                                                      ? textStyleSeccessLandscape
                                                                      : textStyleTabLandscapeLabel),
                                                              orderDetail.food_status ==
                                                                      FOOD_STATUS_IN_CHEF
                                                                  ? const Spacer()
                                                                  : const SizedBox(),
                                                              orderDetail.food_status ==
                                                                      FOOD_STATUS_IN_CHEF
                                                                  ? InkWell(
                                                                      onTap:
                                                                          () =>
                                                                              {
                                                                        //Hủy món
                                                                        showCustomAlertDialogConfirm(
                                                                          context,
                                                                          "YÊU CẦU HỦY MÓN",
                                                                          "Có chắc chắn muốn hủy món \"${orderDetail.food!.name}\" ?",
                                                                          colorWarning,
                                                                          () async {
                                                                            orderController.cancelFoodByOrder(
                                                                                context,
                                                                                widget.order,
                                                                                orderDetail);
                                                                          },
                                                                        ),
                                                                      },
                                                                      child: const FaIcon(
                                                                          FontAwesomeIcons
                                                                              .xmark,
                                                                          color:
                                                                              colorCancel,
                                                                          size:
                                                                              16),
                                                                    )
                                                                  : const SizedBox(),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ]),
                                          );
                                        })
                                    :
                                    //MÓN ĂN CẦN THÊM - THÊM MÓN
                                    ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        itemCount:
                                            foodController.foodsToOrder.length,
                                        itemBuilder: (context, index) {
                                          return foodController
                                                      .foodsToOrder[index]
                                                      .isSelected ==
                                                  true
                                              ? SizedBox(
                                                  height: 50,
                                                  child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        //Thông tin món ăn
                                                        SizedBox(
                                                          height: 50,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.43,
                                                          child: Row(
                                                            children: [
                                                              //Hình ảnh - Tên món ăn
                                                              SizedBox(
                                                                height: 50,
                                                                width: 150,
                                                                child: Row(
                                                                  children: [
                                                                    //Hình ảnh
                                                                    foodController.foodsToOrder[index].image !=
                                                                            ""
                                                                        ? ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(5),
                                                                            child:
                                                                                Image.network(
                                                                              foodController.foodsToOrder[index].image ?? defaultFoodImageString,
                                                                              width: 30,
                                                                              height: 30,
                                                                              fit: BoxFit.cover,
                                                                            ),
                                                                          )
                                                                        : ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(5),
                                                                            child: defaultFoodImage30),
                                                                    marginRight5,
                                                                    Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        //TÊN MÓN

                                                                        Marquee(
                                                                            direction:
                                                                                Axis.horizontal,
                                                                            textDirection: TextDirection.ltr,
                                                                            animationDuration: const Duration(seconds: 1),
                                                                            backDuration: const Duration(milliseconds: 4000),
                                                                            pauseDuration: const Duration(milliseconds: 1000),
                                                                            directionMarguee: DirectionMarguee.TwoDirection,
                                                                            child: RichText(
                                                                                text: TextSpan(
                                                                              children: [
                                                                                TextSpan(text: foodController.foodsToOrder[index].name, style: textStyleTabLandscapeLabel),
                                                                              ],
                                                                            ))),

                                                                        marginTop5,

                                                                        //GIÁ TIỀN
                                                                        foodController.foodsToOrder[index].isGift ==
                                                                                false
                                                                            ? (Utils.isDateTimeInRange(foodController.foodsToOrder[index].temporary_price_from_date, foodController.foodsToOrder[index].temporary_price_to_date)
                                                                                ? Text(Utils.formatCurrency(((foodController.foodsToOrder[index].price_with_temporary ?? 0) + foodController.foodsToOrder[index].price)), style: textStyleTabLandscapeLabel)
                                                                                : Text(Utils.formatCurrency(foodController.foodsToOrder[index].price), style: textStyleTabLandscapeLabel))
                                                                            : const Icon(
                                                                                Icons.card_giftcard,
                                                                                color: colorWarning,
                                                                                size: 10,
                                                                              ),
                                                                        marginTop5,
                                                                        //TRẠNG THÁI MÓN
                                                                        const Text(
                                                                            'CHƯA LƯU',
                                                                            style:
                                                                                textStyleCancelLandscape)
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              const Spacer(),

                                                              //SỐ LƯỢNG - QUANTITY
                                                              SizedBox(
                                                                child: Row(
                                                                  children: [
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        if ((foodController.foodsToOrder[index].quantity ??
                                                                                0) >
                                                                            1) {
                                                                          setState(
                                                                              () {
                                                                            foodController.foodsToOrder[index].quantity =
                                                                                (foodController.foodsToOrder[index].quantity ?? 0) - 1;
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
                                                                              BorderRadius.circular(5),
                                                                        ),
                                                                        height:
                                                                            25,
                                                                        width:
                                                                            25,
                                                                        child:
                                                                            const Align(
                                                                          alignment:
                                                                              Alignment.center,
                                                                          child: Icon(
                                                                              Icons.remove,
                                                                              color: Colors.white),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                        width:
                                                                            5),
                                                                    Text(
                                                                        foodController
                                                                            .foodsToOrder[
                                                                                index]
                                                                            .quantity
                                                                            .toString(),
                                                                        style:
                                                                            textStyleTabLandscapeLabel),
                                                                    const SizedBox(
                                                                        width:
                                                                            5),
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          foodController
                                                                              .foodsToOrder[index]
                                                                              .quantity = (foodController.foodsToOrder[index].quantity ?? 0) + 1;
                                                                        });
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              iconColor,
                                                                          borderRadius:
                                                                              BorderRadius.circular(5),
                                                                        ),
                                                                        height:
                                                                            25,
                                                                        width:
                                                                            25,
                                                                        child:
                                                                            const Align(
                                                                          alignment:
                                                                              Alignment.center,
                                                                          child: Icon(
                                                                              Icons.add,
                                                                              color: Colors.white),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),

                                                              const Spacer(),
                                                              //TỔNG TIỀN
                                                              SizedBox(
                                                                width: 80,
                                                                child: Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    const Spacer(),
                                                                    foodController.foodsToOrder[index].isGift ==
                                                                            false
                                                                        ? (Utils.isDateTimeInRange(foodController.foodsToOrder[index].temporary_price_from_date, foodController.foodsToOrder[index].temporary_price_to_date)
                                                                            ? Text(Utils.formatCurrency(((foodController.foodsToOrder[index].price_with_temporary ?? 0) + foodController.foodsToOrder[index].price) * (foodController.foodsToOrder[index].quantity ?? 0)),
                                                                                style:
                                                                                    textStyleTabLandscapeLabel)
                                                                            : Text(Utils.formatCurrency(foodController.foodsToOrder[index].price * (foodController.foodsToOrder[index].quantity ?? 0)),
                                                                                style:
                                                                                    textStyleTabLandscapeLabel))
                                                                        : const Text(
                                                                            '0',
                                                                            style:
                                                                                textStyleTabLandscapeLabel),
                                                                    const Spacer(),
                                                                    InkWell(
                                                                      onTap:
                                                                          () =>
                                                                              {
                                                                        //Hủy món gọi thêm
                                                                        showCustomAlertDialogConfirm(
                                                                          context,
                                                                          "YÊU CẦU HỦY GỌI MÓN",
                                                                          "Bạn không muốn gọi món \"${foodController.foodsToOrder[index].name}\" ?",
                                                                          colorWarning,
                                                                          () async {
                                                                            setState(() {
                                                                              foodController.foodsToOrder[index].isSelected = false;
                                                                            });
                                                                          },
                                                                        ),
                                                                      },
                                                                      child: const FaIcon(
                                                                          FontAwesomeIcons
                                                                              .xmark,
                                                                          color:
                                                                              colorCancel,
                                                                          size:
                                                                              16),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ]),
                                                )
                                              : const SizedBox();
                                        });
                              })),
                        ),
                        marginTop5,
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.25,
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
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(children: [
                                //SURCHARGE - PHỤ THU
                                Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 95,
                                        height: 20,
                                        child: Row(
                                          children: [
                                            Theme(
                                              data: ThemeData(
                                                  unselectedWidgetColor:
                                                      iconColor),
                                              child: Transform.scale(
                                                scale: 0.8,
                                                child: Checkbox(
                                                  value: isSurcharge,
                                                  onChanged: (bool? value) {},
                                                  activeColor: iconColor,
                                                  visualDensity:
                                                      VisualDensity.compact,
                                                ),
                                              ),
                                            ),
                                            marginRight5,
                                            const Text(
                                              "PHỤ THU",
                                              style: textStyleTabLandscapeLabel,
                                            )
                                          ],
                                        ),
                                      ),

                                      const Spacer(),
                                      //Số tiền đã thu - phụ thu
                                      Obx(() {
                                        return Text(
                                            Utils.formatCurrency(orderController
                                                .order.total_surcharge_amount),
                                            style: textStyleTabLandscapeLabel);
                                      })
                                    ]),

                                //VAT
                                Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 65,
                                        height: 20,
                                        child: Row(
                                          children: [
                                            Theme(
                                              data: ThemeData(
                                                  unselectedWidgetColor:
                                                      primaryColor),
                                              child: Transform.scale(
                                                scale: 0.8,
                                                child: Checkbox(
                                                  value: isCheckedGTGT,
                                                  onChanged: (bool? value) {
                                                    if (orderController
                                                            .orderDetail
                                                            .total_amount >
                                                        0) {
                                                      setState(() {
                                                        isCheckedGTGT = value!;
                                                        print(isCheckedGTGT);
                                                        // áp dụng thue
                                                        if (isCheckedGTGT) {
                                                          orderController.applyVat(
                                                              context,
                                                              orderController
                                                                  .orderDetail,
                                                              orderController
                                                                  .orderDetail
                                                                  .order_details);
                                                        } else {
                                                          orderController.cancelVat(
                                                              context,
                                                              orderController
                                                                  .orderDetail,
                                                              orderController
                                                                  .orderDetail
                                                                  .order_details);
                                                        }
                                                      });
                                                    } else {
                                                      Utils.showStylishDialog(
                                                          context,
                                                          'THÔNG BÁO',
                                                          'Hóa đơn này chưa đủ điều kiện áp dụng VAT.',
                                                          StylishDialogType
                                                              .INFO);
                                                    }
                                                  },
                                                  activeColor: primaryColor,
                                                  visualDensity:
                                                      VisualDensity.compact,
                                                ),
                                              ),
                                            ),
                                            marginRight5,
                                            const Text(
                                              "VAT",
                                              style: textStyleTabLandscapeLabel,
                                            )
                                          ],
                                        ),
                                      ),
                                      const Spacer(),
                                      Obx(() {
                                        return orderController
                                                    .order.total_vat_amount >
                                                0
                                            ? Text(
                                                "$VAT_PERCENT%",
                                                style:
                                                    textStyleTabLandscapeLabel,
                                              )
                                            : const SizedBox();
                                      }),
                                      const Spacer(),
                                      //Số tiền thuế đã áp dụng
                                      Obx(() {
                                        return Text(
                                            Utils.formatCurrency(orderController
                                                .order.total_vat_amount),
                                            style: textStyleTabLandscapeLabel);
                                      })
                                    ]),

                                //DISCOUNT
                                Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 95,
                                        height: 20,
                                        child: Row(
                                          children: [
                                            Theme(
                                              data: ThemeData(
                                                  unselectedWidgetColor:
                                                      primaryColor),
                                              child: Transform.scale(
                                                scale: 0.8,
                                                child: Checkbox(
                                                  value: isCheckedDecrease,
                                                  onChanged: (bool? value) {
                                                    if (orderController
                                                            .orderDetail
                                                            .total_amount >
                                                        0) {
                                                      setState(() {
                                                        isCheckedDecrease =
                                                            value!;
                                                        //Hủy DISCOUNT khi nhấn uncheck checkbox
                                                        if (isCheckedDecrease ==
                                                            false) {
                                                          orderController.cancelDiscount(
                                                              context,
                                                              orderController
                                                                  .orderDetail,
                                                              orderController
                                                                  .orderDetail
                                                                  .order_details);
                                                        }
                                                        // bật popup
                                                        if (isCheckedDecrease) {
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return CustomDialogDecreasePrice(
                                                                order: orderController
                                                                    .orderDetail,
                                                              );
                                                            },
                                                          );
                                                        }
                                                      });
                                                    } else {
                                                      Utils.showStylishDialog(
                                                          context,
                                                          'THÔNG BÁO',
                                                          'Hóa đơn này hiện tại không thể áp dụng giảm giá.',
                                                          StylishDialogType
                                                              .INFO);
                                                    }
                                                  },
                                                  activeColor: primaryColor,
                                                  visualDensity:
                                                      VisualDensity.compact,
                                                ),
                                              ),
                                            ),
                                            marginRight5,
                                            const Text(
                                              "GIẢM GIÁ",
                                              style: textStyleTabLandscapeLabel,
                                            )
                                          ],
                                        ),
                                      ),

                                      const Spacer(),
                                      //Số tiền đã giảm
                                      Obx(() {
                                        return Text(
                                            Utils.formatCurrency(orderController
                                                .order.total_discount_amount),
                                            style: textStyleTabLandscapeLabel);
                                      })
                                    ]),
                                marginTop10,
                                //TỔNG GIẢM TRỪ
                                Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Spacer(),

                                      const Column(
                                        children: [
                                          Text(
                                            "TỔNG GIẢM TRỪ",
                                            style: textStyleSecondLandscapeBold,
                                          ),
                                          Text(
                                            "(GỒM GIẢM GIÁ, ĐẶT CỌC)",
                                            style: textStyleSecondLandscape,
                                          ),
                                        ],
                                      ),

                                      const Spacer(),
                                      //Tổng giảm trừ
                                      Obx(() {
                                        return Text(
                                            Utils.formatCurrency(orderController
                                                    .order
                                                    .total_discount_amount +
                                                orderController
                                                    .order.deposit_amount),
                                            style:
                                                textStyleSecondLandscapeBold);
                                      })
                                    ]),
                                marginTop10,

                                //TỔNG THANH TOÁN
                                Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Spacer(),

                                      const Text(
                                        "TỔNG THANH TOÁN",
                                        style: textStylePrimaryLandscapeBold,
                                      ),

                                      const Spacer(),
                                      //Tổng thanh toán
                                      Obx(() {
                                        return Text(
                                            Utils.formatCurrency(orderController
                                                    .order.total_amount -
                                                orderController
                                                    .order.deposit_amount),
                                            style:
                                                textStylePrimaryLandscapeBold);
                                      })
                                    ]),
                                marginTop10,
                              ]),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              marginTop5,
              //THANH TÁC VỤ
              Obx(() {
                return Container(
                  height: 45,
                  color: backgroundColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () async {
                          //Lịch sử đơn hàng
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return MyDialogOrderHistory(
                                order: widget.order,
                              );
                            },
                          );
                        },
                        child: const CustomButtonIcon(
                            label: 'LỊCH SỬ ĐƠN HÀNG',
                            height: 40,
                            icon: FontAwesomeIcons.clockRotateLeft,
                            iconColor: secondColor,
                            backgroundColor: blueColor,
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
                      Utils.counterSelected(foodController.foodsToOrder) == 0
                          ?
                          //LƯU CHỈNH SỬA SỐ LƯỢNG MÓN TRONG ĐƠN HÀNG ĐÃ ĐƯỢC ORDER
                          InkWell(
                              onTap: () async {
                                final result = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CustomDialogUpdateNewQuantityTable(
                                      order: widget.order,
                                    );
                                  },
                                );
                                if (result == 'success') {
                                  setState(() {
                                    Utils.refeshSelected(orderController
                                        .orderDetail.order_details);

                                    Utils.showStylishDialog(
                                        context,
                                        'THÀNH CÔNG',
                                        'Số lượng món đã được cập nhật!',
                                        StylishDialogType.SUCCESS);
                                  });
                                }
                              },
                              child: CustomButtonIcon(
                                  label: Utils.counterSelected(orderController
                                              .orderDetail.order_details) >
                                          0
                                      ? 'LƯU (${Utils.counterSelected(orderController.orderDetail.order_details)})'
                                      : 'LƯU',
                                  height: 40,
                                  icon: FontAwesomeIcons.check,
                                  iconColor: secondColor,
                                  backgroundColor: Utils.counterSelected(
                                              orderController
                                                  .orderDetail.order_details) >
                                          0
                                      ? colorSuccess
                                      : grayColor,
                                  textStyle: const TextStyle(
                                    color: secondColor,
                                    fontSize: 10,
                                  )),
                            )
                          :
                          //LƯU THÊM MÓN MỚI
                          InkWell(
                              onTap: () {
                                List<OrderDetail> orderDetailList =
                                    []; // danh sach cac mon khi order
                                print(
                                    "================MÓN CẦN ORDER===================");
                                bool isGift = false;
                                for (var foodOrder
                                    in foodController.foodsToOrder) {
                                  if (foodOrder.isSelected == true) {
                                    //chi tiet don hang
                                    //Nếu món ăn có giá thời vụ thì lấy giá thời vụ, ngược lại lấy giá gốc
                                    Food foodDetail = Food.empty();
                                    foodDetail.name = foodOrder.name;
                                    foodDetail.food_combo_details =
                                        foodOrder.food_combo_details;
                                    foodDetail.addition_food_details =
                                        foodOrder.addition_food_details;

                                    OrderDetail orderDetail = OrderDetail(
                                        order_detail_id: "",
                                        price: Utils.isDateTimeInRange(
                                                foodOrder
                                                    .temporary_price_from_date,
                                                foodOrder
                                                    .temporary_price_to_date)
                                            ? (foodOrder.price +
                                                foodOrder.price_with_temporary!)
                                            : foodOrder.price,
                                        quantity: foodOrder.quantity!,
                                        food_status: FOOD_STATUS_IN_CHEF,
                                        food_id: foodOrder.food_id,
                                        is_gift: (foodOrder.isGift ?? false),
                                        category_id: '',
                                        category_code: foodOrder.category_code,
                                        chef_bar_status: CHEF_BAR_STATUS,
                                        is_addition: false,
                                        food: foodDetail);
                                    //MÓN TẶNG
                                    if (orderDetail.is_gift == true) {
                                      orderDetail.price = 0;
                                      isGift = true;
                                    }

                                    orderDetailList.add(orderDetail);

                                    //show thong tin console
                                    print("--------------------------------");
                                    print("ID: ${foodOrder.food_id}");
                                    print("Name: ${foodOrder.name}");
                                    print("Price: ${foodOrder.price}");
                                    print("Quantity: ${foodOrder.quantity}");
                                    print(
                                        "Is Selected: ${foodOrder.isSelected}");
                                    print("--------------------------------");
                                  }

                                  //Món bán kèm nếu chọn
                                  for (var additionFood
                                      in foodOrder.addition_food_details) {
                                    if (additionFood.isSelected == true) {
                                      //chi tiet don hang
                                      //Nếu món ăn có giá thời vụ thì lấy giá thời vụ, ngược lại lấy giá gốc
                                      OrderDetail orderDetail = OrderDetail(
                                        order_detail_id: "",
                                        price: Utils.isDateTimeInRange(
                                                additionFood
                                                    .temporary_price_from_date,
                                                additionFood
                                                    .temporary_price_to_date)
                                            ? (additionFood.price +
                                                additionFood
                                                    .price_with_temporary!)
                                            : additionFood.price,
                                        quantity: additionFood.quantity!,
                                        food_status: FOOD_STATUS_IN_CHEF,
                                        food_id: additionFood.food_id,
                                        is_gift: false,
                                        category_id: '',
                                        category_code:
                                            additionFood.category_code,
                                        chef_bar_status: CHEF_BAR_STATUS,
                                        is_addition: true,
                                      );

                                      orderDetailList.add(orderDetail);

                                      //show thong tin console
                                      print("--------------------------------");
                                      print("ID: ${additionFood.food_id}");
                                      print("Name: ${additionFood.name}");
                                      print("Price: ${additionFood.price}");
                                      print(
                                          "Quantity: ${additionFood.quantity}");
                                      print(
                                          "Is Selected: ${additionFood.isSelected}");
                                      print("--------------------------------");
                                    }
                                  }
                                }
                                print(
                                    "================HẾT MÓN CẦN ORDER===================");

                                showCustomAlertDialogConfirm(
                                  context,
                                  "GỌI THÊM MÓN",
                                  "Bạn bạn muốn gọi thêm món cho bàn ${widget.order.table!.name} ?",
                                  colorInformation,
                                  () async {
                                    // order theo table_id
                                    //false: món tặng sẽ được set price = 0 trước;
                                    orderController.createOrder(
                                        orderController
                                            .orderDetail.table!.table_id,
                                        orderController.orderDetail.table!.name,
                                        orderDetailList,
                                        isGift,
                                        context,
                                        orderController.order.total_slot);
                                  },
                                );
                              },
                              child: CustomButtonIcon(
                                  label: Utils.counterSelected(
                                              foodController.foodsToOrder) >
                                          0
                                      ? 'THÊM MÓN (${Utils.counterSelected(foodController.foodsToOrder)})'
                                      : 'THÊM MÓN',
                                  height: 40,
                                  icon: FontAwesomeIcons.check,
                                  iconColor: secondColor,
                                  backgroundColor: Utils.counterSelected(
                                              foodController.foodsToOrder) >
                                          0
                                      ? colorSuccess
                                      : grayColor,
                                  textStyle: const TextStyle(
                                    color: secondColor,
                                    fontSize: 10,
                                  )),
                            ),
                      InkWell(
                        onTap: () async {
                          //Món phải ở trạng thái chờ cooking và không ở tình trạng đang gọi thêm món
                          if (Utils.isAnyFoodCooking(
                                  orderController.orderDetail.order_details) &&
                              (Utils.counterSelected(
                                      foodController.foodsToOrder) ==
                                  0)) {
                            final result = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CustomDialogFinishFoods(
                                  order: orderController.orderDetail,
                                );
                              },
                            );
                            if (result == 'success') {
                              setState(() {
                                Utils.showStylishDialog(
                                    context,
                                    'BẾP/BAR',
                                    'Yêu cầu dừng chế biến thành công!',
                                    StylishDialogType.SUCCESS);
                              });
                            }
                          }
                        },
                        child: CustomButtonIcon(
                            label: 'HOÀN TẤT MÓN',
                            height: 40,
                            icon: FontAwesomeIcons.paperPlane,
                            iconColor: secondColor,
                            backgroundColor: (Utils.isAnyFoodCooking(
                                            orderController
                                                .orderDetail.order_details) ==
                                        true &&
                                    Utils.counterSelected(
                                            foodController.foodsToOrder) ==
                                        0)
                                ? colorWarning
                                : grayColor,
                            textStyle: const TextStyle(
                              color: secondColor,
                              fontSize: 10,
                            )),
                      ),
                      InkWell(
                        onTap: () async {
                          if (Utils.isAnyFoodCooking(
                              orderController.orderDetail.order_details)) {
                            Utils.showStylishDialog(
                                context,
                                'THÔNG BÁO',
                                'Có một số món chưa được gửi Bếp/Bar. Vui lòng gửi bếp trước khi tiến hành thanh toán.',
                                StylishDialogType.INFO);
                          } else {
                            final result = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: backgroundColor,
                                  title: const Center(
                                      child: Text(
                                    "YÊU CẦU THANH TOÁN",
                                    style: TextStyle(color: colorInformation),
                                  )),
                                  content: const SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget>[
                                        Center(
                                          child: Text(
                                              "Bạn có chắc chắn muốn hoàn tất hóa đơn này?",
                                              style: TextStyle(
                                                  color: Colors.black54)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          onTap: () => {Utils.myPop(context)},
                                          child: Expanded(
                                            child: Container(
                                              height: 50,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3,
                                              color: backgroundColorCancel,
                                              child: const Center(
                                                child: Text(
                                                  'HỦY',
                                                  style: buttonStyleCancel,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () async => {
                                            billController.createBill(
                                                orderController.orderDetail,
                                                widget.order.order_code,
                                                orderController
                                                    .order.total_vat_amount,
                                                orderController.order
                                                    .total_discount_amount,
                                                context),
                                            Utils.myPopSuccess(context)
                                          },
                                          child: Expanded(
                                            child: Container(
                                              height: 50,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3,
                                              color: primaryColor,
                                              child: const Center(
                                                child: Text(
                                                  'XÁC NHẬN',
                                                  style: buttonStyleConfirm,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                );
                              },
                            );
                            if (result == 'success') {
                              Utils.myPopSuccess(context);
                            }
                          }
                        },
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
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
