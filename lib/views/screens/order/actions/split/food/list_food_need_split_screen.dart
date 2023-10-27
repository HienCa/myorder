// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/orders/orders_controller.dart';
import 'package:myorder/models/order_detail.dart';
import 'package:myorder/utils.dart';
import 'package:myorder/models/order.dart' as model1;
import 'package:myorder/models/table.dart' as model2;
import 'package:myorder/views/screens/order/actions/split/food/dialog_confirm_split_food.dart';

class ListFoodNeedSplitPage extends StatefulWidget {
  final model1.Order order;
  final model2.Table table;
  const ListFoodNeedSplitPage(
      {super.key, required this.order, required this.table});

  @override
  State<ListFoodNeedSplitPage> createState() => _ListFoodNeedSplitPageState();
}

class _ListFoodNeedSplitPageState extends State<ListFoodNeedSplitPage> {
  List<String> foodIdArray = [];
  List<OrderDetail> orderDetailNeedSplitArray = [];
  List<OrderDetail> orderDetailNeedSplitArray2 = [];
  int selectedIndex = 0;
  int categoryselectedIndex = 0;
  bool isAddFood = false;
  int quantity = 1; // Số lượng đã chọn
  var categoryIdSelected = defaultCategory;
  OrderController orderController = Get.put(OrderController());

  String keySearch = "";
  @override
  void initState() {
    super.initState();
    // Tạo một bản sao không tham chiếu của danh sách
    orderDetailNeedSplitArray = widget.order.order_details
        .map((orderDetail) => OrderDetail.copy(orderDetail))
        .toList();
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
        title: Center(child: Text("MÓN ĂN BÀN - ${widget.order.table!.name}")),
        backgroundColor: primaryColor,
      ),
      body: Column(
        children: [
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
                  itemCount: widget.order.order_details.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin:
                          const EdgeInsets.all(4), // Khoảng cách dưới dạng đệm

                      decoration: orderDetailNeedSplitArray[index].isSelected ==
                              true
                          ? BoxDecoration(
                              color: const Color(0xFF40BAD5).withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            )
                          : const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 0.1, color: borderColor)),
                            ),
                      child: GestureDetector(
                          onTap: () {
                            setState(() {});
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            // Chiều cao của ListTile thay đổi
                            child: InkWell(
                              onTap: () => {setState(() {})},
                              child: ListTile(
                                selectedColor: primaryColor,
                                leading: Theme(
                                  data: ThemeData(
                                      unselectedWidgetColor: primaryColor),
                                  child: SizedBox(
                                    width: 100,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Checkbox(
                                          value:
                                              orderDetailNeedSplitArray[index]
                                                  .isSelected,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              setState(() {
                                                orderDetailNeedSplitArray[index]
                                                        .isSelected =
                                                    value ?? false;
                                                //kiem tra xem co bat ky mon nao da duoc chon khong
                                                isAddFood =
                                                    Utils.isAnyFoodSelected2(
                                                        orderDetailNeedSplitArray);
                                                print(
                                                    "isChecked - $value: ${orderDetailNeedSplitArray[index].food_id}");
                                              });
                                            });
                                          },
                                          activeColor: primaryColor,
                                        ),
                                        orderDetailNeedSplitArray[index]
                                                    .food!
                                                    .image !=
                                                ""
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                child: Image.network(
                                                  orderDetailNeedSplitArray[
                                                          index]
                                                      .food!
                                                      .image,
                                                  width: 50,
                                                  height: 50,
                                                  fit: BoxFit.cover,
                                                ),
                                              )
                                            : ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                child: Image.asset(
                                                  "assets/images/lykem.jpg",
                                                  width: 50,
                                                  height: 50,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                                title: Marquee(
                                    direction: Axis.horizontal,
                                    textDirection: TextDirection.ltr,
                                    animationDuration:
                                        const Duration(seconds: 1),
                                    backDuration:
                                        const Duration(milliseconds: 4000),
                                    pauseDuration:
                                        const Duration(milliseconds: 1000),
                                    directionMarguee:
                                        DirectionMarguee.TwoDirection,
                                    child: RichText(
                                        text: TextSpan(
                                      children: [
                                        TextSpan(
                                            text:
                                                orderDetailNeedSplitArray[index]
                                                    .food!
                                                    .name,
                                            style: textStyleFoodNameBold16),
                                      ],
                                    ))),
                                subtitle: Text(
                                    Utils.formatCurrency(
                                        orderDetailNeedSplitArray[index].price),
                                    style: textStyleTemporaryPriceDeActive16),
                                trailing: orderDetailNeedSplitArray[index]
                                            .isSelected ==
                                        true
                                    ? SizedBox(
                                        width: 100,
                                        child: Row(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                if (orderDetailNeedSplitArray[
                                                            index]
                                                        .quantity >
                                                    1) {
                                                  setState(() {
                                                    orderDetailNeedSplitArray[
                                                                index]
                                                            .quantity =
                                                        orderDetailNeedSplitArray[
                                                                    index]
                                                                .quantity -
                                                            1;
                                                  });
                                                }
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: iconColor,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                height: 30,
                                                width: 30,
                                                child: const Align(
                                                  alignment: Alignment.center,
                                                  child: Icon(Icons.remove,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                                orderDetailNeedSplitArray[index]
                                                    .quantity
                                                    .toString(),
                                                style: textStyleWhiteBold16),
                                            const SizedBox(width: 5),
                                            InkWell(
                                              onTap: () {
                                                if (orderDetailNeedSplitArray[
                                                            index]
                                                        .quantity <
                                                    widget
                                                        .order
                                                        .order_details[index]
                                                        .quantity) {
                                                  orderDetailNeedSplitArray[
                                                              index]
                                                          .quantity =
                                                      (orderDetailNeedSplitArray[
                                                                  index]
                                                              .quantity +
                                                          1);
                                                }

                                                for (OrderDetail orderDetail
                                                    in widget
                                                        .order.order_details) {
                                                  print(orderDetail.food!.name);
                                                  print(orderDetail.quantity);
                                                }
                                                setState(() {});
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: iconColor,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                height: 30,
                                                width: 30,
                                                child: const Align(
                                                  alignment: Alignment.center,
                                                  child: Icon(Icons.add,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox(),
                              ),
                            ),
                          )),
                    );
                  },
                )),
          ),
          Column(
            children: [
              isAddFood == true
                  ? Column(
                      children: [
                        const SizedBox(height: 10),
                        InkWell(
                          onTap: () async {
                            final result = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CustomDialogSplitFood(
                                    order: widget.order,
                                    table: widget.table,
                                    orderDetailNeedSplitArray:
                                        orderDetailNeedSplitArray);
                              },
                            );
                            if (result == 'success') {
                              Utils.myPopResult(context, 'success');
                            }
                          },
                          child: Container(
                            height: 50,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 0),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                              child: Text(
                                "XÁC NHẬN",
                                style: textStyleWhiteBold20,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    )
                  : const SizedBox(),
            ],
          )
        ],
      ),
    );
  }
}
