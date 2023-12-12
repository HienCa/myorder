// ignore_for_file: avoid_single_cascade_in_expression_statements, avoid_print

// import 'package:awesome_dialog/awesome_dialog.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/suppliers/suppliers_controller.dart';
import 'package:myorder/models/supplier.dart';
import 'package:myorder/utils.dart';
import 'package:myorder/views/widgets/textfields/text_field_label/text_field_email.dart';
import 'package:myorder/views/widgets/textfields/text_field_label/text_field_phone.dart';
import 'package:myorder/views/widgets/textfields/text_field_label/text_field_string.dart';
import 'package:myorder/views/widgets/textfields/text_field_label/text_field_string_multiline.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

class AddUpdateSupplierPage extends StatefulWidget {
  final Supplier? supplier;
  const AddUpdateSupplierPage({
    Key? key,
    this.supplier,
  }) : super(key: key);

  @override
  State<AddUpdateSupplierPage> createState() => _AddUpdateSupplierPageState();
}

class _AddUpdateSupplierPageState extends State<AddUpdateSupplierPage> {
  var isActive = true;
  String? selectedImagePath;
  final Rx<File?> _pickedImage = Rx<File?>(null);


  SupplierController supplierController = Get.put(SupplierController());

  @override
  void initState() {
    super.initState();

    if (widget.supplier != null) {
      nameController.text = widget.supplier?.name ?? "";
      phoneController.text = widget.supplier?.phone ?? "";
      emailController.text = widget.supplier?.email ?? "";
      addressController.text = widget.supplier?.address ?? "";
      addressController.text = widget.supplier?.address ?? "";
      noteController.text = widget.supplier?.note ?? "";
    }
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  Future<void> pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _pickedImage.value = File(pickedImage.path);
        selectedImagePath = pickedImage.path;
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
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
            "NHÀ CUNG CẤP",
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
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              children: [
                Column(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          if (selectedImagePath != null)
                            ClipOval(
                              child: InkWell(
                                onTap: () async {
                                  await pickImage();
                                },
                                child: Image.file(
                                  File(selectedImagePath!),
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          else
                            Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .center, // Căn chỉnh dọc giữa
                              children: [
                                InkWell(
                                    onTap: () async {
                                      await pickImage();
                                    },
                                    child: (widget.supplier != null &&
                                            widget.supplier?.avatar != "")
                                        ? CircleAvatar(
                                            radius: 55,
                                            backgroundColor: primaryColor,
                                            child: CircleAvatar(
                                              radius: 50,
                                              backgroundColor:
                                                  Colors.transparent,
                                              backgroundImage: NetworkImage(
                                                  widget.supplier!.avatar!),
                                            ),
                                          )
                                        : CircleAvatar(
                                            backgroundColor: Colors.transparent,
                                            radius: 50,
                                            child: Image.asset(
                                              'assets/images/user-default.png',
                                            ),
                                          )),
                              ],
                            ),
                          Positioned(
                            bottom: -10,
                            right: 110,
                            child: IconButton(
                              onPressed: () async {
                                await pickImage();
                              },
                              icon: const Icon(
                                Icons.add_a_photo,
                                color: primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    MyTextFieldString(
                      textController: nameController,
                      label: 'Tên nhà cung cấp',
                      placeholder: 'Nhập tên nhà cung cấp',
                      isReadOnly: false,
                      min: minlength2,
                      max: maxlength255,
                      isRequire: true,
                    ),
                    MyTextFieldPhone(
                        textController: phoneController,
                        label: 'Số điện thoại',
                        placeholder: 'Nhập số điện thoại',
                        isRequire: true),
                    MyTextFieldEmail(
                        textController: emailController,
                        label: 'Email',
                        placeholder: 'Nhập Email',
                        isRequire: true),
                    MyTextFieldString(
                      textController: addressController,
                      label: 'Địa chỉ',
                      placeholder: 'Nhập địa chỉ',
                      isReadOnly: false,
                      min: minlengthAddress,
                      max: maxlengthAddress,
                      isRequire: true,
                    ),
                    MyTextFieldStringMultiline(
                        textController: noteController,
                        label: "Ghi chú",
                        placeholder: "Nhập ghi chú",
                        min: 0,
                        max: 200,
                        isRequire: false),
                  ],
                ),
                const Spacer(),
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
                      marginRight10,
                      Expanded(
                        child: InkWell(
                          onTap: () => {
                            if (!Utils.isValidLengthTextEditController(
                                nameController, minlength2, maxlength255))
                              {
                                Utils.showStylishDialog(
                                    context,
                                    'THÔNG BÁO',
                                    'Tên nhà cung cấp phải từ $minlength2 đến $maxlength255 ký tự.',
                                    StylishDialogType.ERROR)
                              }
                            else if (!Utils.startsWithZero(
                                    phoneController.text) &&
                                (phoneController.text.trim().length <
                                        minlengthPhone ||
                                    phoneController.text.trim().length >
                                        maxlengthPhone))
                              {
                                Utils.showStylishDialog(
                                    context,
                                    'THÔNG BÁO',
                                    'Số điện thoại chưa hợp lệ',
                                    StylishDialogType.ERROR)
                              }
                            else if (!Utils.isValidEmail(emailController.text))
                              {
                                Utils.showStylishDialog(
                                    context,
                                    'THÔNG BÁO',
                                    'Email chưa hợp lệ',
                                    StylishDialogType.ERROR)
                              }
                            else if (!Utils.isValidLengthTextEditController(
                                addressController,
                                minlengthAddress,
                                maxlengthAddress))
                              {
                                Utils.showStylishDialog(
                                    context,
                                    'THÔNG BÁO',
                                    'Địa chỉ phải từ $minlengthAddress đến $maxlengthAddress ký tự.',
                                    StylishDialogType.ERROR)
                              }
                            else
                              {
                                if (widget.supplier != null)
                                  {
                                    supplierController.updateSupplier(
                                        widget.supplier?.supplier_id ?? "",
                                        nameController.text,
                                        _pickedImage.value,
                                        phoneController.text,
                                        emailController.text,
                                        addressController.text,
                                        noteController.text),
                                    Utils.myPopResult(context, 'update')
                                  }
                                else
                                  {
                                    supplierController.createSupplier(
                                        nameController.text,
                                        _pickedImage.value,
                                        phoneController.text,
                                        emailController.text,
                                        addressController.text,
                                        noteController.text),
                                    Utils.myPopResult(context, 'add')
                                  },
                              }
                          },
                          child: Container(
                            height: 50,
                            decoration: const BoxDecoration(
                              color: primaryColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                  widget.supplier != null
                                      ? "CẬP NHẬT"
                                      : "THÊM MỚI",
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
        ));
  }
}
