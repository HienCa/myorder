// ignore_for_file: non_constant_identifier_names, avoid_print, prefer_interpolation_to_compose_strings, constant_identifier_names, use_build_context_synchronously

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
import 'package:myorder/models/price_percent.dart';
import 'package:myorder/utils.dart';
import 'package:myorder/views/screens/managements/dashboard/take_away/dialog_confirm_take_away.dart';
import 'package:myorder/views/screens/managements/dashboard/take_away/dialog_decrease_price_take_away.dart';
import 'package:myorder/views/widgets/buttons/button_icon.dart';
import 'package:myorder/views/widgets/dialogs.dart';
import 'package:myorder/views/widgets/icons/icon_close.dart';
import 'package:myorder/views/widgets/textfields/text_field_icon/text_field_icon_phone.dart';
import 'package:myorder/views/widgets/textfields/text_field_icon/text_field_icon_string.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

enum DashBoardBooking { Food, Drink, Other, Gift }

class DashboardTakeAway extends StatefulWidget {
  const DashboardTakeAway({
    Key? key,
  }) : super(key: key);

  @override
  State<DashboardTakeAway> createState() => _DashboardTakeAwayState();
}

class _DashboardTakeAwayState extends State<DashboardTakeAway> {
  FoodController foodController = Get.put(FoodController());
  OrderController orderController = Get.put(OrderController());
  final nameTextEditingController = TextEditingController();
  final phoneTextEditingController = TextEditingController();
  final totalVatAmountTextEditingController = TextEditingController();
  final totalDiscountAmountTextEditingController = TextEditingController();
  final totalSurchargeAmountTextEditingController = TextEditingController();
  final totalAmountTextEditingController = TextEditingController();

  String keySearch = "";
  int categoryCodeSelected = 0;
  int categoryCodeDecrease = CATEGORY_ALL;
  PricePercent pricePercentResult =
      PricePercent(value: 0, type_value: TYPE_PRICE);
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
    totalVatAmountTextEditingController.text = '0';
    totalDiscountAmountTextEditingController.text = '0';
    totalSurchargeAmountTextEditingController.text = '0';
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

