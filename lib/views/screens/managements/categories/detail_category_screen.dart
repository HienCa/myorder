// ignore_for_file: avoid_single_cascade_in_expression_statements, avoid_print

// import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/categories/categories_controller.dart';
import 'package:myorder/models/category.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

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

  CategoryController categoryController = Get.put(CategoryController());
  late Category category;
  @override
  void initState() {
    super.initState();
    category = Category(category_id: '', name: '', active: 1);
  }

  Future<void> loadcategory() async {
    final Category result = await categoryController.getCategoryById(widget.categoryId);
    if (result.category_id != "") {
      setState(() {
        category = result;
        nameController.text = category.name;
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
    if (category.category_id == "") {
      loadcategory();

      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          leading: InkWell(
              onTap: () => {Navigator.pop(context)},
              child: const Icon(Icons.arrow_back_ios)),
          title: const Center(child: Text("DANH MỤC")),
          backgroundColor: primaryColor,
        ),
        body: const Center(
          child: CircularProgressIndicator(), // Display a loading indicator.
        ),
      );
    }
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        leading: InkWell(
            onTap: () => {Navigator.pop(context)},
            child: const Icon(Icons.arrow_back_ios)),
        title: const Center(child: Text("DANH MỤC")),
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
                              hintText: 'Nhập danh mục',
                              hintStyle: const TextStyle(color: Colors.grey),
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)),
                              errorText: isErrorTextName ? errorTextName : null,
                              errorStyle: textStyleErrorInput),
                          maxLength: 50,
                          // autofocus: true,
                          onChanged: (value) => {
                                if (value.trim().length > maxlengthCategoryName ||
                                    value.trim().length <= minlengthCategoryName)
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
                        height: 50,
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
                                  if (!isErrorTextName)
                                    {
                                      categoryController.updateCategory(
                                        category.category_id,
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
