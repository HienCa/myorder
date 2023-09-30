// ignore_for_file: avoid_single_cascade_in_expression_statements, avoid_print

// import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/discount/discounts_controller.dart';
import 'package:myorder/models/discount.dart';
import 'package:myorder/utils.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

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

    discount =
        Discount(discount_id: '', name: '', active: 1, discount_price: 0);
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
    if (discount.discount_id == "") {

      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          leading: InkWell(
              onTap: () => {Navigator.pop(context)},
              child: const Icon(Icons.arrow_back_ios)),
          title: const Center(child: Text("CẬP NHẬT GIẢM GIÁ")),
          backgroundColor: primaryColor,
        ),
        body: const Center(
          child: CircularProgressIndicator(), // Display a loading indicator.
        ),
      );
    }
    return Scaffold(
      // backgroundColor: backgroundColor,
      appBar: AppBar(
        leading: InkWell(
            onTap: () => {Navigator.pop(context)},
            child: const Icon(Icons.arrow_back_ios)),
        title: const Center(child: Text("CẬP NHẬT GIẢM GIÁ")),
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
                              labelText: "Tên giảm giá",
                              hintText: 'Nhập tên giảm giá',
                              hintStyle: const TextStyle(color: Colors.grey),
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                              errorText: isErrorTextName ? errorTextName : null,
                              errorStyle: textStyleErrorInput),
                          maxLength: 50,
                          // autofocus: true,
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
                            controller: discountPriceController,
                            style: textStyleInput,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter
                                  .digitsOnly, // Only allows digits
                            ],
                            decoration: InputDecoration(
                                labelStyle: textStyleInput,
                                labelText: "Giá giảm",
                                hintText: 'Nhập giá muốn giảm',
                                hintStyle: const TextStyle(color: Colors.grey),
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30))),
                                errorText: isErrorTextDiscountPercent
                                    ? errorTextDiscountPercent
                                    : null,
                                errorStyle: textStyleErrorInput),

                            // autofocus: true,
                            onChanged: (value) => {
                                  if (value.isEmpty ||
                                      int.parse(value) < discountMin)
                                    {
                                      setState(() {
                                        errorTextDiscountPercent =
                                            "Giá phải lớn hơn 1,000";
                                        isErrorTextDiscountPercent = true;
                                      })
                                    }
                                  else
                                    {
                                      setState(() {
                                        errorTextDiscountPercent = "";
                                        isErrorTextDiscountPercent = false;

                                        discountPriceController.text =
                                            Utils.convertTextFieldPrice(value);

                                        if (int.parse(value) >= discountMax) {
                                          print(int.parse(value));
                                          discountPriceController.text =
                                              Utils.convertTextFieldPrice(
                                                  discountMax.toString());
                                          print(discountPriceController.text);
                                        }
                                      })
                                    }
                                }),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.55,
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
                                  discountPriceController.text =
                                      Utils.formatCurrencytoDouble(
                                          discountPriceController.text),
                                  if (!isErrorTextName &&
                                      (int.tryParse(discountPriceController
                                                  .text) ??
                                              0) >
                                          1000)
                                    {
                                      discountController.updateDiscount(
                                        discount.discount_id,
                                        nameController.text,
                                        discountPriceController.text,
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
