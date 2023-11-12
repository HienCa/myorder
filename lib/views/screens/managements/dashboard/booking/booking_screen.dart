// ignore_for_file: non_constant_identifier_names, avoid_print, prefer_interpolation_to_compose_strings, constant_identifier_names, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/constants/app_constants.dart';
import 'package:myorder/controllers/foods/foods_controller.dart';
import 'package:myorder/controllers/orders/orders_controller.dart';
import 'package:myorder/models/order_detail.dart';
import 'package:myorder/models/table.dart' as model;
import 'package:myorder/utils.dart';
import 'package:myorder/views/screens/managements/dashboard/booking/dialog_confirm_booking.dart';
import 'package:myorder/views/widgets/buttons/button_icon.dart';
import 'package:myorder/views/widgets/dialogs.dart';
import 'package:myorder/views/widgets/dialogs/dialog_choose_price.dart';
import 'package:myorder/views/widgets/icons/icon_close.dart';
import 'package:myorder/views/widgets/textfields/text_field_icon/text_field_icon_datetime.dart';
import 'package:myorder/views/widgets/textfields/text_field_icon/text_field_icon_number.dart';
import 'package:myorder/views/widgets/textfields/text_field_icon/text_field_icon_phone.dart';
import 'package:myorder/views/widgets/textfields/text_field_icon/text_field_icon_string.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

enum DashBoardBooking { Food, Drink, Other, Gift }

class DashboardBooking extends StatefulWidget {
  final model.Table table;
  const DashboardBooking({
    Key? key,
    required this.table,
  }) : super(key: key);

  @override
  State<DashboardBooking> createState() => _DashboardBookingState();
}

class _DashboardBookingState extends State<DashboardBooking> {
  FoodController foodController = Get.put(FoodController());
  OrderController orderController = Get.put(OrderController());
  final nameTextEditingController = TextEditingController();
  final phoneTextEditingController = TextEditingController();
  final slotTextEditingController = TextEditingController();
  final timeTextEditingController = TextEditingController();
  final depositAmountTextEditingController = TextEditingController();

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
    foodController.getfoodsToOrder(keySearch, defaultCategory);
    depositAmountTextEditingController.text = '0';
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

