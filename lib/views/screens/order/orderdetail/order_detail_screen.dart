// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/discount/discounts_controller.dart';
import 'package:myorder/controllers/orders/orders_controller.dart';
import 'package:myorder/controllers/vats/vats_controller.dart';
import 'package:myorder/models/order.dart';
import 'package:myorder/utils.dart';
import 'package:myorder/views/screens/order/orderdetail/add_food_to_order_screen.dart';

import 'package:myorder/views/screens/payment/payment_screen.dart';

class OrderdetailPage extends StatefulWidget {
  final Order order;
  const OrderdetailPage({super.key, required this.order});

  @override
  State<OrderdetailPage> createState() => _OrderdetailPageState();
}

class _OrderdetailPageState extends State<OrderdetailPage> {
  OrderController orderController = Get.put(OrderController());
  //Load trước danh sách vat và discount trước khi vào thanh toán (nếu không sẽ nhận về mảng rỗng vì get discounts và vats mà chưa từng gọi trong controller)
  DiscountController discountController = Get.put(DiscountController());
  VatController vatController = Get.put(VatController());
  @override
  void initState() {
    super.initState();
    orderController.getOrderDetailById(widget.order);

    discountController.getActiveDiscounts();
    vatController.getActiveVats();
  }

  int selectedIndex = 0;
  bool isChecked = false;
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
                    "TỔNG TẠM TÍNH",
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
                              child: (orderController
                                              .orderDetail
                                              .order_details[index]
                                              .food_status !=
                                          FOOD_STATUS_CANCEL &&
                                      orderController
                                              .orderDetail
                                              .order_details[index]
                                              .food_status !=
                                          FOOD_STATUS_FINISH)
                                  ? Slidable(
                                      key: const ValueKey(0),
                                      endActionPane: ActionPane(
                                        motion: const ScrollMotion(),
                                        children: [
                                          SlidableAction(
                                            onPressed: (context) => doNothing(),
                                            backgroundColor: primaryColor,
                                            foregroundColor: textWhiteColor,
                                            icon: Icons.splitscreen,
                                            label: 'Tách món',
                                          ),
                                          SlidableAction(
                                            onPressed: (context) => {
                                              orderController.cancelFoodByOrder(
                                                  widget.order.order_id,
                                                  orderController
                                                      .orderDetail
                                                      .order_details[index]
                                                      .order_detail_id),
                                              print("YÊU CẦU HỦY MÓN"),
                                              print(
                                                  "Order: ${orderController.orderDetail.order_id}"),
                                              print(
                                                  "Food: ${orderController.orderDetail.order_details[index].order_detail_id}"),
                                            },
                                            backgroundColor: cancelFoodColor,
                                            foregroundColor: textWhiteColor,
                                            icon: Icons.cancel,
                                            label: 'Hủy món',
                                          )
                                        ],
                                      ),
                                      child: ListTile(
                                        selectedColor: primaryColor,
                                        leading: orderController
                                                    .orderDetail
                                                    .order_details[index]
                                                    .food !=
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
                                            orderController
                                                .orderDetail
                                                .order_details[index]
                                                .food!
                                                .name,
                                            style: textStyleFoodNameBold16),
                                        subtitle: Text(
                                          FOOD_STATUS_IN_CHEFT_STRING,
                                          style: textStyleMaking,
                                        ),
                                        trailing: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                                Utils.formatCurrency(
                                                    orderController
                                                        .orderDetail
                                                        .order_details[index]
                                                        .price),
                                                style:
                                                    textStylePriceBlackRegular16),
                                            SizedBox(
                                              width: 100,
                                              child: Row(
                                                children: [
                                                  const Text("Số lượng: ",
                                                      style:
                                                          textStylePriceBlackRegular16),
                                                  Text(
                                                      "${orderController.orderDetail.order_details[index].quantity}",
                                                      style: textStyleMaking),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : orderController
                                              .orderDetail
                                              .order_details[index]
                                              .food_status ==
                                          FOOD_STATUS_FINISH
                                      ? Slidable(
                                          key: const ValueKey(0),
                                          endActionPane: ActionPane(
                                            motion: const ScrollMotion(),
                                            children: [
                                              SlidableAction(
                                                onPressed: (context) =>
                                                    doNothing(),
                                                backgroundColor: primaryColor,
                                                foregroundColor: textWhiteColor,
                                                icon: Icons.splitscreen,
                                                label: 'Tách món',
                                              ),
                                            ],
                                          ),
                                          child: ListTile(
                                            selectedColor: primaryColor,
                                            leading: orderController
                                                        .orderDetail
                                                        .order_details[index]
                                                        .food !=
                                                    null
                                                ? ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
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
                                                    child: Image.asset(
                                                      "assets/images/lykem.jpg",
                                                      width: 50,
                                                      height: 50,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                            title: Text(
                                                orderController
                                                    .orderDetail
                                                    .order_details[index]
                                                    .food!
                                                    .name,
                                                style: textStyleFoodNameBold16),
                                            subtitle: Text(
                                              FOOD_STATUS_FINISH_STRING,
                                              style: textStyleSeccess,
                                            ),
                                            trailing: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                    Utils.formatCurrency(
                                                        orderController
                                                            .orderDetail
                                                            .order_details[
                                                                index]
                                                            .price),
                                                    style:
                                                        textStylePriceBlackRegular16),
                                                SizedBox(
                                                  width: 100,
                                                  child: Row(
                                                    children: [
                                                      const Text("Số lượng: ",
                                                          style:
                                                              textStylePriceBlackRegular16),
                                                      Text(
                                                          "${orderController.orderDetail.order_details[index].quantity}",
                                                          style:
                                                              textStyleSeccess),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      : Slidable(
                                          key: const ValueKey(0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: backgroundCancelFoodColor,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: ListTile(
                                              tileColor: Colors.redAccent,
                                              selectedColor: primaryColor,
                                              leading: orderController
                                                          .orderDetail
                                                          .order_details[index]
                                                          .food !=
                                                      null
                                                  ? ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      child: Image.network(
                                                        orderController
                                                            .orderDetail
                                                            .order_details[
                                                                index]
                                                            .food!
                                                            .image,
                                                        width: 50,
                                                        height: 50,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    )
                                                  : ClipRRect(
                                                      child: Image.asset(
                                                        "assets/images/lykem.jpg",
                                                        width: 50,
                                                        height: 50,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                              title: Text(
                                                  orderController
                                                      .orderDetail
                                                      .order_details[index]
                                                      .food!
                                                      .name,
                                                  style:
                                                      textStyleFoodNameBold16),
                                              subtitle: Text(
                                                FOOD_STATUS_CANCEL_STRING,
                                                style: textStyleCancel,
                                              ),
                                              trailing: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                      Utils.formatCurrency(
                                                          orderController
                                                              .orderDetail
                                                              .order_details[
                                                                  index]
                                                              .price),
                                                      style:
                                                          textStylePriceBlackRegular16),
                                                  SizedBox(
                                                    width: 100,
                                                    child: Row(
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
                            ),
                          )),
                    );
                  },
                );
              }),
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 10),
              Container(
                  height: 60,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: const BoxDecoration(
                    color: backgroundColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddFoodToOrderPage(
                                        table: widget.order.table!,
                                      )))
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.fastfood),
                                Text(
                                  "Thêm món",
                                  style: textStyleWhiteRegular16,
                                )
                              ]),
                        ),
                      ),
                      InkWell(
                        onTap: () => {},
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.splitscreen),
                                Text(
                                  "Tách món",
                                  style: textStyleWhiteRegular16,
                                )
                              ]),
                        ),
                      ),
                      InkWell(
                        onTap: () => {},
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.card_giftcard),
                                Text(
                                  "Tặng món",
                                  style: textStyleWhiteRegular16,
                                )
                              ]),
                        ),
                      ),
                      InkWell(
                        onTap: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PaymentPage(order: widget.order,),
                              ))
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.receipt_long_outlined),
                                Text(
                                  "Thanh toán",
                                  style: textStyleWhiteRegular16,
                                )
                              ]),
                        ),
                      ),
                    ],
                  )),
              const SizedBox(height: 10),
            ],
          )
        ],
      ),
    );
  }
}

void doNothing() {
  // This function does nothing.
}
