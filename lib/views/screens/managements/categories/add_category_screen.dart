// ignore_for_file: avoid_single_cascade_in_expression_statements, avoid_print

// import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/categories/categories_controller.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

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
            onTap: () => {Navigator.pop(context)},
            child: const Icon(Icons.arrow_back_ios)),
        title: const Center(child: Text("THÊM MỚI DANH MỤC")),
        backgroundColor: primaryColor,
      ),
      body: Theme(
        data: ThemeData(unselectedWidgetColor: primaryColor),
        child: SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(10.0),
                  child: SingleChildScrollView(
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
                        TextField(
                            controller: nameController,
                            style: textStyleInput,
                            decoration: InputDecoration(
                                labelStyle: textStyleInput,
                                labelText: "Tên danh mục gợi nhớ",
                                hintText: 'Nhập tên danh mục',
                                hintStyle: const TextStyle(color: Colors.grey),
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30))),
                                errorText:
                                    isErrorTextName ? errorTextName : null,
                                errorStyle: textStyleErrorInput),
                            maxLength: 50,
                            // autofocus: true,
                            onChanged: (value) => {
                                  if (value.trim().length >
                                          maxlengthCategoryName ||
                                      value.trim().length <
                                          minlengthCategoryName)
                                    {
                                      setState(() {
                                        errorTextName =
                                            "Từ $minlengthCategoryName đến $maxlengthCategoryName ký tự.";
                                        isErrorTextName = true;
                                      })
                                    }
                                  else
                                    {
                                      setState(() {
                                        errorTextName = "";
                                        isErrorTextName = false;
                                      })
                                    }
                                }),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.65,
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                    child: const Align(
                                      alignment: Alignment.center,
                                      child: Text("QUAY LẠI",
                                          style: buttonStyleCancel),
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
                                    if (!isErrorTextName)
                                      {
                                        categoryController.createCategory(
                                          nameController.text,selectedRadioDecrease
                                        ),
                                        Navigator.pop(context)
                                      }
                                    else
                                      {
                                        print("Chưa nhập đủ trường"),
                                        Alert(
                                          context: context,
                                          title: "THÔNG BÁO",
                                          desc: "Thông tin chưa chính xác!",
                                          image: alertImageError,
                                          buttons: [],
                                        ).show(),
                                        Future.delayed(
                                            const Duration(seconds: 2), () {
                                          Navigator.pop(context);
                                        })
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
                                      child: Text("THÊM MỚI",
                                          style: buttonStyleBlackBold),
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
      ),
    );
  }
}
