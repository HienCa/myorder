// ignore_for_file: avoid_single_cascade_in_expression_statements, avoid_print

// import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/discount/discounts_controller.dart';

import 'package:rflutter_alert/rflutter_alert.dart';

class AddDiscountPage extends StatefulWidget {
  const AddDiscountPage({
    Key? key,
  }) : super(key: key);

  @override
  State<AddDiscountPage> createState() => _AddDiscountPageState();
}

class _AddDiscountPageState extends State<AddDiscountPage> {
  DiscountController discountController = Get.put(DiscountController());

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
            onTap: () => {Navigator.pop(context)},
            child: const Icon(Icons.arrow_back_ios)),
        title: const Center(child: Text("THÊM MỚI GIẢM GIÁ")),
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
                        const SizedBox(
                          height: 20,
                        ),
                        TextField(
                            controller: nameController,
                            style: textStyleInput,
                            decoration: InputDecoration(
                                labelStyle: textStyleInput,
                                labelText: "Tên giảm giá",
                                hintText: 'Nhập tên giảm giá',
                                hintStyle: const TextStyle(color: Colors.grey),
                                border:  const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),borderRadius: BorderRadius.all(Radius.circular(30))),
                                errorText: isErrorTextName ? errorTextName : null,
                                errorStyle: textStyleErrorInput),
                            maxLength: 50,
                            onChanged: (value) => {
                                  if (value.trim().length > maxlength50 ||
                                      value.trim().length < minlength2)
                                    {
                                      setState(() {
                                        errorTextName =
                                            "Từ $minlength2 đến $maxlength50 ký tự.";
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
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 0, right: 0),
                          child: TextField(
                              controller: vatPercentController,
                              style: textStyleInput,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter
                                    .digitsOnly, // Only allows digits
                              ],
                              decoration: InputDecoration(
                                  labelStyle: textStyleInput,
                                  labelText: "Giá muốn giảm",
                                  hintText: 'Nhập giá muốn giảm',
                                  hintStyle: const TextStyle(color: Colors.grey),
                                  border:  const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),borderRadius: BorderRadius.all(Radius.circular(30))),
                                  errorText: isErrorTextVatPercent
                                      ? errorTextVatPercent
                                      : null,
                                  errorStyle: textStyleErrorInput),
                              maxLength: 50,
                              // autofocus: true,
                              onChanged: (value) => {
                                    if (value.isEmpty ||
                                        int.parse(value) < 1000)
                                      {
                                        setState(() {
                                          errorTextVatPercent =
                                             "Giá phải lớn hơn 1,000";
                                          isErrorTextVatPercent = true;
                                          
                                        })
                                      }
                                    else
                                      {
                                        setState(() {
                                          errorTextVatPercent = "";
                                          isErrorTextVatPercent = false;
                                        })
                                      }
                                  }),
                        ),
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
                                    if (!isErrorTextName &&
                                        nameController.text != "" &&
                                        vatPercentController.text != "0")
                                      {
                                        discountController.createDiscount(
                                          nameController.text,
                                          vatPercentController.text,
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
                                        Future.delayed(const Duration(seconds: 2),
                                            () {
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
