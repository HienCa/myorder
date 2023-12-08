// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/models/bill.dart';
import 'package:myorder/utils.dart';

class BillDetailPage extends StatefulWidget {
  final Bill bill;
  const BillDetailPage({super.key, required this.bill});

  @override
  State<BillDetailPage> createState() => _BillDetailPageState();
}

class _BillDetailPageState extends State<BillDetailPage> {
  int selectedIndex = 0;
  bool isCheckedGTGT = false;
  bool isCheckedDecrease = false;

  @override
  void initState() {
    super.initState();
    isCheckedGTGT = widget.bill.order!.is_vat == ACTIVE ? true : false;
    isCheckedDecrease = widget.bill.order!.is_discount == ACTIVE ? true : false;
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
          "HÓA ĐƠN BÀN ${widget.bill.order!.table!.name}",
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
                    "TỔNG HÓA ĐƠN",
                    style: textStyleGrayBold,
                  )),
                  Center(
                      child: Text(
                          Utils.formatCurrency(widget.bill.total_amount),
                          style: textStylePriceBold20))
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
                      "#${widget.bill.order_code}",
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
                      "${widget.bill.total_slot}",
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
                          widget.bill.payment_at),
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
                            widget.bill.order!.employee_name ?? "",
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
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: widget.bill.order_details.length,
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
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                widget.bill.order_details[index].food_status ==
                                        FOOD_STATUS_CANCEL
                                    ? backgroundCancelFoodColor
                                    : backgroundColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            selectedColor: primaryColor,
                            leading:
                                widget.bill.order_details[index].food != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: Image.network(
                                          widget.bill.order_details[index].food!
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
                                widget.bill.order_details[index].food!.name,
                                style: textStyleFoodNameBold16),
                            subtitle:
                                widget.bill.order_details[index].food_status ==
                                        FOOD_STATUS_IN_CHEF
                                    ? Text(
                                        FOOD_STATUS_IN_CHEF_STRING,
                                        style: textStyleMaking,
                                      )
                                    : widget.bill.order_details[index]
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
                                  Utils.formatCurrency(
                                      widget.bill.order_details[index].price),
                                  style: textStylePriceBlackRegular16,
                                ),
                                SizedBox(
                                  width: 100,
                                  child: widget.bill.order_details[index]
                                              .food_status ==
                                          FOOD_STATUS_FINISH
                                      ? Row(
                                          children: [
                                            const Text("Số lượng: ",
                                                style:
                                                    textStylePriceBlackRegular16),
                                            Text(
                                                "${widget.bill.order_details[index].quantity}",
                                                style: textStyleSeccess),
                                          ],
                                        )
                                      : widget.bill.order_details[index]
                                                  .food_status ==
                                              FOOD_STATUS_FINISH
                                          ? Row(
                                              children: [
                                                const Text("Số lượng: ",
                                                    style:
                                                        textStylePriceBlackRegular16),
                                                Text(
                                                    "${widget.bill.order_details[index].quantity}",
                                                    style: textStyleMaking),
                                              ],
                                            )
                                          : Row(
                                              children: [
                                                const Text("Số lượng: ",
                                                    style:
                                                        textStylePriceBlackRegular16),
                                                Text(
                                                    "${widget.bill.order_details[index].quantity}",
                                                    style: textStyleCancel),
                                              ],
                                            ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                // Container(
                //     height: 40,
                //     width: MediaQuery.of(context).size.width * 0.9,
                //     margin:
                //         const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                //     decoration: const BoxDecoration(
                //       color: Colors.transparent,
                //     ),
                //     child: ListTile(
                //       leading: Theme(
                //         data: ThemeData(
                //             unselectedWidgetColor: Colors.transparent),
                //         child: Checkbox(
                //           value: isCheckedDecrease,
                //           onChanged: (bool? value) {
                //             isCheckedDecrease =
                //                 widget.bill.order!.is_discount == ACTIVE
                //                     ? true
                //                     : false;
                //           },
                //           activeColor: Colors.transparent,
                //         ),
                //       ),
                //       title: const SizedBox(
                //         width: 100,
                //         child: Row(
                //             mainAxisAlignment: MainAxisAlignment.start,
                //             children: [
                //               Icon(
                //                 Icons.price_change,
                //                 color: Colors.transparent,
                //               ),
                //               SizedBox(
                //                 width: 10,
                //               ),
                //               Text(
                //                 "Tổng ước tính",
                //                 style: textStylePriceBold16,
                //               ),
                //             ]),
                //       ),
                //       trailing: Text(
                //         Utils.formatCurrency(widget.bill.total_estimate_amount),
                //         style: textStylePriceBold16,
                //       ),
                //     )),
                Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width * 0.9,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: ListTile(
                      leading: Theme(
                        data: ThemeData(unselectedWidgetColor: primaryColor),
                        child: Checkbox(
                          value: isCheckedGTGT,
                          onChanged: (bool? value) {
                            isCheckedGTGT = widget.bill.order!.is_vat == ACTIVE
                                ? true
                                : false;
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
                        Utils.formatCurrency(widget.bill.vat_amount),
                        style: textStylePriceBold16,
                      ),
                    )),
                Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width * 0.9,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: ListTile(
                      leading: Theme(
                        data: ThemeData(unselectedWidgetColor: primaryColor),
                        child: Checkbox(
                          value: isCheckedDecrease,
                          onChanged: (bool? value) {
                            isCheckedDecrease =
                                widget.bill.order!.is_discount == ACTIVE
                                    ? true
                                    : false;
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
                        Utils.formatCurrency(widget.bill.discount_amount),
                        style: textStylePriceBold16,
                      ),
                    )),
                marginBottom30
              ],
            ),
          )
        ],
      ),
    );
  }
}
