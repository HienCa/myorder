// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/bills/bills_controller.dart';
import 'package:myorder/controllers/discounts/discounts_controller.dart';
import 'package:myorder/controllers/orders/orders_controller.dart';
import 'package:myorder/controllers/vats/vats_controller.dart';
import 'package:myorder/models/discount.dart';
import 'package:myorder/models/order.dart';
import 'package:myorder/models/order_detail.dart';
import 'package:myorder/models/vat.dart';
import 'package:myorder/utils.dart';
import 'package:myorder/views/screens/payment/dialog_decrease_price.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

class PaymentPage extends StatefulWidget {
  final Order order;
  const PaymentPage({super.key, required this.order});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  OrderController orderController = Get.put(OrderController());
  DiscountController discountController = Get.put(DiscountController());
  VatController vatController = Get.put(VatController());
  BillController billController = Get.put(BillController());

  int selectedIndex = 0;
  bool isCheckedChooseTypeDiscrease = false;
  bool isCheckedGTGT = false;
  bool isCheckedDecrease = false;
  int selectedRadioDecrease = CATEGORY_ALL;
  final TextEditingController decreasePrice = TextEditingController();
//thuế giá trị gia tăng toàn đơn hàng
  final TextEditingController textVatController =
      TextEditingController(text: "");
  final TextEditingController textVatIdController =
      TextEditingController(text: "");
//discount
  final TextEditingController textDiscountController =
      TextEditingController(text: "");
  final TextEditingController textDiscountIdController =
      TextEditingController(text: "");

  late List<Vat> vats = [];
  late List<Discount> discounts = [];
  @override
  void initState() {
    super.initState();
    orderController.getOrderDetailById(widget.order);
    orderController.getTotalAmountById(widget.order);
    discountController.getActiveDiscounts();
    vatController.getActiveVats();
    discounts = discountController.activeDiscounts;
    vats = vatController.activeVats;

    if (orderController.order.is_vat == ACTIVE) {
      isCheckedGTGT = true;
    }
    if (orderController.order.is_discount == ACTIVE) {
      isCheckedDecrease = true;
    }
  }

