// ignore_for_file: avoid_single_cascade_in_expression_statements, avoid_print

// import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/units/units_controller.dart';
import 'package:myorder/models/unit.dart';
import 'package:myorder/utils.dart';
import 'package:myorder/views/widgets/textfields/text_field_label/text_field_string.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

class UnitDetailPage extends StatefulWidget {
  final String unitId;
  const UnitDetailPage({
    Key? key,
    required this.unitId,
  }) : super(key: key);

  @override
  State<UnitDetailPage> createState() => _UnitDetailPageState();
}

class _UnitDetailPageState extends State<UnitDetailPage> {
  var isActive = true;
  String? selectedImagePath;
  final List<String> roleOptions = ROLE_OPTION;
  String? errorTextName = "";

  bool isErrorTextName = false;

  UnitController unitController = Get.put(UnitController());
  late Unit unit;
  @override
  void initState() {
    super.initState();
    loadUnit();
  }

  Future<void> loadUnit() async {
    final Unit result = await unitController.getUnitById(widget.unitId);
    if (result.unit_id != "") {
      setState(() {
        unit = result;
        nameController.text = unit.name;
      });
    }
  }

  final TextEditingController nameController = TextEditingController();
  @override
  void dispose() {
    nameController.dispose();

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
          "THÔNG TIN ĐƠN VỊ",
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
      body: Padding(
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
                        placeholder: 'Nhập tên đơn vị',
                        isReadOnly: false,
                        min: minlength2,
                        max: maxlength50,
                        isRequire: true,
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
                            child: Text("HỦY", style: buttonStyleCancel),
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
                              unitController.updateUnit(
                                unit.unit_id,
                                nameController.text,
                              ),
                              Utils.myPopSuccess(context)
                            }
                        },
                        child: Container(
                          height: 50,
                          decoration: const BoxDecoration(
                              color: primaryColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
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
    );
  }
}
