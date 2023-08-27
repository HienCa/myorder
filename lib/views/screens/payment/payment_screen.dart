import 'package:flutter/material.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/views/screens/payment/dialog_decrease_price.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  int selectedIndex = 0;
  bool isCheckedGTGT = false;
  bool isCheckedDecrease = false;
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
                    "TỔNG THANH TOÁN",
                    style: textStyleGrayBold,
                  )),
                  Center(child: Text("500,000", style: textStylePriceBold20))
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
            child: Column(
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: labelBlackColor,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Số hóa đơn",
                      style: textStyleFoodNameBold16,
                    ),
                    SizedBox(width: 5),
                    Text(
                      ":",
                      style: textStyleFoodNameBold16,
                    ),
                    SizedBox(width: 20),
                    Text(
                      "#05062001",
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
                const Row(
                  children: [
                    Icon(
                      Icons.date_range,
                      color: labelBlackColor,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Ngày lập",
                      style: textStyleFoodNameBold16,
                    ),
                    SizedBox(width: 23),
                    Text(
                      ":",
                      style: textStyleFoodNameBold16,
                    ),
                    SizedBox(width: 20),
                    Text(
                      "27/08/2023 8:30",
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
                          child: const Text(
                            'Nguyễn Văn Hiền đang cảm thấy cu đơn',
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
                itemCount: 10,
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
                              subtitle: const Text("HOÀN THÀNH",
                                  style: textStyleSeccess),
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
                        )),
                  );
                },
              ),
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
                            setState(() {
                              isCheckedDecrease = !isCheckedDecrease;
                              if (isCheckedDecrease) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const CustomDialogDecreasePrice(); // Hiển thị hộp thoại tùy chỉnh
                                  },
                                );
                              }
                            })
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
                                      return const CustomDialogDecreasePrice(); // Hiển thị hộp thoại tùy chỉnh
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
