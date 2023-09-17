import 'package:flutter/material.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/models/table.dart' as model;

class AddFoodToOrderPage extends StatefulWidget {
  final model.Table table;
  const AddFoodToOrderPage({super.key, required this.table});

  @override
  State<AddFoodToOrderPage> createState() => _AddFoodToOrderPageState();
}

class _AddFoodToOrderPageState extends State<AddFoodToOrderPage> {
  int selectedIndex = 0;
  bool isChecked = false;
  int quantity = 1; // Số lượng đã chọn
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
        title: Center(child: Text("GỌI MÓN - ${widget.table.name}")),
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

                    decoration: isChecked == true
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
                                bottom:
                                    BorderSide(width: 0.1, color: borderColor)),
                          ),
                    child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          // Chiều cao của ListTile thay đổi
                          child: InkWell(
                            onTap: () => {
                              setState(() {
                                isChecked = !isChecked;
                              })
                            },
                            child: ListTile(
                              selectedColor: primaryColor,
                              leading: Theme(
                                data: ThemeData(
                                    unselectedWidgetColor: primaryColor),
                                child: SizedBox(
                                  width: 100,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Checkbox(
                                        value: isChecked,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            isChecked = value!;
                                          });
                                        },
                                        activeColor: primaryColor,
                                      ),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
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
                              title: Text("Vũ nữ chân dài ",
                                  style: isChecked == true
                                      ? textStyleWhiteRegular16
                                      : textStyleFoodNameBold16),
                              subtitle: Text("40,000 / dĩa",
                                  style: isChecked == true
                                      ? textStyleWhiteBold16
                                      : textStyleFoodNameBold16),
                              trailing: isChecked
                                  ? SizedBox(
                                      width: 100,
                                      child: Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              if (quantity > 1) {
                                                setState(() {
                                                  quantity--;
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
                                          Text(quantity.toString(),
                                              style: textStyleWhiteBold16),
                                          const SizedBox(width: 5),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                quantity++;
                                              });
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
              ),
            ),
          ),
          Column(
            children: [
              isChecked == true
                  ? Column(
                      children: [
                        // Container(
                        //   height: 10,
                        //   decoration: const BoxDecoration(
                        //     borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))
                        //   ),
                        // ),
                        const SizedBox(height: 10),
                        Container(
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
                        const SizedBox(height: 10),
                      ],
                    )
                  : const SizedBox(), // Nếu isChecked == false, không có nút "XÁC NHẬN"
            ],
          )
        ],
      ),
    );
  }
}
