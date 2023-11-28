// ignore_for_file: avoid_single_cascade_in_expression_statements, avoid_print

// import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/constants/app_constants.dart';
import 'package:myorder/controllers/units/units_controller.dart';
import 'package:myorder/models/unit.dart';
import 'package:myorder/utils.dart';
import 'package:myorder/views/widgets/dialogs/dialog_select.dart';
import 'package:myorder/views/widgets/textfields/text_field_label/text_field_number.dart';
import 'package:myorder/views/widgets/textfields/text_field_label/text_field_string.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

class AddUnitPage extends StatefulWidget {
  const AddUnitPage({
    Key? key,
  }) : super(key: key);

  @override
  State<AddUnitPage> createState() => _AddUnitPageState();
}

class _AddUnitPageState extends State<AddUnitPage> {
  UnitController unitController = Get.put(UnitController());

  String? errorTextName = "";

  bool isErrorTextName = false;

  @override
  void initState() {
    super.initState();
    valueConversationController.text = '';
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController unitIdConversionController =
      TextEditingController();
  final TextEditingController valueConversationController =
      TextEditingController();
  final TextEditingController nameValueConversationController =
      TextEditingController();
  @override
  void dispose() {
    nameController.dispose();
    valueConversationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
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
          "THÊM MỚI ĐƠN VỊ ",
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
                Container(
                  margin: const EdgeInsets.all(10.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        MyTextFieldString(
                          textController: nameController,
                          label: 'Tên đơn vị',
                          placeholder: 'Nhập tên đơn vị...',
                          isReadOnly: false,
                          min: minlength2,
                          max: maxlength50,
                          isRequire: true,
                        ),
                        MyTextFieldNumber(
                          textController: valueConversationController,
                          label: 'Giá trị quy đổi',
                          placeholder: '',
                          isReadOnly: false,
                          max: MAX_PRICE,
                          min: 1,
                          isRequire: false,
                        ),
                        marginTop10,
                        InkWell(
                          onTap: () async {
                            Unit result = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return MyDialogSelect(
                                    lable: "DANH SÁCH ĐƠN VỊ",
                                    list: Utils.filterActive(
                                        unitController.units),
                                    keyNameSearch: "name");
                              },
                            );
                            if (result.unit_id != "") {
                              setState(() {
                                nameValueConversationController.text =
                                    result.name;
                                unitIdConversionController.text =
                                    result.unit_id;
                              });
                            }
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(4),
                                child: Row(
                                  children: [
                                    Text(
                                      'Đơn vị quy đổi',
                                      style: textStyleLabel16,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 50,
                                padding: const EdgeInsets.only(left: 8),
                                decoration: BoxDecoration(
                                    borderRadius: borderContainer8,
                                    border: Border.all(
                                        color: borderColor, width: 1)),
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      nameValueConversationController.text,
                                      style: textStyleInput,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
                          onTap: () => {
                            if (!Utils.isValidLengthTextEditController(
                                nameController, minlength2, maxlength50))
                              {
                                Utils.showStylishDialog(
                                    context,
                                    'THÔNG BÁO',
                                    'Tên đơn vị phải từ $minlength2 đến $maxlength50 ký tự.',
                                    StylishDialogType.ERROR)
                              }
                            else
                              {
                                unitController.createUnit(
                                  nameController.text,
                                  unitIdConversionController.text,
                                  nameValueConversationController.text,
                                  int.tryParse(
                                          valueConversationController.text) ??
                                      1,
                                ),
                                Utils.myPopSuccess(context)
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
