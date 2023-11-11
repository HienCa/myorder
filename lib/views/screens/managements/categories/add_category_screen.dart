// ignore_for_file: avoid_single_cascade_in_expression_statements, avoid_print

// import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/categories/categories_controller.dart';
import 'package:myorder/utils.dart';
import 'package:myorder/views/widgets/textfields/text_field_label/text_field_string.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

class AddCategoryPage extends StatefulWidget {
  const AddCategoryPage({
    Key? key,
  }) : super(key: key);

  @override
  State<AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  CategoryController categoryController = Get.put(CategoryController());

  String? errorTextName = "";
  int selectedRadioDecrease = CATEGORY_ALL;

  bool isErrorTextName = false;

  @override
  void initState() {
    super.initState();
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
          "THÊM MỚI DANH MỤC",
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
                Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        height: 50,
                        width: 400,
                        child: Row(
                          children: [
                            Expanded(
                              child: Theme(
                                data: ThemeData(
                                    unselectedWidgetColor: primaryColor),
                                child: Radio(
                                  value: CATEGORY_FOOD,
                                  groupValue: selectedRadioDecrease,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedRadioDecrease = value as int;
                                      print(value);
                                    });
                                  },
                                ),
                              ),
                            ),
                            const Expanded(
                              flex: 2,
                              child: Text('Món ăn',
                                  style: textStyleTitleGrayRegular16),
                            ),
                            Expanded(
                              child: Theme(
                                data: ThemeData(
                                    unselectedWidgetColor: primaryColor),
                                child: Radio(
                                  value: CATEGORY_DRINK,
                                  groupValue: selectedRadioDecrease,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedRadioDecrease = value as int;
                                      print(selectedRadioDecrease);
                                    });
                                  },
                                ),
                              ),
                            ),
                            const Expanded(
                              flex: 2,
                              child: Text(
                                'Món nước',
                                style: textStyleTitleGrayRegular16,
                              ),
                            ),
                            Expanded(
                              child: Theme(
                                data: ThemeData(
                                    unselectedWidgetColor: primaryColor),
                                child: Radio(
                                  value: CATEGORY_OTHER,
                                  groupValue: selectedRadioDecrease,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedRadioDecrease = value as int;
                                    });
                                  },
                                ),
                              ),
                            ),
                            const Expanded(
                              flex: 2,
                              child: Text('Món khác',
                                  style: textStyleTitleGrayRegular16),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    MyTextFieldString(
                      textController: nameController,
                      label: 'Tên danh mục',
                      placeholder: 'Nhập tên danh mục',
                      isReadOnly: false,
                      min: minlength2,
                      max: maxlength50,
                      isRequire: true,
                    ),
                  ],
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
                                    'Tên danh mục phải từ $minlength2 đến $maxlength50 ký tự.',
                                    StylishDialogType.ERROR)
                              }
                            else
                              {
                                categoryController.createCategory(
                                    nameController.text, selectedRadioDecrease),
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
