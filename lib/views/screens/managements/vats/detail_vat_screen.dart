// ignore_for_file: avoid_single_cascade_in_expression_statements, avoid_print

// import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/vats/vats_controller.dart';
import 'package:myorder/models/vat.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class VatDetailPage extends StatefulWidget {
  final String vatId;
  const VatDetailPage({
    Key? key,
    required this.vatId,
  }) : super(key: key);

  @override
  State<VatDetailPage> createState() => _VatDetailPageState();
}

class _VatDetailPageState extends State<VatDetailPage> {
  var isActive = true;
  String? selectedImagePath;
  final List<String> roleOptions = ROLE_OPTION;
  String? errorTextName = "";
  String? errorTextVatPercent = "";

  bool isErrorTextName = false;
  bool isErrorTextVatPercent = false;

  VatController vatController = Get.put(VatController());
  late Vat vat;
  @override
  void initState() {
    super.initState();
    vat = Vat(vat_id: '', name: '', active: 1, vat_percent: 0);
  }

  Future<void> loadVat() async {
    final Vat result = await vatController.getVatById(widget.vatId);
    if (result.vat_id != "") {
      setState(() {
        vat = result;
        nameController.text = vat.name;
        vatPercentController.text = "${vat.vat_percent}";
      });
    }
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
    if (vat.vat_id == "") {
      loadVat();

      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          leading: InkWell(
              onTap: () => {Navigator.pop(context)},
              child: const Icon(Icons.arrow_back_ios)),
          title: const Center(child: Text("THÊM MỚI VAT")),
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
        title: const Center(child: Text("THÊM MỚI VAT")),
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
                              labelText: "Thuế giá trị gia tăng",
                              hintText: 'Nhập tên vat',
                              hintStyle: const TextStyle(color: Colors.grey),
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)),
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
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey)),
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
                                  if (!isErrorTextName &&
                                      vatPercentController.text != "0")
                                    {
                                      vatController.updateVat(
                                        vat.vat_id,
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