  void setUpScreen(DashBoardBooking dashBoardBooking) {
    switch (dashBoardBooking) {
      case DashBoardBooking.Food:
        setState(() {
          isFood = true;
          isDrink = false;
          isOther = false;
          isGift = false;
          categoryCodeSelected = CATEGORY_FOOD;
        });
      case DashBoardBooking.Drink:
        setState(() {
          isFood = false;
          isDrink = true;
          isOther = false;
          isGift = false;
          categoryCodeSelected = CATEGORY_DRINK;
        });
      case DashBoardBooking.Other:
        setState(() {
          isFood = false;
          isDrink = false;
          isOther = true;
          isGift = false;
          categoryCodeSelected = CATEGORY_OTHER;
        });
      case DashBoardBooking.Gift:
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: grayColor200,
      body: Theme(
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
                                    setUpScreen(DashBoardBooking.Food);
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
                                    setUpScreen(DashBoardBooking.Drink);
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
                                    setUpScreen(DashBoardBooking.Other);
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
                                    setUpScreen(DashBoardBooking.Gift);
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
                          height: MediaQuery.of(context).size.height * 0.74,
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
                                                                textDirection:
                                                                    TextDirection
                                                                        .ltr,
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
                                    'THÔNG TIN ĐẶT BÀN',
                                    style: textStyleTabLandscapeLabel,
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    '${widget.table.name} - Số lượng tối đa: ${widget.table.total_slot} khách',
                                    style: textStyleTabLandscapeLabelBold,
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
                              color: backgroundColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                    child: MyTextFieldIconString(
                                  textController: nameTextEditingController,
                                  iconData: FontAwesomeIcons.userLarge,
                                  placeholder: 'Tên khách hàng',
                                  isReadOnly: false,
                                  min: 2,
                                  max: 50,
                                  isRequire: true,
                                  height: 30,
                                  isBorder: false,
                                )),
                                marginRight5,
                                Expanded(
                                    child: MyTextFieldIconPhone(
                                  textController: phoneTextEditingController,
                                  placeholder: 'Số điện thoại',
                                  isRequire: true,
                                  height: 30,
                                  isBorder: false,
                                )),
                              ],
                            ),
                          ),
                        ),
                        marginTop5,
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
                              color: backgroundColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                    child: MyTextFieldIconNumber(
                                  textController: slotTextEditingController,
                                  placeholder: 'Số lượng khách',
                                  isRequire: true,
                                  height: 30,
                                  isBorder: false,
                                  isReadOnly: false,
                                  min: 1,
                                  max: widget.table.total_slot,
                                  iconData: FontAwesomeIcons.users,
                                )),
                                marginRight5,
                                Expanded(
                                  child: MyTextFieldIconDateTime(
                                      textEditingController:
                                          timeTextEditingController,
                                      placeholder: 'Thời gian đặt bàn',
                                      height: 30,
                                      isBorder: false),
                                )
                              ],
                            ),
                          ),
                        ),
                        marginTop5,
                        //DANH SÁCH MÓN ĂN CỦA ĐƠN HÀNG
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.4,
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
                                return
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
                            child: Center(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(children: [
                                  //ĐÃ ĐẶT CỌC
                                  Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Spacer(),
                                        const Text(
                                          "TỔNG TẠM TÍNH",
                                          style: textStylePrimaryLandscapeBold,
                                        ),
                                        const Spacer(),
                                        Obx(() {
                                          return Text(
                                              Utils.formatCurrency(
                                                  Utils.getSumPriceQuantity(
                                                      Utils.filterSelected(
                                                          foodController
                                                              .foodsToOrder))),
                                              style:
                                                  textStylePrimaryLandscapeBold);
                                        })
                                      ]),
                                ]),
                              ),
                            ),
                          ),
                        ),
                        marginTop5,
                        InkWell(
                          onTap: () async {
                            final result = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const MyDialogChoosePrice();
                              },
                            );
                            if (result != null) {
                              setState(() {
                                depositAmountTextEditingController.text =
                                    result;
                              });
                            }
                          },
                          child: SizedBox(
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
                              child: Center(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Column(children: [
                                    //ĐÃ ĐẶT CỌC
                                    Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Spacer(),
                                          const Text(
                                            "ĐẶT CỌC",
                                            style:
                                                textStylePrimaryLandscapeBold,
                                          ),
                                          const Spacer(),
                                          //Chọn số tiền cọc
                                          Text(
                                              depositAmountTextEditingController
                                                  .text,
                                              style:
                                                  textStylePrimaryLandscapeBold)
                                        ]),
                                  ]),
                                ),
                              ),
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

              Container(
                padding: const EdgeInsets.only(left: 4, right: 4),
                height: 45,
                color: backgroundColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //VALIDATE THÔNG TIN

                    //LƯU THÊM MÓN MỚI
                    InkWell(
                      onTap: () async {
                        //Có quyền không gọi món trước
                        if (!Utils.isValidLengthTextEditController(
                            nameTextEditingController,
                            minlength2,
                            maxlength50)) {
                          Utils.showStylishDialog(
                              context,
                              'THÔNG BÁO',
                              'Tên khách hàng phải từ 2-50 ký tự.',
                              StylishDialogType.ERROR);
                        } else if (!Utils.startsWithZero(
                                phoneTextEditingController.text) &&
                            (phoneTextEditingController.text.trim().length <
                                    minlengthPhone ||
                                phoneTextEditingController.text.trim().length >
                                    maxlengthPhone)) {
                          Utils.showStylishDialog(
                              context,
                              'THÔNG BÁO',
                              'Số điện thoại chưa hợp lệ',
                              StylishDialogType.ERROR);
                        } else if (!Utils.isValidRangeString(
                            slotTextEditingController.text,
                            1,
                            widget.table.total_slot)) {
                          Utils.showStylishDialog(
                              context,
                              'THÔNG BÁO',
                              'Số lượng khách phải từ 1 đến ${widget.table.total_slot}.',
                              StylishDialogType.ERROR);
                        } else if (timeTextEditingController.text.trim() ==
                            '') {
                          Utils.showStylishDialog(
                              context,
                              'THÔNG BÁO',
                              'Vui lòng chọn thời gian đặt bàn!',
                              StylishDialogType.ERROR);
                        } else {
                          List<OrderDetail> orderDetailList =
                              []; // danh sach cac mon khi order
                          print(
                              "================MÓN CẦN ORDER===================");
                          for (var foodOrder in foodController.foodsToOrder) {
                            if (foodOrder.isSelected == true) {
                              //chi tiet don hang
                              //Nếu món ăn có giá thời vụ thì lấy giá thời vụ, ngược lại lấy giá gốc
                              OrderDetail orderDetail = OrderDetail(
                                order_detail_id: "",
                                price: Utils.isDateTimeInRange(
                                        foodOrder.temporary_price_from_date,
                                        foodOrder.temporary_price_to_date)
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
                              );
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
                              print("Is Selected: ${foodOrder.isSelected}");
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
                                          additionFood.temporary_price_to_date)
                                      ? (additionFood.price +
                                          additionFood.price_with_temporary!)
                                      : additionFood.price,
                                  quantity: additionFood.quantity!,
                                  food_status: FOOD_STATUS_IN_CHEF,
                                  food_id: additionFood.food_id,
                                  is_gift: false,
                                  category_id: '',
                                  category_code: additionFood.category_code,
                                  chef_bar_status: CHEF_BAR_STATUS,
                                  is_addition: true,
                                );

                                orderDetailList.add(orderDetail);

                                //show thong tin console
                                print("--------------------------------");
                                print("ID: ${additionFood.food_id}");
                                print("Name: ${additionFood.name}");
                                print("Price: ${additionFood.price}");
                                print("Quantity: ${additionFood.quantity}");
                                print(
                                    "Is Selected: ${additionFood.isSelected}");
                                print("--------------------------------");
                              }
                            }
                          }
                          print(
                              "================HẾT MÓN CẦN ORDER===================");
                          final result = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return MyDialogConfirmBooking(
                                title: 'BOOKING',
                                discription:
                                    'Bàn ${widget.table.name} sẽ được đặt trước vào thời gian ${Utils.convertTimestampToFormatDateVN(Timestamp.fromDate(DateTime.parse(timeTextEditingController.text)))}',
                                table_id: widget.table.table_id,
                                table_name: widget.table.name,
                                slot: (int.tryParse(
                                        slotTextEditingController.text) ??
                                    0),
                                orderDetailList: orderDetailList,
                                customer_name: nameTextEditingController.text,
                                customer_phone: phoneTextEditingController.text,
                                customer_time_booking:
                                    timeTextEditingController.text,
                                //tiền đặt cọc
                                deposit_amount: (double.tryParse(
                                        Utils.formatCurrencytoDouble(
                                            depositAmountTextEditingController
                                                .text)) ??
                                    0),
                              );
                            },
                          );
                          if (result == 'success') {
                            Utils.showToast(
                                'Đặt bàn thành công!', TypeToast.SUCCESS);

                            Utils.myPopSuccess(context);
                          }
                        }
                      },
                      child: const CustomButtonIcon(
                          label: 'XÁC NHẬN ĐẶT BÀN',
                          height: 40,
                          iconColor: secondColor,
                          icon: FontAwesomeIcons.plus,
                          backgroundColor: colorSuccess,
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
