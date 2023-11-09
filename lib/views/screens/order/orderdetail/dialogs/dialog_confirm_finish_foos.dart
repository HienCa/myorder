// ignore_for_file: non_constant_identifier_names, avoid_print, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/orders/orders_controller.dart';
import 'package:myorder/models/order.dart';

class CustomDialogFinishFoods extends StatefulWidget {
  final Order order;
  const CustomDialogFinishFoods({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  State<CustomDialogFinishFoods> createState() =>
      _CustomDialogFinishFoodsState();
}

class _CustomDialogFinishFoodsState extends State<CustomDialogFinishFoods> {
  OrderController orderController = Get.put(OrderController());

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Góc bo tròn
      ),
      elevation: 5, // Độ nâng của bóng đổ
      backgroundColor: backgroundColor,
      child: Theme(
        data: ThemeData(unselectedWidgetColor: primaryColor),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        'YÊU CẦU DỪNG CHẾ BIẾN',
                        style: textStylePrimaryBold,
                      ),
                    ),
                    marginTop20,
                    const ListTile(
                      title: Center(
                        child: Text(
                          'Bạn muốn dừng chế biến để tiến hành thanh toán?',
                          style: textStyleBlackRegular,
                        ),
                      ),
                      subtitle: Center(
                        child: Text(
                          '\nLƯU Ý: Khi "Hoàn tất món" các món ăn sẽ được dừng chế biến. Khi đó khách hàng sẽ không nhận được tất cả các món đang được chế biến hoặc pha chế.',
                          style: textStyleBlackRegular,
                        ),
                      ),
                    ),
                    marginTop20,
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () => {Navigator.pop(context)},
                            child: Container(
                              height: 50,
                              width: 136,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                color: backgroundColorGray,
                              ),
                              child: const Center(
                                child: Text(
                                  'HỦY BỎ',
                                  style: textStyleCancel,
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () => {
                              orderController.updateFoodStatus(widget.order
                                  ),
                              Navigator.pop(context, 'success')
                            },
                            child: Container(
                              height: 50,
                              width: 136,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                color: primaryColor,
                              ),
                              child: const Center(
                                child: Text(
                                  'XÁC NHẬN',
                                  style: textStyleWhiteBold16,
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
            ],
          ),
        ),
      ),
    );
  }
}
