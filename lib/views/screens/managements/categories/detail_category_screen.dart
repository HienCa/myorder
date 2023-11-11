// ignore_for_file: avoid_single_cascade_in_expression_statements, avoid_print

// import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/categories/categories_controller.dart';
import 'package:myorder/models/category.dart';
import 'package:myorder/utils.dart';
import 'package:myorder/views/widgets/textfields/text_field_label/text_field_string.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

class CategoryDetailPage extends StatefulWidget {
  final String categoryId;
  const CategoryDetailPage({
    Key? key,
    required this.categoryId,
  }) : super(key: key);

  @override
  State<CategoryDetailPage> createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {
  var isActive = true;
  String? selectedImagePath;
  final List<String> roleOptions = ROLE_OPTION;
  String? errorTextName = "";

  bool isErrorTextName = false;
  int selectedRadioDecrease = CATEGORY_ALL;

  CategoryController categoryController = Get.put(CategoryController());
  late Category category;
  @override
  void initState() {
    super.initState();
    loadcategory();
  }

  Future<void> loadcategory() async {
    final Category result =
        await categoryController.getCategoryById(widget.categoryId);
    if (result.category_id != "") {
      setState(() {
        category = result;
        nameController.text = category.name;
        selectedRadioDecrease = category.category_code;
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
          "THÔNG TIN DANH MỤC",
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
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
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
                          data: ThemeData(unselectedWidgetColor: primaryColor),
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
                        child:
                            Text('Món ăn', style: textStyleTitleGrayRegular16),
                      ),
                      Expanded(
                        child: Theme(
                          data: ThemeData(unselectedWidgetColor: primaryColor),
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
                          data: ThemeData(unselectedWidgetColor: primaryColor),
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
              Container(
                margin: const EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
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
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
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
                                    child:
                                        Text("HỦY", style: buttonStyleCancel),
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
                                      categoryController.updateCategory(
                                        category.category_id,
                                        selectedRadioDecrease,
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
                                    child: Text("CẬP NHẬT",
                                        style: buttonStyleWhiteBold),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
