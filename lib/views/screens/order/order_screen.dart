// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/orders/orders_controller.dart';
import 'package:myorder/utils.dart';
import 'package:myorder/views/screens/order/orderdetail/order_detail_screen.dart';
import 'package:myorder/views/screens/payment/payment_screen.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  OrderController orderController = Get.put(OrderController());
  String keySearch = "";
  String employeeIdSelected = defaultEmployee;
  int selectedIndex = 0;
  List options = ['Tất cả', 'Của tôi'];
  @override
  void initState() {
    super.initState();
    orderController.getOrders(defaultEmployee, keySearch);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      bottom: false,
      child: Column(
        children: <Widget>[
          Container(
            height: 50,
            width: 400,
            margin: const EdgeInsets.all(kDefaultPadding),
            padding: const EdgeInsets.symmetric(
              horizontal: kDefaultPadding,
              vertical: kDefaultPadding / 4, // 5 top and bottom
            ),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.4),
                borderRadius: borderRadiusTextField30,
                border: Border.all(width: 1, color: borderColorPrimary)),
            child: TextField(
              onChanged: (value) => {
                setState(() {
                  keySearch = value;
                  orderController.getOrders(employeeIdSelected, value);
                }),
                print(value)
              },
              style: const TextStyle(color: borderColorPrimary),
              decoration: const InputDecoration(
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                fillColor: borderColorPrimary,
                icon: Icon(
                  Icons.search,
                  color: iconColorPrimary,
                ),
                hintText: 'Tìm kiếm đơn hàng ...',
                hintStyle: TextStyle(color: borderColorPrimary),
              ),
              cursorColor: borderColorPrimary,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
            height: 35,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: options.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                    if (index == 0) {
                      employeeIdSelected = defaultEmployee; // tat ca nhan vien
                    } else {
                      employeeIdSelected =
                          authController.user.uid; // user dang login
                    }
                    orderController.getOrders(employeeIdSelected, keySearch);
                    print(employeeIdSelected);
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                    left: kDefaultPadding,
                    // At end item it add extra 20 right  padding
                    right: index == options.length - 1 ? kDefaultPadding : 0,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  decoration: BoxDecoration(
                      color:
                          index == selectedIndex ? kBlueColor : textWhiteColor,
                      borderRadius: BorderRadius.circular(20),
                      border: index == selectedIndex
                          ? Border.all(width: 5, color: borderColorPrimary)
                          : Border.all(width: 1, color: borderColorPrimary)),
                  child: Text(
                    options[index],
                    style: index == selectedIndex
                        ? const TextStyle(
                            color: textWhiteColor, fontWeight: FontWeight.bold)
                        : const TextStyle(
                            color: primaryColor, fontWeight: FontWeight.normal),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 70),
                  decoration: const BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                ),
                Obx(() {
                  return ListView.builder(
                    itemCount: orderController.orders.length,
                    itemBuilder: (context, index) {
                      DateTime createTime = orderController
                          .orders[index].create_at
                          .toDate(); // Điền vào thời gian tạo đơn hàng từ Firebase
                      DateTime now = DateTime.now();

                      Duration timeDifference = now.difference(createTime);

                      String formattedTime = DateFormat('HH:mm').format(
                          DateTime(
                              0,
                              0,
                              timeDifference.inDays,
                              timeDifference.inHours % 24,
                              timeDifference.inMinutes % 60,
                              timeDifference.inSeconds % 60));
                      return Container(
                        decoration: BoxDecoration(
                          color: tableservingColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin: const EdgeInsets.symmetric(
                          horizontal: kDefaultPadding,
                          vertical: kDefaultPadding / 2,
                        ),
                        // color: Colors.blueAccent,
                        height: 160,
                        child: InkWell(
                          onTap: () => {},
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: <Widget>[
                              // Those are our background
                              Container(
                                height: 136,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(22),
                                  color: kBlueColor,
                                  boxShadow: const [kDefaultShadow],
                                ),
                                child: Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(22),
                                  ),
                                ),
                              ),
                              // our order image
                              Positioned(
                                bottom: 0,
                                left: -20,
                                child: Hero(
                                  tag: 1,
                                  child: InkWell(
                                    onTap: () => {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                   OrderdetailPage(order: orderController.orders[index],)))
                                    },
                                    child: Container(
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(22),
                                            topRight: Radius.circular(22),
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: kDefaultPadding),
                                        height: 160,
                                        // image is square but we add extra 20 + 20 padding thats why width is 200
                                        width: 200,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              22), // Thay đổi giá trị của borderRadius tùy theo nhu cầu
                                          child: Image.asset(
                                            "assets/images/table5.jpg",
                                            fit: BoxFit.cover,
                                          ),
                                        )),
                                  ),
                                ),
                              ),
                              // order title and price
                              Positioned(
                                top: 0,
                                right: 0,
                                child: SizedBox(
                                  height: 100,
                                  // our image take 200 width, thats why we set out total width - 200
                                  width: size.width - 200,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: kDefaultPadding,
                                        ),
                                        decoration: const BoxDecoration(
                                          color: kBlueColor,
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(22),
                                          ),
                                        ),
                                        child:  Text(
                                          formattedTime,// thời gian khách đã ăn
                                          style: textStyleWhiteBold20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 22,
                                right: 10,
                                child: SizedBox(
                                  height: 136,
                                  // our image take 200 width, thats why we set out total width - 200
                                  width: size.width - 200,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal:
                                              kDefaultPadding, // 30 padding
                                          vertical: kDefaultPadding /
                                              4, // 5 top and bottom
                                        ),
                                        decoration: const BoxDecoration(
                                          color: kBlueColor,
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(22),
                                          ),
                                        ),
                                        child: Text(
                                          Utils.formatCurrency(orderController
                                                  .orders[index].total_amount ??
                                              0),
                                          style: textStyleWhiteBold20,
                                        ),
                                      ),
                                      const Spacer(),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: kDefaultPadding),
                                        child: Text(
                                          orderController
                                                  .orders[index].table!.name ,
                                          style: textStylePrimaryBold,
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: kDefaultPadding),
                                        child: Text(
                                          "A5, A6",
                                          style: textStyleSecondBold,
                                        ),
                                      ),
                                      // it use the available space
                                      const Spacer(),
                                      Container(
                                        width: size.width - 200,
                                        padding: const EdgeInsets.only(
                                            right: 10, bottom: 10),
                                        // padding: const EdgeInsets.symmetric(
                                        //   horizontal: kDefaultPadding * 2, // 30 padding
                                        //   vertical: kDefaultPadding / 4, // 5 top and bottom
                                        // ),
                                        decoration: const BoxDecoration(
                                          color: backgroundColor,
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(20)),
                                        ),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                height: 30,
                                                width: 30,
                                                decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  color: kBlueColor,
                                                ),
                                                child: InkWell(
                                                    onTap: () => {},
                                                    child: const Icon(
                                                        Icons.more_horiz)),
                                              ),
                                              const SizedBox(width: 10),
                                              Container(
                                                height: 30,
                                                width: 30,
                                                decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  color: kBlueColor,
                                                ),
                                                child: InkWell(
                                                    onTap: () => {},
                                                    child: const Icon(Icons
                                                        .card_giftcard_outlined)),
                                              ),
                                              const SizedBox(width: 10),
                                              Container(
                                                height: 30,
                                                width: 30,
                                                decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  color: kBlueColor,
                                                ),
                                                child: InkWell(
                                                    onTap: () => {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                           PaymentPage(order: orderController.orders[index],)))
                                                        },
                                                    child: const Icon(Icons
                                                        .receipt_long_outlined)),
                                              ),
                                            ]),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                })
              ],
            ),
          ),
        ],
      ),
    );
  }
}
