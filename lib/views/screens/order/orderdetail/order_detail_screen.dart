import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/views/screens/payment/payment_screen.dart';

class OrderdetailPage extends StatefulWidget {
  const OrderdetailPage({super.key});

  @override
  State<OrderdetailPage> createState() => _OrderdetailPageState();
}

class _OrderdetailPageState extends State<OrderdetailPage> {
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
        title: const Center(child: Text("#05062001 - A4")),
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
            child: const SizedBox(
              height: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                      child: Text(
                    "TỔNG TẠM TÍNH",
                    style: textStyleGrayBold,
                  )),
                  Center(child: Text("500,000", style: textStylePriceBold20))
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
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: 20,
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
                            child: Slidable(
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
                                    onPressed: (context) => doNothing(),
                                    backgroundColor: cancelFoodColor,
                                    foregroundColor: textWhiteColor,
                                    icon: Icons.cancel,
                                    label: 'Hủy món',
                                  ),
                                ],
                              ),
                              child: ListTile(
                                selectedColor: primaryColor,
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Image.asset(
                                    "assets/images/lykem.jpg",
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                title: const Text("Vũ nữ chân dài ",
                                    style: textStyleFoodNameBold16),
                                // subtitle: const Text("HOÀN THÀNH",
                                //     style: textStyleSeccess),
                                subtitle: const Text("ĐANG CHẾ BIẾN",
                                    style: textStyleMaking),
                                trailing: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("40,000",
                                        style: textStylePriceBlackRegular16),
                                    SizedBox(
                                      width: 100,
                                      child: Row(
                                        children: [
                                          Text("Số lượng: ",
                                              style:
                                                  textStylePriceBlackRegular16),
                                          Text("999", style: textStyleSeccess),
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
              ),
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
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) =>
                          //              AddFoodToOrderPage(tableId: "",)))
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
                                  builder: (context) => const PaymentPage()))
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
