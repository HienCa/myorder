// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/discounts/discounts_controller.dart';
import 'package:myorder/controllers/orders/orders_controller.dart';
import 'package:myorder/controllers/vats/vats_controller.dart';
import 'package:myorder/models/order.dart' as model;
import 'package:myorder/models/order_detail.dart';
import 'package:myorder/utils.dart';
import 'package:myorder/views/screens/order/actions/split/food/choose_target_table_split_single_food_screen.dart';
import 'package:myorder/views/screens/order/actions/split/food/choose_target_table_split_multi_food_screen.dart';
import 'package:myorder/views/screens/order/orderdetail/add_food_to_order_screen.dart';
import 'package:myorder/views/screens/order/orderdetail/add_gift_food_to_order_screen.dart';
import 'package:myorder/views/screens/order/orderdetail/dialog_confirm_update_quantity.dart';
import 'package:myorder/views/screens/order/orderdetail/dialogs/dialog_confirm_finish_foos.dart';

import 'package:myorder/views/screens/payment/payment_screen.dart';
import 'package:myorder/views/widgets/dialogs.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

class OrderdetailPage extends StatefulWidget {
  final model.Order order;
  const OrderdetailPage({super.key, required this.order});

  @override
  State<OrderdetailPage> createState() => _OrderdetailPageState();
}

