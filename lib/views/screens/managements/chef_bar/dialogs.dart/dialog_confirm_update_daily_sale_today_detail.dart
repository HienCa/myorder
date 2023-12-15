// ignore_for_file: non_constant_identifier_names, avoid_print, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/daily_sales/daily_sale_detail_controller.dart';
import 'package:myorder/controllers/foods/foods_controller.dart';


class CustomDialogUpdateCurrentCountOrder extends StatefulWidget {
  const CustomDialogUpdateCurrentCountOrder({
    Key? key, 
  }) : super(key: key);

  @override
  State<CustomDialogUpdateCurrentCountOrder> createState() =>
      _CustomDialogUpdateCurrentCountOrderState();
}

class _CustomDialogUpdateCurrentCountOrderState
    extends State<CustomDialogUpdateCurrentCountOrder> {
  FoodController foodController = Get.put(FoodController());

  @override
  void dispose() {
    super.dispose();
  }

  DailySaleDetailController dailySaleDetailController =
      Get.put(DailySaleDetailController());

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
                        'SỐ LƯỢNG BÁN HÔM NAY',
                        style: textStylePrimaryBold,
                      ),
                    ),
                    marginTop20,
                    const ListTile(
                      title: Center(
                        child: Text(
                          "Bạn có chắc chắn muốn cập nhật?",
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
                              dailySaleDetailController.updateCurrentOrderCount(
                                  foodController.foodsToOrder),
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
                                  style: textStyleWhiteBold20,
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
