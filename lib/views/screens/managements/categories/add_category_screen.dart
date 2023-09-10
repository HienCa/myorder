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
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                          controller: nameController,
                          style: textStyleInput,
                          decoration: InputDecoration(
                              labelStyle: textStyleInput,
                              labelText: "Tên danh mục",
                              hintText: 'Nhập tên danh mục',
                              hintStyle: const TextStyle(color: Colors.grey),
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)),
                              errorText: isErrorTextName ? errorTextName : null,
                              errorStyle: textStyleErrorInput),
                          maxLength: 50,
                          // autofocus: true,
                          onChanged: (value) => {
                                if (value.trim().length >
                                        maxlengthCategoryName ||
                                    value.trim().length <=
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
                      const SizedBox(
                        height: 30,
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
                                        nameController.text,
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
                          Future.delayed(const Duration(seconds: 2), () {
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
    );
  }
}