  double getTotalAmount(Order order) {
    double totalAmount = 0;
    for (OrderDetail item in order.order_details) {
      totalAmount += (item.price * item.quantity);
    }
    return totalAmount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          "#${widget.order.order_code} - ${widget.order.table!.name}",
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
        children: [
          Container(
            margin: const EdgeInsets.all(kDefaultPadding),
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
            child: SizedBox(
              height: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Center(
                      child: Text(
                    "TỔNG TẠM TÍNH",
                    style: textStyleGrayBold,
                  )),
                  Obx(() {
                    return Center(
                        child: Text(
                            Utils.formatCurrency(
                                orderController.order.total_amount),
                            style: textStylePriceBold20));
                  })
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      color: labelBlackColor,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Số hóa đơn",
                      style: textStyleFoodNameBold16,
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      ":",
                      style: textStyleFoodNameBold16,
                    ),
                    const SizedBox(width: 20),
                    Text(
                      "#${widget.order.order_code}",
                      style: textStyleBlackRegular,
                    )
                  ],
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.groups,
                      color: labelBlackColor,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Số khách",
                      style: textStyleFoodNameBold16,
                    ),
                    const SizedBox(width: 20),
                    const Text(
                      ":",
                      style: textStyleFoodNameBold16,
                    ),
                    const SizedBox(width: 20),
                    Text(
                      "${widget.order.total_slot}",
                      style: textStyleBlackRegular,
                    )
                  ],
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.date_range,
                      color: labelBlackColor,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Ngày lập",
                      style: textStyleFoodNameBold16,
                    ),
                    const SizedBox(width: 23),
                    const Text(
                      ":",
                      style: textStyleFoodNameBold16,
                    ),
                    const SizedBox(width: 20),
                    Text(
                      Utils.convertTimestampToFormatDateVN(
                          widget.order.create_at),
                      style: textStyleBlackRegular,
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.person,
                      color: labelBlackColor,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Nhân viên",
                      style: textStyleFoodNameBold16,
                    ),
                    const SizedBox(width: 15),
                    const Text(
                      ":",
                      style: textStyleFoodNameBold16,
                    ),
                    const SizedBox(width: 20),
                    SizedBox(
                      width: 200,
                      child: Marquee(
                          direction: Axis.horizontal,
                          textDirection: TextDirection.ltr,
                          animationDuration: const Duration(seconds: 1),
                          backDuration: const Duration(milliseconds: 2000),
                          pauseDuration: const Duration(milliseconds: 1000),
                          directionMarguee: DirectionMarguee.TwoDirection,
                          child: Text(
                            widget.order.employee_name ?? "",
                            style: textStyleBlackRegular,
                          )),
                    ),
                  ],
                ),
              ],
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
                  itemCount: orderController.orderDetail.order_details.length,
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
                              child: Container(
                                decoration: BoxDecoration(
                                  color: backgroundColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    ListTile(
                                      selectedColor: primaryColor,
                                      leading: orderController
                                                  .orderDetail
                                                  .order_details[index]
                                                  .food!
                                                  .image !=
                                              ''
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              child: Image.network(
                                                orderController
                                                    .orderDetail
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
                                      title: Text(
                                          orderController.orderDetail
                                              .order_details[index].food!.name,
                                          style: textStyleFoodNameBold16),
                                      subtitle: orderController
                                                  .orderDetail
                                                  .order_details[index]
                                                  .food_status ==
                                              FOOD_STATUS_FINISH
                                          ? Text(
                                              FOOD_STATUS_FINISH_STRING,
                                              style: textStyleSeccess,
                                            )
                                          : Text(
                                              FOOD_STATUS_CANCEL_STRING,
                                              style: textStyleCancel,
                                            ),
                                      trailing: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            Utils.formatCurrency(orderController
                                                .orderDetail
                                                .order_details[index]
                                                .price),
                                            style: textStylePriceBlackRegular16,
                                          ),
                                          SizedBox(
                                            width: 100,
                                            child: orderController
                                                        .orderDetail
                                                        .order_details[index]
                                                        .food_status ==
                                                    FOOD_STATUS_FINISH
                                                ? Row(
                                                    children: [
                                                      const Text("Số lượng: ",
                                                          style:
                                                              textStylePriceBlackRegular16),
                                                      Text(
                                                          "${orderController.orderDetail.order_details[index].quantity}",
                                                          style:
                                                              textStyleSeccess),
                                                    ],
                                                  )
                                                : Row(
                                                    children: [
                                                      const Text("Số lượng: ",
                                                          style:
                                                              textStylePriceBlackRegular16),
                                                      Text(
                                                          "${orderController.orderDetail.order_details[index].quantity}",
                                                          style:
                                                              textStyleCancel),
                                                    ],
                                                  ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    //Danh sách Combo
                                    AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                      child: Container(
                                        margin: const EdgeInsets.only(left: 70),
                                        height: orderController
                                                .orderDetail
                                                .order_details[index]
                                                .listCombo
                                                .length *
                                            62,
                                        child: ListView.builder(
                                          scrollDirection: Axis.vertical,
                                          itemCount: orderController
                                              .orderDetail
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
                                                        width: 0.1,
                                                        color: borderColor)),
                                              ),
                                              child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {});
                                                  },
                                                  child: AnimatedContainer(
                                                    duration: const Duration(
                                                        milliseconds: 300),
                                                    curve: Curves.easeInOut,
                                                    // Chiều cao của ListTile thay đổi
                                                    child: InkWell(
                                                      onTap: () =>
                                                          {setState(() {})},
                                                      child: Column(
                                                        children: [
                                                          ListTile(
                                                            selectedColor:
                                                                primaryColor,
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
                                                                    orderController.orderDetail.order_details[index].listCombo[indexCombo].image !=
                                                                            ""
                                                                        ? ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(5),
                                                                            child:
                                                                                Image.network(
                                                                              orderController.orderDetail.order_details[index].listCombo[indexCombo].image ?? defaultFoodImageString,
                                                                              width: 40,
                                                                              height: 40,
                                                                              fit: BoxFit.cover,
                                                                            ),
                                                                          )
                                                                        : ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(5),
                                                                            child: defaultFoodImage40),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            title: Marquee(
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
                                                                  children: [
                                                                    TextSpan(
                                                                        text: orderController
                                                                            .orderDetail
                                                                            .order_details[
                                                                                index]
                                                                            .listCombo[
                                                                                indexCombo]
                                                                            .name,
                                                                        style: orderController.orderDetail.order_details[index].listCombo[indexCombo].isSelected ==
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
                              ),
                            ),
                          )),
                    );
                  },
                );
              }),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: InkWell(
                      onTap: () => {},
                      child: ListTile(
                          leading: Theme(
                            data:
                                ThemeData(unselectedWidgetColor: primaryColor),
                            child: Checkbox(
                              value: isCheckedGTGT,
                              onChanged: (bool? value) {
                                if (orderController.order.total_amount > 0) {
                                  setState(() {
                                    isCheckedGTGT = value!;
                                    print(isCheckedGTGT);
                                    // asp thue
                                    if (isCheckedGTGT) {
                                      orderController.applyVat(
                                          context,
                                          orderController.order,
                                          orderController
                                              .orderDetail.order_details);
                                    } else {
                                      orderController.cancelVat(
                                          context,
                                          orderController.order,
                                          orderController
                                              .orderDetail.order_details);
                                    }
                                  });
                                } else {
                                  Utils.showStylishDialog(
                                      context,
                                      'THÔNG BÁO',
                                      'Hóa đơn này chưa đủ điều kiện áp dụng VAT.',
                                      StylishDialogType.INFO);
                                }
                              },
                              activeColor: primaryColor,
                              visualDensity: VisualDensity.compact,
                            ),
                          ),
                          title: SizedBox(
                            width: 100,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.price_change,
                                    color: iconColorPrimary,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Thuế GTGT ($VAT_PERCENT%)",
                                    style: textStylePriceBold16,
                                  ),
                                ]),
                          ),
                          trailing: Obx(() {
                            return Text(
                                Utils.formatCurrency(
                                    orderController.order.total_vat_amount),
                                style: textStylePriceBold20);
                          }))),
                ),
                Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: InkWell(
                      onTap: () => {},
                      child: ListTile(
                          leading: Theme(
                            data:
                                ThemeData(unselectedWidgetColor: primaryColor),
                            child: Checkbox(
                              value: isCheckedDecrease,
                              onChanged: (bool? value) {
                                if (orderController.order.total_amount > 0) {
                                  setState(() {
                                    isCheckedDecrease = value!;
                                    //Hủy DISCOUNT khi nhấn uncheck checkbox
                                    if (isCheckedDecrease == false) {
                                      orderController.cancelDiscount(
                                          context,
                                          orderController.order,
                                          orderController
                                              .orderDetail.order_details);
                                    }
                                    // bật popup
                                    if (isCheckedDecrease) {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return CustomDialogDecreasePrice(
                                            order: orderController.order,
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
                                      StylishDialogType.INFO);
                                }
                              },
                              activeColor: primaryColor,
                              visualDensity: VisualDensity.compact,
                            ),
                          ),
                          title: const SizedBox(
                            width: 100,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.price_change,
                                    color: iconColorPrimary,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Giảm giá",
                                    style: textStylePriceBold16,
                                  ),
                                ]),
                          ),
                          trailing: Obx(() {
                            return Text(
                                Utils.formatCurrency(orderController
                                    .order.total_discount_amount),
                                style: textStylePriceBold20);
                          }))),
                ),
                Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width * 0.9,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: ListTile(
                        title: const SizedBox(
                          width: 50,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Tổng thanh toán",
                                  style: textStylePriceBold20,
                                ),
                              ]),
                        ),
                        trailing: Obx(() {
                          return Text(
                              Utils.formatCurrency(
                                  orderController.order.total_amount),
                              style: textStylePriceBold20);
                        }))),
                const SizedBox(height: 10),
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                  decoration: const BoxDecoration(
                    color: backgroundColor,
                  ),
                  child: InkWell(
                    onTap: () async {
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
                                  Text(
                                      "Bạn có chắc chắn muốn hoàn tất hóa đơn này?",
                                      style: TextStyle(color: Colors.black54)),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () => {Utils.myPop(context)},
                                    child: Expanded(
                                      child: Container(
                                        height: 50,
                                        width:
                                            MediaQuery.of(context).size.width /
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
                                              .orderDetail.total_vat_amount,
                                          orderController.orderDetail
                                              .total_discount_amount,
                                          context),
                                      Utils.myPopSuccess(context)
                                    },
                                    child: Expanded(
                                      child: Container(
                                        height: 50,
                                        width:
                                            MediaQuery.of(context).size.width /
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
                    },
                    child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text(
                            "IN HÓA ĐƠN VÀ TÍNH TIỀN",
                            style: textStyleWhiteBold20,
                          ),
                        )),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          )
        ],
      ),
    );
  }
}