  void getTotalAmount() {
    double totalSelectedAmount =
        Utils.getSumPriceQuantitySelected(foodController.foodsToOrder);

    //Tính lại VAT
    //TỔNG VAT THEO ĐƠN HÀNG
    if (isCheckedGTGT) {
      double totalVatAmount = (totalSelectedAmount * VAT_PERCENT) / 100;

      totalVatAmountTextEditingController.text =
          Utils.formatCurrency(totalVatAmount);
    }
    //Tính lại discount
    if (isCheckedDecrease) {
      //TỔNG GIẢM GIÁ THEO ĐƠN HÀNG
      double totalSelectedAmount = Utils.getSumPriceQuantityCategory(
          foodController.foodsToOrder,
          (pricePercentResult.type_category ?? CATEGORY_ALL));
      double priceDecrease = 0;
      if (pricePercentResult.value > 0) {
        if (pricePercentResult.type_value == TYPE_PRICE) {
          //Nếu giảm giá bằng tiền
          priceDecrease = pricePercentResult.value;
          //Giới hạn số tiền giảm
          if (priceDecrease > totalSelectedAmount) {
            priceDecrease = totalSelectedAmount;

            Utils.showStylishDialog(
                context,
                "THÔNG BÁO",
                "Đơn hàng này giảm tối đa ${Utils.formatCurrency(priceDecrease)}.",
                StylishDialogType.INFO);
            if (priceDecrease == 0) {
              isCheckedDecrease = false;
            }
          }
        } else {
          //giảm giá theo %
          priceDecrease =
              (totalSelectedAmount * pricePercentResult.value) / 100;
        }
      }

      totalDiscountAmountTextEditingController.text =
          Utils.formatCurrency(priceDecrease);
    }

    double totalVatAmount =
        Utils.stringConvertToDouble(totalVatAmountTextEditingController.text);
    double totalDiscountAmount = Utils.stringConvertToDouble(
        totalDiscountAmountTextEditingController.text);
    double totalSurchargeAmount = Utils.stringConvertToDouble(
        totalSurchargeAmountTextEditingController.text);

    totalAmountTextEditingController.text = Utils.formatCurrency(
        totalSelectedAmount +
            totalVatAmount -
            totalDiscountAmount +
            totalSurchargeAmount);

    if ((totalSelectedAmount +
            totalVatAmount -
            totalDiscountAmount +
            totalSurchargeAmount) <
        0) {
      totalAmountTextEditingController.text = '0';
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
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SizedBox(
                              height: 40,
                              // width: MediaQuery.of(context).size.width * 0.45,
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
                                          totalVatAmountTextEditingController
                                                  .text =
                                              '${Utils.getSumPriceQuantity(Utils.filterSelected(foodController.foodsToOrder))}';
                                          print(
                                              "THÊM MÓN: ${food.name} - SL: ${food.quantity}");
                                          //TÍNH TỔNG TIỀN
                                          getTotalAmount();
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
                                          getTotalAmount();
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
                                    'THÔNG TIN BÁN MANG VỀ',
                                    style: textStyleTabLandscapeLabel,
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
                                  min: 0,
                                  max: 50,
                                  isRequire: false,
                                  height: 30,
                                  isBorder: false,
                                )),
                                marginRight5,
                                Expanded(
                                    child: MyTextFieldIconPhone(
                                  textController: phoneTextEditingController,
                                  placeholder: 'Số điện thoại',
                                  isRequire: false,
                                  height: 30,
                                  isBorder: false,
                                )),
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
                                                                            'CHỜ XÁC NHẬN',
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
                                                                            getTotalAmount();
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
                                                                          getTotalAmount();
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
                                                                              //TÍNH TỔNG ĐƠN HÀNG
                                                                              getTotalAmount();
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
                          height: MediaQuery.of(context).size.height * 0.225,
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
                                                    setState(() {
                                                      isCheckedGTGT = value!;
                                                      if (isCheckedGTGT) {
                                                        //TỔNG TIỀN ĐƠN HÀNG

                                                        double totalAmount = Utils
                                                            .getSumPriceQuantitySelected(
                                                                foodController
                                                                    .foodsToOrder);

                                                        //TỔNG VAT THEO ĐƠN HÀNG
                                                        double totalVatAmount =
                                                            (totalAmount *
                                                                    VAT_PERCENT) /
                                                                100;

                                                        totalVatAmountTextEditingController
                                                                .text =
                                                            Utils.formatCurrency(
                                                                totalVatAmount);
                                                      } else {
                                                        // Utils.showStylishDialog(
                                                        //     context,
                                                        //     'THÔNG BÁO',
                                                        //     'Hóa đơn này chưa đủ điều kiện áp dụng VAT.',
                                                        //     StylishDialogType
                                                        //         .INFO);
                                                        isCheckedGTGT = false;
                                                        totalVatAmountTextEditingController
                                                            .text = '0';
                                                      }
                                                      getTotalAmount();
                                                    });
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

                                      isCheckedGTGT
                                          ? Text(
                                              "$VAT_PERCENT%",
                                              style: textStyleTabLandscapeLabel,
                                            )
                                          : const SizedBox(),

                                      const Spacer(),
                                      //Số tiền thuế đã áp dụng
                                      Text(
                                          Utils.formatCurrency(
                                              Utils.stringConvertToDouble(
                                                  totalVatAmountTextEditingController
                                                      .text)),
                                          style: textStyleTabLandscapeLabel)
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
                                                  onChanged:
                                                      (bool? value) async {
                                                    isCheckedDecrease = value!;
                                                    if (isCheckedDecrease) {
                                                      PricePercent result =
                                                          await showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return const CustomDialogDecreasePriceBooking();
                                                        },
                                                      );

                                                      //xử lý kết quả
                                                      setState(() {
                                                        if (result.value > 0) {
                                                          pricePercentResult =
                                                              result;
                                                          //TỔNG TIỀN ĐƠN HÀNG

                                                          //TỔNG GIẢM GIÁ THEO ĐƠN HÀNG
                                                          double
                                                              totalSelectedAmount =
                                                              Utils.getSumPriceQuantityCategory(
                                                                  foodController
                                                                      .foodsToOrder,
                                                                  (result.type_category ??
                                                                      CATEGORY_ALL));
                                                          double priceDecrease =
                                                              0;
                                                          if (result.value >
                                                              0) {
                                                            if (result
                                                                    .type_value ==
                                                                TYPE_PRICE) {
                                                              //Nếu giảm giá bằng tiền
                                                              priceDecrease =
                                                                  result.value;
                                                              //Giới hạn số tiền giảm
                                                              if (priceDecrease >
                                                                  totalSelectedAmount) {
                                                                priceDecrease =
                                                                    totalSelectedAmount;

                                                                Utils.showStylishDialog(
                                                                    context,
                                                                    "THÔNG BÁO",
                                                                    "Đơn hàng này giảm tối đa ${Utils.formatCurrency(priceDecrease)}.",
                                                                    StylishDialogType
                                                                        .INFO);
                                                                if (priceDecrease ==
                                                                    0) {
                                                                  isCheckedDecrease =
                                                                      false;
                                                                }
                                                              }
                                                            } else {
                                                              //giảm giá theo %
                                                              priceDecrease =
                                                                  (totalSelectedAmount *
                                                                          result
                                                                              .value) /
                                                                      100;
                                                            }
                                                          }

                                                          totalDiscountAmountTextEditingController
                                                                  .text =
                                                              Utils.formatCurrency(
                                                                  priceDecrease);

                                                          //TÍNH TỔNG ĐƠN HÀNG
                                                          getTotalAmount();

                                                          //loại món muốn giảm: ALL FOOD DRINK OTHER
                                                          categoryCodeDecrease =
                                                              (result.type_category ??
                                                                  CATEGORY_ALL);
                                                        } else {
                                                          totalDiscountAmountTextEditingController
                                                              .text = '0';
                                                          isCheckedDecrease =
                                                              false;
                                                          //TÍNH TỔNG ĐƠN HÀNG
                                                          getTotalAmount();
                                                        }
                                                      });
                                                    } else {
                                                      setState(() {
                                                        totalDiscountAmountTextEditingController
                                                            .text = '0';
                                                        isCheckedDecrease =
                                                            false;
                                                        //TÍNH TỔNG ĐƠN HÀNG
                                                        getTotalAmount();
                                                      });
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
                                      (isCheckedDecrease &&
                                              pricePercentResult.type_value ==
                                                  TYPE_PERCENT)
                                          ? Row(
                                              children: [
                                                Text(
                                                  "${pricePercentResult.value.toInt()}%",
                                                  style:
                                                      textStyleTabLandscapeLabel,
                                                ),
                                                marginRight5,
                                                pricePercentResult
                                                            .type_category ==
                                                        CATEGORY_ALL
                                                    ? const Text(
                                                        "(Tất cả)",
                                                        style:
                                                            textStyleTabLandscapeLabel,
                                                      )
                                                    : pricePercentResult
                                                                .type_category ==
                                                            CATEGORY_FOOD
                                                        ? const Text(
                                                            "(Món ăn)",
                                                            style:
                                                                textStyleTabLandscapeLabel,
                                                          )
                                                        : pricePercentResult
                                                                    .type_category ==
                                                                CATEGORY_DRINK
                                                            ? const Text(
                                                                "(Đồ uống)",
                                                                style:
                                                                    textStyleTabLandscapeLabel,
                                                              )
                                                            : const Text(
                                                                "(Khác)",
                                                                style:
                                                                    textStyleTabLandscapeLabel,
                                                              ),
                                              ],
                                            )
                                          : const SizedBox(),
                                      const Spacer(),

                                      //Số tiền đã giảm
                                      Text(
                                          Utils.formatCurrency(
                                              Utils.stringConvertToDouble(
                                                  totalDiscountAmountTextEditingController
                                                      .text)),
                                          style: textStyleTabLandscapeLabel)
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
                                      Text(
                                          Utils.formatCurrency(
                                              Utils.stringConvertToDouble(
                                                  totalAmountTextEditingController
                                                      .text)),
                                          style: textStyleTabLandscapeLabel)
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

              Container(
                padding: const EdgeInsets.only(left: 4, right: 4),
                height: 45,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //LƯU THÊM MÓN MỚI
                    InkWell(
                      onTap: () async {
                        if (Utils.filterSelected(foodController.foodsToOrder)
                            .isNotEmpty) {
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
                              return MyDialogConfirmOrderTakeAway(
                                title: 'ĐƠN HÀNG MANG VỀ',
                                discription: 'Đơn hàng bán mang về?',
                                total_discount_amount:
                                    Utils.stringConvertToDouble(
                                        totalDiscountAmountTextEditingController
                                            .text),
                                total_vat_amount: Utils.stringConvertToDouble(
                                    totalVatAmountTextEditingController.text),
                                total_surcharge_amount:
                                    Utils.stringConvertToDouble(
                                        totalSurchargeAmountTextEditingController
                                            .text),
                                orderDetailList: orderDetailList,
                                total_amount: Utils.stringConvertToDouble(
                                    totalAmountTextEditingController.text),
                                discount_percent:
                                    pricePercentResult.type_value ==
                                            TYPE_PERCENT
                                        ? pricePercentResult.value
                                        : 0,
                              );
                            },
                          );
                          if (result == 'success') {
                            Utils.showToast('Lập đơn hàng mang về thành công!',
                                TypeToast.SUCCESS);

                            Utils.myPopSuccess(context);
                          }
                        }
                      },
                      child: CustomButtonIcon(
                          label: 'XÁC NHẬN ĐƠN HÀNG',
                          height: 40,
                          iconColor: secondColor,
                          icon: FontAwesomeIcons.plus,
                          backgroundColor:
                              Utils.filterSelected(foodController.foodsToOrder)
                                      .isNotEmpty
                                  ? colorSuccess
                                  : grayColor,
                          textStyle: const TextStyle(
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
