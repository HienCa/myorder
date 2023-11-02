// ignore_for_file: non_constant_identifier_names, avoid_print, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/chef_bar_other/chef_bar_other_controller.dart';
import 'package:myorder/models/order_detail.dart';

class ChangeCancelFoodConfirmDialog extends StatefulWidget {
  final String chefBarId;
  final List<OrderDetail> orderDetailList;
  const ChangeCancelFoodConfirmDialog({
    Key? key,
    required this.chefBarId,
    required this.orderDetailList,
  }) : super(key: key);

  @override
  State<ChangeCancelFoodConfirmDialog> createState() =>
      _ChangeCancelFoodConfirmDialogState();
}

class _ChangeCancelFoodConfirmDialogState
    extends State<ChangeCancelFoodConfirmDialog> {
  ChefBarOtherController chefBarOtherController =
      Get.put(ChefBarOtherController());
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
                        'TRẠNG THÁI HỦY MÓN',
                        style: textStylePrimaryBold,
                      ),
                    ),
                    marginTop20,
                    ListTile(
                      title: const Center(
                        child: Text(
                          'Bạn muốn hủy các món đã chọn?',
                          style: textStyleBlackRegular,
                        ),
                      ),
                      subtitle: Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "$FOOD_STATUS_IN_CHEF_STRING.",
                              style: textStyleCancelDialog,
                            ),
                            marginRight10,
                            const Icon(
                              Icons.arrow_right_alt,
                              color: iconColor,
                            ),
                            marginRight10,
                            Text(
                              "$FOOD_STATUS_CANCEL_STRING.",
                              style: textStyleCancelDialog,
                            ),
                          ],
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
                              chefBarOtherController.updateFoodStatus(
                                  widget.chefBarId, widget.orderDetailList),
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