class _OrderdetailPageState extends State<OrderdetailPage> {
  OrderController orderController = Get.put(OrderController());
  //Load trước danh sách vat và discount trước khi vào thanh toán (nếu không sẽ nhận về mảng rỗng vì get discounts và vats mà chưa từng gọi trong controller)
  DiscountController discountController = Get.put(DiscountController());
  VatController vatController = Get.put(VatController());
  late Future<dynamic> fetchData;
  @override
  void initState() {
    super.initState();
    //kiểm tra có bất kỳ món nào còn "CHỜ CHẾ BIẾN"
    isAnyFoodCooking = Utils.isAnyFoodCooking(widget.order.order_details);
    fetchData = orderController.getOrderDetailById(widget.order);
    _refreshOrderDetailArray();
    orderController.getTotalAmountById(widget.order);

    discountController.getActiveDiscounts();
    vatController.getActiveVats();

    print("orderDetailOriginArray: $orderDetailOriginArray");
    print("orderDetailOriginArray: ${orderDetailOriginArray.length}");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void _refreshOrderDetailArray() {
    getAllOrderDetails(widget.order.order_id);
    print(orderDetailOriginArray.length);
    print("========================Refeshing(========================");
    for (int i = 0; i < orderDetailOriginArray.length; i++) {
      print(orderDetailOriginArray[i].food!.name);
    }
    print("========================Refeshed(========================");
  }

  bool isAnyFoodCooking = false;
  int selectedIndex = 0;
  bool isChecked = false;
  bool hasChanges = false;
  List<OrderDetail> orderDetailNeedSplitArray = [];
  List<OrderDetail> orderDetailOriginArray = [];

  void decreaseQuantity(OrderDetail orderDetail) {
    print("Muốn giảm");
    for (int i = 0; i < orderDetailOriginArray.length; i++) {
      if (orderDetailOriginArray[i].order_detail_id == orderDetail.order_detail_id) {
        if (orderDetail.quantity > 1) {
          orderDetail.quantity = orderDetail.quantity - 1;
        }

        //nếu thay đổi về số lượng thì isSelected = true
        orderDetail.isSelected =
            Utils.isQuantityChanged(orderDetailOriginArray, orderDetail);

        orderDetailOriginArray[i].isSelected = orderDetail.isSelected;

        print(
            "orderDetailOriginArray[i].isSelected: ${orderDetailOriginArray[i].isSelected}");

        print(
            "số lượng orderDetailOriginArray: ${orderDetail.food!.name} : ${orderDetailOriginArray[i].quantity}");
        print(
            "Đã giảm số lượng orderDetail: ${orderDetail.food!.name} : ${orderDetail.quantity}");
      }
    }
  }

  void increaseQuantity(OrderDetail orderDetail) {
    for (int i = 0; i < orderDetailOriginArray.length; i++) {
      if (orderDetailOriginArray[i].order_detail_id == orderDetail.order_detail_id) {
        orderDetail.quantity = orderDetail.quantity + 1;

        //nếu thay đổi về số lượng thì isSelected = true
        orderDetail.isSelected =
            Utils.isQuantityChanged(orderDetailOriginArray, orderDetail);
        orderDetailOriginArray[i].isSelected = orderDetail.isSelected;

        print(
            "orderDetailOriginArray[i].isSelected: ${orderDetailOriginArray[i].isSelected}");
        print(
            "Số lượng orderDetailOriginArray: ${orderDetail.food!.name} : ${orderDetailOriginArray[i].quantity}");
        print(
            "Đã tăng số lượng orderDetail: ${orderDetail.food!.name} : ${orderDetail.quantity}");
      }
    }
  }

  void getAllOrderDetails(String id) async {
    try {
      QuerySnapshot orderDetailDocs = await FirebaseFirestore.instance
          .collection('orders')
          .doc(id)
          .collection('orderDetails')
          .get();

      List<OrderDetail> orderDetails =
          orderDetailDocs.docs.map((doc) => OrderDetail.fromSnap(doc)).toList();
      orderDetailOriginArray = [];
      orderDetailOriginArray = orderDetails;

      //kiểm tra có bất kỳ món nào còn "CHỜ CHẾ BIẾN"
      isAnyFoodCooking = Utils.isAnyFoodCooking(orderDetailOriginArray);
      print(
          'Error getting all order detailsisAnyFoodCooking: $isAnyFoodCooking');
      print(
          'Error getting all order detailsisAnyFoodCooking: ${orderController.orderDetail.order_details}');
    } catch (e) {
      print('Error getting all order details: $e');
    }
  }

  void refeshOrderDetailOriginArray() {
    for (int i = 0; i < orderController.orderDetail.order_details.length; i++) {
      orderController.orderDetail.order_details[i].isSelected = false;
      orderDetailOriginArray = orderController.orderDetail.order_details;
      print(orderDetailOriginArray[i].quantity);
    }
    isAnyFoodCooking = Utils.isAnyFoodCooking(orderDetailOriginArray);
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
        body: FutureBuilder(
          future: fetchData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              // Hiển thị nhiều widget khi dữ liệu đã sẵn sàng
              return Column(
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
                                    orderController.order.total_amount),
                                style: textStylePriceBold20);
                          }))
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(
                          left: 0, right: 0, top: 0, bottom: 0),
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
                          itemCount:
                              orderController.orderDetail.order_details.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.all(
                                  4), // Khoảng cách dưới dạng đệm

                              decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 0.1, color: borderColor)),
                              ),
                              child: GestureDetector(
                                  onTap: () {},
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                    child: InkWell(
                                      onTap: () => {},
                                      child:
                                          (orderController
                                                          .orderDetail
                                                          .order_details[index]
                                                          .food_status !=
                                                      FOOD_STATUS_CANCEL &&
                                                  orderController
                                                          .orderDetail
                                                          .order_details[index]
                                                          .food_status !=
                                                      FOOD_STATUS_FINISH &&
                                                  orderController
                                                          .orderDetail
                                                          .order_details[index]
                                                          .food_status !=
                                                      FOOD_STATUS_COOKING)
                                              ? Slidable(
                                                  key: const ValueKey(0),
                                                  endActionPane: ActionPane(
                                                    motion:
                                                        const ScrollMotion(),
                                                    children: [
                                                      SlidableAction(
                                                        onPressed: (context) =>
                                                            {
                                                          print(
                                                              "=================Món muốn tách==============="),
                                                          print(orderController
                                                              .orderDetail
                                                              .order_details[
                                                                  index]
                                                              .food!
                                                              .name),
                                                          orderController
                                                              .orderDetail
                                                              .order_details[
                                                                  index]
                                                              .isSelected = true,
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return ChooseTargetTableSplitSingleFoodPage(
                                                                order: orderController
                                                                    .orderDetail,
                                                                orderDetailNeedSplitArray: [
                                                                  orderController
                                                                      .orderDetail
                                                                      .order_details[index]
                                                                ],
                                                              );
                                                            },
                                                          )
                                                        },
                                                        backgroundColor:
                                                            primaryColor,
                                                        foregroundColor:
                                                            textWhiteColor,
                                                        icon: Icons.splitscreen,
                                                        label: 'Tách món',
                                                      ),
                                                      SlidableAction(
                                                        onPressed: (context) =>
                                                            {
                                                          showCustomAlertDialogConfirm(
                                                            context,
                                                            "YÊU CẦU HỦY MÓN",
                                                            "Có chắc chắn muốn hủy món \"${orderController.orderDetail.order_details[index].food!.name}\" ?",
                                                            colorWarning,
                                                            () async {
                                                              orderController.cancelFoodByOrder(
                                                                  context,
                                                                  widget.order,
                                                                  orderController
                                                                      .orderDetail
                                                                      .order_details[index]);
                                                            },
                                                          ),
                                                          print(
                                                              "YÊU CẦU HỦY MÓN"),
                                                          print(
                                                              "Order: ${orderController.orderDetail.order_id}"),
                                                          print(
                                                              "Food: ${orderController.orderDetail.order_details[index].order_detail_id}"),
                                                        },
                                                        backgroundColor:
                                                            cancelFoodColor,
                                                        foregroundColor:
                                                            textWhiteColor,
                                                        icon: Icons.cancel,
                                                        label: 'Hủy món',
                                                      )
                                                    ],
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      ListTile(
                                                        selectedColor:
                                                            primaryColor,
                                                        leading: orderController
                                                                    .orderDetail
                                                                    .order_details[
                                                                        index]
                                                                    .food!
                                                                    .image !=
                                                                ''
                                                            ? ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                child: Image
                                                                    .network(
                                                                  orderController
                                                                          .orderDetail
                                                                          .order_details[
                                                                              index]
                                                                          .food!
                                                                          .image ??
                                                                      defaultFoodImageString,
                                                                  width: 50,
                                                                  height: 50,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              )
                                                            : ClipRRect(
                                                                child:
                                                                    defaultFoodImage, // ảnh trong constants
                                                              ),
                                                        title: Text(
                                                            orderController
                                                                .orderDetail
                                                                .order_details[
                                                                    index]
                                                                .food!
                                                                .name,
                                                            style:
                                                                textStyleFoodNameBold16),
                                                        subtitle: Text(
                                                          FOOD_STATUS_IN_CHEF_STRING,
                                                          style:
                                                              textStyleMaking,
                                                        ),
                                                        trailing: orderController
                                                                    .orderDetail
                                                                    .order_details[
                                                                        index]
                                                                    .is_gift ==
                                                                false
                                                            ? Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                      Utils.formatCurrency(orderController
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
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            setState(() {
                                                                              decreaseQuantity(orderController.orderDetail.order_details[index]);
                                                                            });
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: iconColor,
                                                                              borderRadius: BorderRadius.circular(5),
                                                                            ),
                                                                            height:
                                                                                30,
                                                                            width:
                                                                                30,
                                                                            child:
                                                                                const Align(
                                                                              alignment: Alignment.center,
                                                                              child: Icon(Icons.remove, color: Colors.white),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                            width:
                                                                                5),
                                                                        Text(
                                                                            "${orderController.orderDetail.order_details[index].quantity}",
                                                                            style:
                                                                                textStyleMaking),
                                                                        const SizedBox(
                                                                            width:
                                                                                5),
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            setState(() {
                                                                              increaseQuantity(orderController.orderDetail.order_details[index]);
                                                                            });
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: iconColor,
                                                                              borderRadius: BorderRadius.circular(5),
                                                                            ),
                                                                            height:
                                                                                30,
                                                                            width:
                                                                                30,
                                                                            child:
                                                                                const Align(
                                                                              alignment: Alignment.center,
                                                                              child: Icon(Icons.add, color: Colors.white),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )
                                                                ],
                                                              )
                                                            : Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  const Icon(
                                                                      Icons
                                                                          .card_giftcard,
                                                                      color:
                                                                          colorWarning),
                                                                  SizedBox(
                                                                    width: 100,
                                                                    child: Row(
                                                                      children: [
                                                                        const Text(
                                                                            "Số lượng: ",
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
                                                            const Duration(
                                                                milliseconds:
                                                                    300),
                                                        curve: Curves.easeInOut,
                                                        child: Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 70),
                                                          height: orderController
                                                                  .orderDetail
                                                                  .order_details[
                                                                      index]
                                                                  .listCombo
                                                                  .length *
                                                              62,
                                                          child:
                                                              ListView.builder(
                                                            scrollDirection:
                                                                Axis.vertical,
                                                            itemCount:
                                                                orderController
                                                                    .orderDetail
                                                                    .order_details[
                                                                        index]
                                                                    .listCombo
                                                                    .length,
                                                            itemBuilder:
                                                                (context,
                                                                    indexCombo) {
                                                              return Container(
                                                                margin: const EdgeInsets
                                                                    .all(
                                                                    4), // Khoảng cách dưới dạng đệm

                                                                decoration:
                                                                    const BoxDecoration(
                                                                  border: Border(
                                                                      bottom: BorderSide(
                                                                          width:
                                                                              0.1,
                                                                          color:
                                                                              borderColor)),
                                                                ),
                                                                child:
                                                                    GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          setState(
                                                                              () {});
                                                                        },
                                                                        child:
                                                                            AnimatedContainer(
                                                                          duration:
                                                                              const Duration(milliseconds: 300),
                                                                          curve:
                                                                              Curves.easeInOut,
                                                                          // Chiều cao của ListTile thay đổi
                                                                          child:
                                                                              InkWell(
                                                                            onTap: () =>
                                                                                {
                                                                              setState(() {})
                                                                            },
                                                                            child:
                                                                                Column(
                                                                              children: [
                                                                                ListTile(
                                                                                  selectedColor: primaryColor,
                                                                                  leading: Theme(
                                                                                    data: ThemeData(unselectedWidgetColor: primaryColor),
                                                                                    child: SizedBox(
                                                                                      width: 40,
                                                                                      child: Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        children: [
                                                                                          orderController.orderDetail.order_details[index].listCombo[indexCombo].image != ""
                                                                                              ? ClipRRect(
                                                                                                  borderRadius: BorderRadius.circular(5),
                                                                                                  child: Image.network(
                                                                                                    orderController.orderDetail.order_details[index].listCombo[indexCombo].image ?? defaultFoodImageString,
                                                                                                    width: 40,
                                                                                                    height: 40,
                                                                                                    fit: BoxFit.cover,
                                                                                                  ),
                                                                                                )
                                                                                              : ClipRRect(borderRadius: BorderRadius.circular(5), child: defaultFoodImage40),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  title: Marquee(
                                                                                      direction: Axis.horizontal,
                                                                                      textDirection: TextDirection.ltr,
                                                                                      animationDuration: const Duration(seconds: 1),
                                                                                      backDuration: const Duration(milliseconds: 4000),
                                                                                      pauseDuration: const Duration(milliseconds: 1000),
                                                                                      directionMarguee: DirectionMarguee.TwoDirection,
                                                                                      child: RichText(
                                                                                          text: TextSpan(
                                                                                        children: [
                                                                                          TextSpan(text: orderController.orderDetail.order_details[index].listCombo[indexCombo].name, style: orderController.orderDetail.order_details[index].listCombo[indexCombo].isSelected == true ? textStyleWhiteRegular16 : textStyleFoodNameBold16),
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
                                                )
                                              : orderController
                                                          .orderDetail
                                                          .order_details[index]
                                                          .food_status ==
                                                      FOOD_STATUS_FINISH
                                                  ? Slidable(
                                                      key: const ValueKey(0),
                                                      endActionPane: ActionPane(
                                                        motion:
                                                            const ScrollMotion(),
                                                        children: [
                                                          SlidableAction(
                                                            onPressed:
                                                                (context) async {
                                                              print(
                                                                  "=================Món muốn tách===============");
                                                              print(orderController
                                                                  .orderDetail
                                                                  .order_details[
                                                                      index]
                                                                  .food!
                                                                  .name);
                                                              orderController
                                                                  .orderDetail
                                                                  .order_details[
                                                                      index]
                                                                  .isSelected = true;
                                                              final result =
                                                                  await showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return ChooseTargetTableSplitSingleFoodPage(
                                                                    order: orderController
                                                                        .orderDetail,
                                                                    orderDetailNeedSplitArray: [
                                                                      orderController
                                                                          .orderDetail
                                                                          .order_details[index]
                                                                    ],
                                                                  );
                                                                },
                                                              );
                                                              if (result ==
                                                                  'success') {
                                                                // Utils.myPopResult(
                                                                //     context, 'success');
                                                                Utils.showSuccessFlushbar(
                                                                    context,
                                                                    '',
                                                                    'Tách món thành công!');
                                                              } else if (result ==
                                                                  'cancel') {
                                                                Utils.myPopCancel(
                                                                    context);
                                                              }
                                                            },
                                                            backgroundColor:
                                                                primaryColor,
                                                            foregroundColor:
                                                                textWhiteColor,
                                                            icon: Icons
                                                                .splitscreen,
                                                            label: 'Tách món',
                                                          ),
                                                        ],
                                                      ),
                                                      child: ListTile(
                                                        selectedColor:
                                                            primaryColor,
                                                        leading: orderController
                                                                    .orderDetail
                                                                    .order_details[
                                                                        index]
                                                                    .food!
                                                                    .image !=
                                                                ''
                                                            ? ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                child: Image
                                                                    .network(
                                                                  orderController
                                                                          .orderDetail
                                                                          .order_details[
                                                                              index]
                                                                          .food!
                                                                          .image ??
                                                                      defaultFoodImageString,
                                                                  width: 50,
                                                                  height: 50,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              )
                                                            : ClipRRect(
                                                                child:
                                                                    defaultFoodImage,
                                                              ),
                                                        title: Text(
                                                            orderController
                                                                .orderDetail
                                                                .order_details[
                                                                    index]
                                                                .food!
                                                                .name,
                                                            style:
                                                                textStyleFoodNameBold16),
                                                        subtitle: Text(
                                                          FOOD_STATUS_FINISH_STRING,
                                                          style:
                                                              textStyleSeccess,
                                                        ),
                                                        trailing: orderController
                                                                    .orderDetail
                                                                    .order_details[
                                                                        index]
                                                                    .is_gift ==
                                                                false
                                                            ? Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                      Utils.formatCurrency(orderController
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
                                                                        const Text(
                                                                            "Số lượng: ",
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
                                                              )
                                                            : Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  const Icon(
                                                                      Icons
                                                                          .card_giftcard,
                                                                      color:
                                                                          colorWarning),
                                                                  SizedBox(
                                                                    width: 100,
                                                                    child: Row(
                                                                      children: [
                                                                        const Text(
                                                                            "Số lượng: ",
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
                                                    )
                                                  : orderController
                                                              .orderDetail
                                                              .order_details[
                                                                  index]
                                                              .food_status ==
                                                          FOOD_STATUS_COOKING
                                                      ? Slidable(
                                                          key:
                                                              const ValueKey(0),
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  secondColor,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            child: ListTile(
                                                              tileColor:
                                                                  secondColor,
                                                              selectedColor:
                                                                  primaryColor,
                                                              leading: orderController
                                                                          .orderDetail
                                                                          .order_details[
                                                                              index]
                                                                          .food!
                                                                          .image !=
                                                                      ''
                                                                  ? ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5),
                                                                      child: Image
                                                                          .network(
                                                                        orderController.orderDetail.order_details[index].food!.image ??
                                                                            defaultFoodImageString,
                                                                        width:
                                                                            50,
                                                                        height:
                                                                            50,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    )
                                                                  : ClipRRect(
                                                                      child:
                                                                          defaultFoodImage),
                                                              title: Text(
                                                                  orderController
                                                                      .orderDetail
                                                                      .order_details[
                                                                          index]
                                                                      .food!
                                                                      .name,
                                                                  style:
                                                                      textStyleFoodNameBold16),
                                                              subtitle: Text(
                                                                FOOD_STATUS_COOKING_STRING,
                                                                style:
                                                                    textStyleCooking,
                                                              ),
                                                              trailing: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                      Utils.formatCurrency(orderController
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
                                                                        const Text(
                                                                            "Số lượng: ",
                                                                            style:
                                                                                textStylePriceBlackRegular16),
                                                                        Text(
                                                                            "${orderController.orderDetail.order_details[index].quantity}",
                                                                            style:
                                                                                textStyleCooking),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      : Slidable(
                                                          key:
                                                              const ValueKey(0),
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  backgroundCancelFoodColor,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            child: Column(
                                                              children: [
                                                                ListTile(
                                                                  tileColor: Colors
                                                                      .redAccent,
                                                                  selectedColor:
                                                                      primaryColor,
                                                                  leading: orderController
                                                                              .orderDetail
                                                                              .order_details[
                                                                                  index]
                                                                              .food!
                                                                              .image !=
                                                                          ''
                                                                      ? ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(5),
                                                                          child:
                                                                              Image.network(
                                                                            orderController.orderDetail.order_details[index].food!.image ??
                                                                                defaultFoodImageString,
                                                                            width:
                                                                                50,
                                                                            height:
                                                                                50,
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          ),
                                                                        )
                                                                      : ClipRRect(
                                                                          child:
                                                                              defaultFoodImage),
                                                                  title: Text(
                                                                      orderController
                                                                          .orderDetail
                                                                          .order_details[
                                                                              index]
                                                                          .food!
                                                                          .name,
                                                                      style:
                                                                          textStyleFoodNameBold16),
                                                                  subtitle:
                                                                      Text(
                                                                    FOOD_STATUS_CANCEL_STRING,
                                                                    style:
                                                                        textStyleCancel,
                                                                  ),
                                                                  trailing: orderController
                                                                              .orderDetail
                                                                              .order_details[index]
                                                                              .is_gift ==
                                                                          false
                                                                      ? Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Text(Utils.formatCurrency(orderController.orderDetail.order_details[index].price),
                                                                                style: textStylePriceBlackRegular16),
                                                                            SizedBox(
                                                                              width: 100,
                                                                              child: Row(
                                                                                children: [
                                                                                  const Text("Số lượng: ", style: textStylePriceBlackRegular16),
                                                                                  Text("${orderController.orderDetail.order_details[index].quantity}", style: textStyleCancel),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        )
                                                                      : Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            const Icon(Icons.card_giftcard,
                                                                                color: secondColor),
                                                                            SizedBox(
                                                                              width: 100,
                                                                              child: Row(
                                                                                children: [
                                                                                  const Text("Số lượng: ", style: textStylePriceBlackRegular16),
                                                                                  Text("${orderController.orderDetail.order_details[index].quantity}", style: textStyleCancel),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                ),
                                                                //Danh sách Combo
                                                                AnimatedContainer(
                                                                  duration: const Duration(
                                                                      milliseconds:
                                                                          300),
                                                                  curve: Curves
                                                                      .easeInOut,
                                                                  child:
                                                                      Container(
                                                                    margin: const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            70),
                                                                    height: orderController
                                                                            .orderDetail
                                                                            .order_details[index]
                                                                            .listCombo
                                                                            .length *
                                                                        62,
                                                                    child: ListView
                                                                        .builder(
                                                                      scrollDirection:
                                                                          Axis.vertical,
                                                                      itemCount: orderController
                                                                          .orderDetail
                                                                          .order_details[
                                                                              index]
                                                                          .listCombo
                                                                          .length,
                                                                      itemBuilder:
                                                                          (context,
                                                                              indexCombo) {
                                                                        return Container(
                                                                          margin: const EdgeInsets
                                                                              .all(
                                                                              4), // Khoảng cách dưới dạng đệm

                                                                          decoration:
                                                                              const BoxDecoration(
                                                                            border:
                                                                                Border(bottom: BorderSide(width: 0.1, color: borderColor)),
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
                                                                                  onTap: () => {
                                                                                    setState(() {})
                                                                                  },
                                                                                  child: Column(
                                                                                    children: [
                                                                                      ListTile(
                                                                                        selectedColor: primaryColor,
                                                                                        leading: Theme(
                                                                                          data: ThemeData(unselectedWidgetColor: primaryColor),
                                                                                          child: SizedBox(
                                                                                            width: 40,
                                                                                            child: Row(
                                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                                              children: [
                                                                                                orderController.orderDetail.order_details[index].listCombo[indexCombo].image != ""
                                                                                                    ? ClipRRect(
                                                                                                        borderRadius: BorderRadius.circular(5),
                                                                                                        child: Image.network(
                                                                                                          orderController.orderDetail.order_details[index].listCombo[indexCombo].image ?? defaultFoodImageString,
                                                                                                          width: 40,
                                                                                                          height: 40,
                                                                                                          fit: BoxFit.cover,
                                                                                                        ),
                                                                                                      )
                                                                                                    : ClipRRect(borderRadius: BorderRadius.circular(5), child: defaultFoodImage40),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        title: Marquee(
                                                                                            direction: Axis.horizontal,
                                                                                            textDirection: TextDirection.ltr,
                                                                                            animationDuration: const Duration(seconds: 1),
                                                                                            backDuration: const Duration(milliseconds: 4000),
                                                                                            pauseDuration: const Duration(milliseconds: 1000),
                                                                                            directionMarguee: DirectionMarguee.TwoDirection,
                                                                                            child: RichText(
                                                                                                text: TextSpan(
                                                                                              children: [
                                                                                                TextSpan(text: orderController.orderDetail.order_details[index].listCombo[indexCombo].name, style: orderController.orderDetail.order_details[index].listCombo[indexCombo].isSelected == true ? textStyleWhiteRegular16 : textStyleFoodNameBold16),
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
                                    ),
                                  )),
                            );
                          },
                        );
                      }),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      isAnyFoodCooking
                          ? GestureDetector(
                              onTap: () async {
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
                              },
                              child: Container(
                                  height: 50,
                                  width: 170,
                                  padding: const EdgeInsets.all(10),
                                  margin: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: colorWarning,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Transform.rotate(
                                          angle: 320 *
                                              3.1415926535 /
                                              180, // Góc xoay 45 độ (đổi ra radian)
                                          child: const Icon(
                                            Icons.send,
                                            color: secondColor,
                                          ),
                                        ),
                                        const Text(
                                          "Hoàn tất món",
                                          style: textStyleWhiteBold20,
                                        ),
                                      ],
                                    ),
                                  )),
                            )
                          : const SizedBox(),
                      Utils.isAnyOrderDetailSelected(orderDetailOriginArray)
                          ? GestureDetector(
                              onTap: () async {
                                final result = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CustomDialogUpdateQuantityTable(
                                      order: widget.order,
                                    );
                                  },
                                );
                                if (result != null) {
                                  Utils.refeshSelected(orderDetailOriginArray);
                                  setState(() {
                                    Utils.isAnyOrderDetailSelected(
                                        orderController
                                            .orderDetail.order_details);

                                    Utils.showStylishDialog(
                                        context,
                                        'THÀNH CÔNG',
                                        'Số lượng món đã được cập nhật!',
                                        StylishDialogType.SUCCESS);

                                    refeshOrderDetailOriginArray();
                                  });
                                }
                              },
                              child: Container(
                                  height: 50,
                                  width: 100,
                                  padding: const EdgeInsets.all(10),
                                  margin: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: colorSuccess,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Lưu (${Utils.counterOrderDetailSelected(orderController.orderDetail.order_details)})",
                                      style: textStyleWhiteBold20,
                                    ),
                                  )),
                            )
                          : const SizedBox(),
                    ],
                  ),
                  Column(
                    children: [
                      // const SizedBox(height: 10),
                      Container(
                          height: 60,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: const BoxDecoration(
                            color: backgroundColor,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () => {
                                  // thêm món -> không phải món tặng
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AddFoodToOrderPage(
                                                table: widget.order.table!,
                                                booking: false,
                                                isGift: false,
                                              )))
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                onTap: () async {
                                  final result = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return SplitFoodPage(
                                        order: orderController.orderDetail,
                                      );
                                    },
                                  );
                                  if (result == 'success') {
                                    Utils.showSuccessFlushbar(
                                        context, '', 'Tách món thành công!');
                                  } else if (result == 'cancel') {
                                    // Utils.showSuccessFlushbar(
                                    //     context, '', 'Tách món thành công cancel!');
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                onTap: () => {
                                  // là món tặng -> isGift = true
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AddGiftFoodToOrderPage(
                                                table: widget.order.table!,
                                                booking: false,
                                                isGift: true,
                                              )))
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.card_giftcard),
                                        Text(
                                          "Tặng món",
                                          style: textStyleWhiteRegular16,
                                        )
                                      ]),
                                ),
                              ),
                              isAnyFoodCooking
                                  ? InkWell(
                                      onTap: () => {
                                        Utils.showStylishDialog(
                                            context,
                                            'THÔNG BÁO',
                                            'Có một số món chưa được gửi Bếp/Bar. Vui lòng gửi bếp trước khi tiến hành thanh toán.',
                                            StylishDialogType.INFO)
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: const Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.receipt_long_outlined),
                                              Text(
                                                "Thanh toán",
                                                style: textStyleWhiteRegular16,
                                              )
                                            ]),
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () async {
                                        final result = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => PaymentPage(
                                                order: widget.order,
                                              ),
                                            ));
                                        if (result == 'success') {
                                          Utils.myPopResult(context, 'PAID');
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: const Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
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
              );
            }
          },
        ));
  }
}

void doNothing() {
  // This function does nothing.
}
