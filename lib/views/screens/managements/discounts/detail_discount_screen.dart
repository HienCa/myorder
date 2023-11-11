// ignore_for_file: avoid_single_cascade_in_expression_statements, avoid_print

// import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/discounts/discounts_controller.dart';
import 'package:myorder/models/discount.dart';
import 'package:myorder/utils.dart';
import 'package:myorder/views/widgets/textfields/text_field_label/text_field_price.dart';
import 'package:myorder/views/widgets/textfields/text_field_label/text_field_string.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

class DiscountDetailPage extends StatefulWidget {
  final String discountId;
  const DiscountDetailPage({
    Key? key,
    required this.discountId,
  }) : super(key: key);

  @override
  State<DiscountDetailPage> createState() => _DiscountDetailPageState();
}

class _DiscountDetailPageState extends State<DiscountDetailPage> {
  var isActive = true;
  String? selectedImagePath;
  final List<String> roleOptions = ROLE_OPTION;
  String? errorTextName = "";
  String? errorTextDiscountPercent = "";

  bool isErrorTextName = false;
  bool isErrorTextDiscountPercent = false;

  DiscountController discountController = Get.put(DiscountController());
  late Discount discount;
  @override
  void initState() {
    super.initState();
    loadDiscount();
  }

  Future<void> loadDiscount() async {
    final Discount result =
        await discountController.getDiscountById(widget.discountId);
    if (result.discount_id != "") {
      setState(() {
        discount = result;
        nameController.text = discount.name;
        discountPriceController.text =
            Utils.formatCurrency(discount.discount_price);
      });
    }
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController discountPriceController = TextEditingController();
  @override
  void dispose() {
    nameController.dispose();
    discountPriceController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: backgroundColor,
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
        title: const Center(
            child: Text(
          "THÔNG TIN GIẢM GIÁ",
          style: TextStyle(color: secondColor),
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
      body: Theme(
        data: ThemeData(unselectedWidgetColor: primaryColor),
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      marginTop10,
                      MyTextFieldString(
                        textController: nameController,
                        label: 'Giảm giá',
                        placeholder: 'Nhập tên',
                        isReadOnly: false,
                        min: minlength2,
                        max: maxlength50,
                        isRequire: true,
                      ),
                      MyTextFieldPrice(
                          textEditingController: discountPriceController,
                          label: 'Số tiền muốn giảm',
                          placeholder: 'Nhập số tiền...',
                          min: MIN_PRICE,
                          max: MAX_PRICE,
                          isRequire: true, textAlignRight: false,)
                    ],
                  ),
                ),
                
                SizedBox(
                  height: 50,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => {Navigator.pop(context)},
                          child: Container(
                            height: 50,
                            decoration: const BoxDecoration(
                                color: dividerColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: const Align(
                              alignment: Alignment.center,
                              child: Text("QUAY LẠI", style: buttonStyleCancel),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            discountPriceController.text =
                                discountPriceController.text
                                    .replaceAll(r',', '');
                            if (!Utils.isValidLengthTextEditController(
                                    nameController, minlength2, maxlength50) &&
                                !Utils.isValidRangeTextEditController(
                                    discountPriceController,
                                    MIN_PRICE,
                                    MAX_PRICE)) {
                              Utils.showStylishDialog(
                                  context,
                                  'THÔNG BÁO',
                                  'Vui lòng kiểm tra lại thông tin nhập liệu.',
                                  StylishDialogType.ERROR);
                            } else if (!Utils.isValidLengthTextEditController(
                                nameController, minlength2, maxlength50)) {
                              discountPriceController.text =
                                  Utils.convertTextFieldPrice(
                                      discountPriceController.text);

                              Utils.showStylishDialog(
                                  context,
                                  'THÔNG BÁO',
                                  'Tên vat phải từ $minlength2 đến $maxlength50 ký tự.',
                                  StylishDialogType.ERROR);
                            } else if (!Utils.isValidRangeTextEditController(
                                discountPriceController,MIN_PRICE, MAX_PRICE)) {
                              discountPriceController.text =
                                  Utils.convertTextFieldPrice(
                                      discountPriceController.text);

                              Utils.showStylishDialog(
                                  context,
                                  'THÔNG BÁO',
                                  'Số tiền phải từ ${Utils.convertTextFieldPrice('$MIN_PRICE')} đến ${Utils.convertTextFieldPrice('$MAX_PRICE')}',
                                  StylishDialogType.ERROR);
                            } else {
                              discountController.createDiscount(
                                nameController.text,
                                discountPriceController.text,
                              );
                              Utils.myPopSuccess(context);
                            }
                          },
                          child: Container(
                            height: 50,
                            decoration: const BoxDecoration(
                              color: primaryColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                            child: const Align(
                              alignment: Alignment.center,
                              child:
                                  Text("CẬP NHẬT", style: buttonStyleWhiteBold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }
}
