// ignore_for_file: non_constant_identifier_names, avoid_print, prefer_interpolation_to_compose_strings, constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/utils.dart';
import 'package:myorder/views/widgets/icons/icon_close.dart';
import 'package:myorder/views/widgets/textfields/text_field_label/text_field_price.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

class MyDialogChoosePrice extends StatefulWidget {
  const MyDialogChoosePrice({
    Key? key,
  }) : super(key: key);

  @override
  State<MyDialogChoosePrice> createState() => _MyDialogChoosePriceState();
}

class _MyDialogChoosePriceState extends State<MyDialogChoosePrice> {
  final textEditingController = TextEditingController();
  List<double> listpriceRecommend = [
    0,
    5000,
    10000,
    20000,
    30000,
    40000,
    50000,
    60000,
    70000,
    80000,
    90000,
    100000,
    150000,
    200000,
    250000,
    300000,
    350000,
    400000,
  ];
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
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
      backgroundColor: grayColor200,
      child: Theme(
        data: ThemeData(unselectedWidgetColor: primaryColor),
        child: Column(
          children: [
            Container(
                color: primaryColor,
                height: 40,
                child: const Padding(
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      marginRight20,
                      marginRight10,
                      Spacer(),
                      Text(
                        "GỢI Ý SỐ TIỀN",
                        style: textStyleWhiteBold20,
                      ),
                      Spacer(),
                      MyCloseIcon(heightWidth: 30, sizeIcon: 16),
                    ],
                  ),
                )),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: MyTextFieldPrice(
                textEditingController: textEditingController,
                label: '',
                placeholder: '0',
                min: 0,
                max: MAX_PRICE,
                isRequire: false,
                textAlignRight: true,
              ),
            ),
            // marginTop10,
            // marginTop10,
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                decoration: const BoxDecoration(
                  color: secondColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: ResponsiveGridList(
                  desiredItemWidth: 100,
                  minSpacing: 10,
                  children:
                      List.generate(listpriceRecommend.length, (index) => index)
                          .map((i) {
                    return InkWell(
                      onTap: () => {
                        textEditingController.text =
                            Utils.formatCurrency(listpriceRecommend[i]),
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, top: 8, bottom: 8),
                        decoration: BoxDecoration(
                          color: secondColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        height: 50,
                        child: Center(
                          child: Text(
                            Utils.formatCurrency(listpriceRecommend[i]),
                            style: textStyleLabel16,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            marginTop5,
            InkWell(
              onTap: () => {
                // Bằng 0 dùng để reset về 0
                if (Utils.stringConvertToDouble(textEditingController.text) >=
                        MIN_PRICE ||
                    Utils.stringConvertToDouble(textEditingController.text) ==
                        0)
                  {Utils.myPopResult(context, textEditingController.text)}
                else
                  {
                    Utils.showStylishDialog(context, 'LƯU Ý',
                        'Số tiền ít nhất là 1,000', StylishDialogType.INFO)
                  }
              },
              child: Container(
                height: 40,
                width: MediaQuery.of(context).size.width / 3,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Center(
                    child: Text(
                  "XONG",
                  style: textStyleWhiteBold20,
                )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
