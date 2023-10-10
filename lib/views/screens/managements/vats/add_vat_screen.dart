// ignore_for_file: avoid_single_cascade_in_expression_statements, avoid_print

// import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/vats/vats_controller.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

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
            onTap: () => {Navigator.pop(context)},
            child: const Icon(Icons.arrow_back_ios)),
        title: const Center(child: Text("THÊM MỚI VAT")),
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
                                labelText: "Thuế giá trị gia tăng",
                                hintText: 'Nhập tên vat',
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
                                  labelText: "Phần trăm (%)",
                                  hintText: 'Nhập %',
                                  hintStyle: const TextStyle(color: Colors.grey),
                                  border:  const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),borderRadius: BorderRadius.all(Radius.circular(30))),
                                  errorText: isErrorTextVatPercent
                                      ? errorTextVatPercent
                                      : null,
                                  errorStyle: textStyleErrorInput),
                              maxLength: 3,
                              // autofocus: true,
                              onChanged: (value) => {
                                    if (value.isEmpty ||
                                        int.parse(value) <= 0 ||
                                        int.parse(value) > 100)
                                      {
                                        setState(() {
                                          errorTextVatPercent =
                                              "Phần trăm (%) phải lớn hơn 1";
                                          isErrorTextVatPercent = true;
                                          if (int.parse(value) > 100) {
                                            vatPercentController.text = "100";
                                            errorTextVatPercent = "";
                                            isErrorTextVatPercent = false;
                                          }
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
                                    if (
                                        nameController.text.trim().length > minlength2 && nameController.text.trim().length < maxlength50 &&
                                        int.tryParse(vatPercentController.text)! > 0 && int.tryParse(vatPercentController.text)! <= 100)
                                      {
                                        vatController.createVat(
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
