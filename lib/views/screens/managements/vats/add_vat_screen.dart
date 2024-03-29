// ignore_for_file: avoid_single_cascade_in_expression_statements, avoid_print

// import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/vats/vats_controller.dart';
import 'package:myorder/utils.dart';
import 'package:myorder/views/widgets/textfields/text_field_label/text_field_number.dart';
import 'package:myorder/views/widgets/textfields/text_field_label/text_field_string.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

class AddVatPage extends StatefulWidget {
  const AddVatPage({
    Key? key,
  }) : super(key: key);

  @override
  State<AddVatPage> createState() => _AddVatPageState();
}

class _AddVatPageState extends State<AddVatPage> {
  VatController vatController = Get.put(VatController());

  String? errorTextName = "";
  String? errorTextVatPercent = "";

  bool isErrorTextName = false;
  bool isErrorTextVatPercent = false;

  @override
  void initState() {
    super.initState();
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController vatPercentController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    vatPercentController.dispose();
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
          "THÊM MỚI VAT",
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
                        label: 'Thuế giá trị gia tăng',
                        placeholder: 'Nhập tên',
                        isReadOnly: false,
                        min: minlength2,
                        max: maxlength50,
                        isRequire: true,
                      ),
                      MyTextFieldNumber(
                          textController: vatPercentController,
                          label: 'Phần trăm (%)',
                          placeholder: 'Nhập %',
                          isReadOnly: false,
                          max: 100,
                          min: 1,
                          isRequire: true),
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
                            if (!Utils.isValidLengthTextEditController(
                                    nameController, minlength2, maxlength50) &&
                                !Utils.isValidRangeTextEditController(
                                    vatPercentController, 1, 100)) {
                              Utils.showStylishDialog(
                                  context,
                                  'THÔNG BÁO',
                                  'Vui lòng kiểm tra lại thông tin nhập liệu.',
                                  StylishDialogType.ERROR);
                            } else if (!Utils.isValidLengthTextEditController(
                                nameController, minlength2, maxlength50)) {
                              Utils.showStylishDialog(
                                  context,
                                  'THÔNG BÁO',
                                  'Tên vat phải từ $minlength2 đến $maxlength50',
                                  StylishDialogType.ERROR);
                            } else if (!Utils.isValidRangeTextEditController(
                                vatPercentController, 1, 100)) {
                              Utils.showStylishDialog(
                                  context,
                                  'THÔNG BÁO',
                                  'Phần trăm phải từ 1 đến 100',
                                  StylishDialogType.ERROR);
                            } else {
                              vatController.createVat(
                                nameController.text,
                                vatPercentController.text,
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
                                  Text("THÊM MỚI", style: buttonStyleBlackBold),
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
