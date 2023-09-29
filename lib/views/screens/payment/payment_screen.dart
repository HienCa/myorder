import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/orders/orders_controller.dart';
import 'package:myorder/models/order.dart';
import 'package:myorder/utils.dart';


class PaymentPage extends StatefulWidget {
  final Order order;
  const PaymentPage({super.key, required this.order});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  OrderController orderController = Get.put(OrderController());

  @override
  void initState() {
    super.initState();
    orderController.getOrderDetailById(widget.order);
  }

  int selectedIndex = 0;
  bool isCheckedGTGT = false;
  bool isCheckedDecrease = false;

  final TextEditingController decreasePrice = TextEditingController();

  final TextEditingController textEditingController =
      TextEditingController(text: "");
  final List<String> items = [
    'Khách quen',
    'Ngày khuyến mãi',
    'Hóa đơn trên 5 triệu',
    'Khác'
  ];
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
                              child: ListTile(
                                selectedColor: primaryColor,
                                leading: orderController.orderDetail
                                            .order_details[index].food !=
                                        null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: Image.network(
                                          orderController.orderDetail
                                              .order_details[index].food!.image,
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
                                subtitle: orderController.orderDetail
                                            .order_details[index].food_status ==
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
                                        style: textStylePriceBlackRegular16),
                                    SizedBox(
                                      width: 100,
                                      child: Row(
                                        children: [
                                          const Text("Số lượng: ",
                                              style:
                                                  textStylePriceBlackRegular16),
                                          Text(
                                              "${orderController.orderDetail.order_details[index].quantity}",
                                              style: textStyleSeccess),
                                        ],
                                      ),
                                    ),
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
                      onTap: () => {
                            setState(() {
                              isCheckedGTGT = !isCheckedGTGT;
                            })
                          },
                      child: ListTile(
                        leading: Theme(
                          data: ThemeData(unselectedWidgetColor: primaryColor),
                          child: Checkbox(
                            value: isCheckedGTGT,
                            onChanged: (bool? value) {
                              setState(() {
                                isCheckedGTGT = value!;
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
                        trailing: const Text(
                          "0",
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
                      onTap: () => {
                            
                          },
                      child: ListTile(
                        leading: Theme(
                          data: ThemeData(unselectedWidgetColor: primaryColor),
                          child: Checkbox(
                            value: isCheckedDecrease,
                            onChanged: (bool? value) {
                              setState(() {
                                isCheckedDecrease = value!;
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
                                        padding: const EdgeInsets.only(top: 20),
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
                                                          Radius.circular(5))),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12),
                                              child: TextField(
                                                controller: decreasePrice,
                                                style: const TextStyle(
                                                    color: textColor),
                                                decoration:
                                                    const InputDecoration(
                                                  border: OutlineInputBorder(
                                                      borderSide:
                                                          BorderSide(width: 1),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5))),
                                                  label: Text(
                                                      "Vui lòng nhập % muốn giảm",
                                                      style:
                                                          textStylePlaceholder),
                                                  hintStyle: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      color: Colors.grey),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
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
                                                          Radius.circular(5))),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12),
                                              child: TypeAheadField<String>(
                                                textFieldConfiguration:
                                                    TextFieldConfiguration(
                                                  controller:
                                                      textEditingController,
                                                  decoration: InputDecoration(
                                                    labelText: textEditingController
                                                            .text.isEmpty
                                                        ? 'Vui lòng chọn khuyến mãi'
                                                        : "",
                                                    border:
                                                        const OutlineInputBorder(),
                                                    labelStyle: const TextStyle(
                                                        color: tableemptyColor),
                                                  ),
                                                  style: const TextStyle(
                                                      color: textColor),
                                                ),
                                                suggestionsCallback:
                                                    (pattern) async {
                                                  return items.where((item) =>
                                                      item
                                                          .toLowerCase()
                                                          .contains(pattern
                                                              .toLowerCase()));
                                                },
                                                itemBuilder:
                                                    (context, suggestion) {
                                                  return ListTile(
                                                    title: Text(
                                                      suggestion,
                                                    ),
                                                  );
                                                },
                                                onSuggestionSelected:
                                                    (suggestion) {
                                                  setState(() {
                                                    textEditingController.text =
                                                        suggestion; // Set the input value
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
                                                                Radius.circular(
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
                                                    onTap: () => {},
                                                    child: Container(
                                                      height: 50,
                                                      width: 136,
                                                      decoration:
                                                          const BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5)),
                                                        color: primaryColor,
                                                      ),
                                                      child: const Center(
                                                        child: Text(
                                                          'XÁC NHẬN',
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
                        trailing: const Text(
                          "0",
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
