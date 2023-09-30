// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/discount/discounts_controller.dart';
import 'package:myorder/controllers/orders/orders_controller.dart';
import 'package:myorder/controllers/vats/vats_controller.dart';
import 'package:myorder/models/discount.dart';
import 'package:myorder/models/order.dart';
import 'package:myorder/models/vat.dart';
import 'package:myorder/utils.dart';

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

  int selectedIndex = 0;
  bool isCheckedGTGT = false;
  bool isCheckedDecrease = false;

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
    discountController.getActiveDiscounts();
    vatController.getActiveVats();
    discounts = discountController.activeDiscounts;
    vats = vatController.activeVats;

    // giá trị mặc định của giảm giá và thuế của đơn hàng hiện tại
    textVatController.text =
        widget.order.vat_name ?? orderController.orderDetail.vat_name ?? "";
    textVatIdController.text = widget.order.vat_id;

    textDiscountController.text = widget.order.discount_name ??
        orderController.orderDetail.discount_name ??
        "";
    textDiscountIdController.text = widget.order.discount_id;

    if (widget.order.vat_id != "") {
      isCheckedGTGT = true;
    }
    if (widget.order.discount_id != "") {
      isCheckedDecrease = true;
    }
    print(widget.order.vat_name);
    print(widget.order.discount_name);
    print("VAT-DISCOUNT");
    print(orderController.orderDetail.vat_id);
    print(orderController.orderDetail.discount_id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => {Navigator.pop(context)},
          child: const Icon(
            Icons.arrow_back_ios,
            color: iconWhiteColor,
          ),
        ),
        title: Center(
            child: Text(
                "#${widget.order.order_id} - ${widget.order.table!.name}")),
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
                    "TỔNG THANH TOÁN",
                    style: textStyleGrayBold,
                  )),
                  Center(child: Obx(() {
                    return Text(
                        Utils.formatCurrency(
                            orderController.orderDetail.total_amount ??
                                widget.order.total_amount),
                        style: textStylePriceBold20);
                  }))
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
                      "#${widget.order.order_id}",
                      style: textStyleBlackRegular,
                    )
                  ],
                ),
                const Row(
                  children: [
                    Icon(
                      Icons.groups,
                      color: labelBlackColor,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Số khách",
                      style: textStyleFoodNameBold16,
                    ),
                    SizedBox(width: 20),
                    Text(
                      ":",
                      style: textStyleFoodNameBold16,
                    ),
                    SizedBox(width: 20),
                    Text(
                      "5",
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
                                  color: orderController
                                              .orderDetail
                                              .order_details[index]
                                              .food_status ==
                                          FOOD_STATUS_CANCEL
                                      ? backgroundCancelFoodColor
                                      : backgroundColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ListTile(
                                  selectedColor: primaryColor,
                                  leading: orderController.orderDetail
                                              .order_details[index].food !=
                                          null
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child: Image.network(
                                            orderController
                                                .orderDetail
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
                                      orderController.orderDetail
                                          .order_details[index].food!.name,
                                      style: textStyleFoodNameBold16),
                                  subtitle: orderController
                                              .orderDetail
                                              .order_details[index]
                                              .food_status ==
                                          FOOD_STATUS_IN_CHEFT
                                      ? Text(
                                          FOOD_STATUS_IN_CHEFT_STRING,
                                          style: textStyleMaking,
                                        )
                                      : orderController
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                                      style: textStyleSeccess),
                                                ],
                                              )
                                            : orderController
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
                                                              textStyleMaking),
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
                      onTap: () => {
                            // setState(() {
                            //   isCheckedGTGT = !isCheckedGTGT;
                            // })
                          },
                      child: ListTile(
                        leading: Theme(
                          data: ThemeData(unselectedWidgetColor: primaryColor),
                          child: Checkbox(
                            value: isCheckedGTGT,
                            onChanged: (bool? value) {
                              setState(() {
                                isCheckedGTGT = value!;
                                print(isCheckedGTGT);
                                //Hủy VAT khi nhấn uncheck checkbox
                                if (isCheckedGTGT == false) {
                                  orderController
                                      .cancelVat(widget.order.order_id);
                                }

                                // bật popup
                                if (isCheckedGTGT) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              10.0), // Góc bo tròn
                                        ),
                                        elevation: 5, // Độ nâng của bóng đổ
                                        backgroundColor: backgroundColor,
                                        child: Container(
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Center(
                                                child: Text(
                                                  'ÁP DỤNG THUẾ VAT',
                                                  style: textStylePrimaryBold,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              Container(
                                                height: 50,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        width: 0.5,
                                                        color: Colors.grey),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                5))),
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12),
                                                child: TypeAheadField<Vat>(
                                                  textFieldConfiguration:
                                                      TextFieldConfiguration(
                                                    keyboardType:
                                                        TextInputType.none,
                                                    controller:
                                                        textVatController,
                                                    decoration: InputDecoration(
                                                      labelText: textVatController
                                                              .text.isEmpty
                                                          ? 'Áp dụng thuế VAT'
                                                          : "",
                                                      suffixIcon: InkWell(
                                                          onTap: () => {
                                                                textVatController
                                                                    .text = "",
                                                                print(
                                                                    textVatIdController
                                                                        .text)
                                                              },
                                                          child: const Icon(
                                                              Icons.close,
                                                              color:
                                                                  Colors.grey)),
                                                      border:
                                                          const OutlineInputBorder(),
                                                      labelStyle: const TextStyle(
                                                          color:
                                                              tableemptyColor),
                                                    ),
                                                    style: const TextStyle(
                                                        color: textColor),
                                                  ),
                                                  suggestionsCallback:
                                                      (pattern) async {
                                                    return vats.where((item) =>
                                                        item
                                                            .name
                                                            .toLowerCase()
                                                            .contains(pattern
                                                                .toLowerCase()));
                                                  },
                                                  itemBuilder:
                                                      (context, suggestion) {
                                                    return ListTile(
                                                      title: Text(
                                                        suggestion.name,
                                                      ),
                                                    );
                                                  },
                                                  onSuggestionSelected:
                                                      (suggestion) {
                                                    setState(() {
                                                      textVatController.text =
                                                          suggestion
                                                              .name; // Set the input value
                                                      print(suggestion.vat_id);
                                                      textVatIdController.text =
                                                          suggestion.vat_id;
                                                    });
                                                  },
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    InkWell(
                                                      onTap: () => {
                                                        setState(() {
                                                          isCheckedGTGT =
                                                              !isCheckedGTGT;

                                                          //hủy áp dụng vat
                                                          if (orderController
                                                                      .orderDetail
                                                                      .vat_id !=
                                                                  "" ||
                                                              widget.order
                                                                      .vat_id !=
                                                                  "") {
                                                            orderController
                                                                .cancelVat(widget
                                                                    .order
                                                                    .order_id);
                                                            widget.order
                                                                .vat_id = "";
                                                          }
                                                        }),
                                                        Navigator.pop(context)
                                                      },
                                                      child: Container(
                                                        height: 50,
                                                        width: 136,
                                                        decoration:
                                                            const BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5)),
                                                          color:
                                                              backgroundColorGray,
                                                        ),
                                                        child: const Center(
                                                          child: Text(
                                                            'HỦY BỎ',
                                                            style:
                                                                textStyleCancel,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () => {
                                                        orderController.applyVat(
                                                            widget
                                                                .order.order_id,
                                                            textVatIdController
                                                                .text),
                                                        widget.order.vat_id =
                                                            textVatIdController
                                                                .text,
                                                        Navigator.pop(context)
                                                      },
                                                      child: Container(
                                                        height: 50,
                                                        width: 136,
                                                        decoration:
                                                            const BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5)),
                                                          color: primaryColor,
                                                        ),
                                                        child: const Center(
                                                          child: Text(
                                                            'ÁP DỤNG',
                                                            style:
                                                                textStyleWhiteBold20,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ); // Hiển thị hộp thoại tùy chỉnh
                                    },
                                  );
                                }
                                //cập nhật lại thông tin
                                //  orderController.getOrderDetailById(widget.order);
                              });
                            },
                            activeColor: primaryColor,
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
                                  "Thuế GTGT",
                                  style: textStylePriceBold16,
                                ),
                              ]),
                        ),
                        trailing: Text(
                          Utils.formatCurrency(
                              orderController.orderDetail.total_vat_amount),
                          style: textStylePriceBold16,
                        ),
                      )),
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
                          data: ThemeData(unselectedWidgetColor: primaryColor),
                          child: Checkbox(
                            value: isCheckedDecrease,
                            onChanged: (bool? value) {
                              setState(() {
                                isCheckedDecrease = value!;
                                //Hủy DISCOUNT khi nhấn uncheck checkbox
                                if (isCheckedDecrease == false) {
                                  orderController
                                      .cancelDiscount(widget.order.order_id);
                                }
                                // bật popup
                                if (isCheckedDecrease) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              10.0), // Góc bo tròn
                                        ),
                                        elevation: 5, // Độ nâng của bóng đổ
                                        backgroundColor: backgroundColor,
                                        child: Container(
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Center(
                                                child: Text(
                                                  'GIẢM GIÁ HÓA ĐƠN',
                                                  style: textStylePrimaryBold,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              Container(
                                                height: 50,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        width: 0.5,
                                                        color: Colors.grey),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                5))),
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12),
                                                child: TypeAheadField<Discount>(
                                                  textFieldConfiguration:
                                                      TextFieldConfiguration(
                                                    keyboardType:
                                                        TextInputType.none,
                                                    controller:
                                                        textDiscountController,
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          textDiscountController
                                                                  .text.isEmpty
                                                              ? 'Vui lòng chọn khuyến mãi'
                                                              : "",
                                                      suffixIcon: InkWell(
                                                          onTap: () => {
                                                                textDiscountController
                                                                    .text = "",
                                                                print(
                                                                    textDiscountIdController
                                                                        .text)
                                                              },
                                                          child: const Icon(
                                                              Icons.close,
                                                              color:
                                                                  Colors.grey)),
                                                      border:
                                                          const OutlineInputBorder(),
                                                      labelStyle: const TextStyle(
                                                          color:
                                                              tableemptyColor),
                                                    ),
                                                    style: const TextStyle(
                                                        color: textColor),
                                                  ),
                                                  suggestionsCallback:
                                                      (pattern) async {
                                                    return discounts.where(
                                                        (item) => item.name
                                                            .toLowerCase()
                                                            .contains(pattern
                                                                .toLowerCase()));
                                                  },
                                                  itemBuilder:
                                                      (context, suggestion) {
                                                    return ListTile(
                                                      title: Text(
                                                        suggestion.name,
                                                      ),
                                                    );
                                                  },
                                                  onSuggestionSelected:
                                                      (suggestion) {
                                                    setState(() {
                                                      textDiscountController
                                                              .text =
                                                          suggestion
                                                              .name; // Set the input value
                                                      print(suggestion
                                                          .discount_id);
                                                      textDiscountIdController
                                                              .text =
                                                          suggestion
                                                              .discount_id;
                                                    });
                                                  },
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    InkWell(
                                                      onTap: () => {
                                                        setState(() {
                                                          isCheckedDecrease =
                                                              !isCheckedDecrease;

                                                          //hủy áp dụng giảm giá
                                                          if (orderController
                                                                      .orderDetail
                                                                      .discount_id !=
                                                                  "" ||
                                                              widget.order
                                                                      .discount_id !=
                                                                  "") {
                                                            orderController
                                                                .cancelDiscount(
                                                                    widget.order
                                                                        .order_id);
                                                            widget.order
                                                                .discount_id = "";
                                                          }
                                                        }),
                                                        Navigator.pop(context)
                                                      },
                                                      child: Container(
                                                        height: 50,
                                                        width: 136,
                                                        decoration:
                                                            const BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5)),
                                                          color:
                                                              backgroundColorGray,
                                                        ),
                                                        child: const Center(
                                                          child: Text(
                                                            'HỦY BỎ',
                                                            style:
                                                                textStyleCancel,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () => {
                                                        orderController
                                                            .applyDiscount(
                                                                widget.order
                                                                    .order_id,
                                                                textDiscountIdController
                                                                    .text),
                                                        widget.order
                                                                .discount_id =
                                                            textDiscountIdController
                                                                .text,
                                                        Navigator.pop(context)
                                                      },
                                                      child: Container(
                                                        height: 50,
                                                        width: 136,
                                                        decoration:
                                                            const BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5)),
                                                          color: primaryColor,
                                                        ),
                                                        child: const Center(
                                                          child: Text(
                                                            'ÁP DỤNG',
                                                            style:
                                                                textStyleWhiteBold20,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ); // Hiển thị hộp thoại tùy chỉnh
                                    },
                                  );
                                }
                                //cập nhật thông tin
                                // orderController.getOrderDetailById(widget.order);
                              });
                            },
                            activeColor: primaryColor,
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
                        trailing: Text(
                          Utils.formatCurrency(orderController
                              .orderDetail.total_discount_amount),
                          style: textStylePriceBold16,
                        ),
                      )),
                ),
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
                    onTap: () => {},
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
