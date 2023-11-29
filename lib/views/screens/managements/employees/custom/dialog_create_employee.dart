// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/employees/employees_controller.dart';
import 'package:myorder/utils.dart';

class CustomDialogCreateEmployeee extends StatefulWidget {
  const CustomDialogCreateEmployeee({Key? key}) : super(key: key);

  @override
  State<CustomDialogCreateEmployeee> createState() =>
      _CustomDialogCreateEmployeeeState();
}

class _CustomDialogCreateEmployeeeState
    extends State<CustomDialogCreateEmployeee> {
  EmployeeController employeeController = Get.put(EmployeeController());

  var isActive = true;
  String? selectedImagePath;
  final Rx<File?> _pickedImage = Rx<File?>(null);
  final List<String> roleOptions = ROLE_OPTION;
  String? errorTextName = "";
  String? errorTextRole = "";
  String? errorTextCCCD = "";
  String? errorTextPhone = "";
  String? errorTextEmail = "";
  String? errorTextAddress = "";

  bool isErrorTextName = false;
  bool isErrorTextRole = false;
  bool isErrorTextCCCD = false;
  bool isErrorTextPhone = false;
  bool isErrorTextEmail = false;
  bool isErrorTextAddress = false;

  bool isMaleSelected = true;
  bool isFemaleSelected = false;
  @override
  void initState() {
    super.initState();
    birthdayController.text = "dd/MM/yyyy";
    genderController.text = "Nam";
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController cccdController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  String birthday = "";
  DateTime? _selectedDate;
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime currentDate = DateTime.now();
    final DateTime picked = (await showDatePicker(
          context: context,
          initialDate: _selectedDate ?? currentDate,
          firstDate: DateTime(currentDate.year - 16), // Tuổi ít nhất là 16
          lastDate: DateTime(2101),
        )) ??
        currentDate;

    if (picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        birthdayController.text =
            "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";

        birthday =
            "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    roleController.dispose();
    cccdController.dispose();
    genderController.dispose();
    birthdayController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Góc bo tròn
      ),
      elevation: 5, // Độ nâng của bóng đổ
      backgroundColor: backgroundColor,

      child: Container(
        margin: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Align(
                alignment: Alignment.center,
                child: Text("THÔNG TIN CÁ NHÂN",
                    style: textStyleTitlePrimaryBold20),
              ),
              const SizedBox(
                height: 20,
              ),
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
                        mainAxisAlignment:
                            MainAxisAlignment.center, // Căn chỉnh dọc giữa
                        children: [
                          InkWell(
                            onTap: () async {
                              await pickImage();
                            },
                            child: ClipOval(
                              child: Image.asset(
                                "assets/images/user-default.png",
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    Positioned(
                      bottom: -10,
                      right: 100,
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
              TextField(
                  controller: nameController,
                  style: textStyleInput,
                  decoration: InputDecoration(
                      labelStyle: textStyleInput,
                      labelText: "Họ tên",
                      hintText: 'Nhập tên nhân viên',
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      errorText: isErrorTextName ? errorTextName : null,
                      errorStyle: textStyleErrorInput),
                  maxLength: 50,
                  autofocus: true,
                  onChanged: (value) => {
                        if (value.trim().length > maxlengthName ||
                            value.trim().length <= minlengthName)
                          {
                            setState(() {
                              errorTextName =
                                  "Từ $minlengthName đến $maxlengthName ký tự.";
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
              Container(
                margin: const EdgeInsets.only(left: 10),
                height: 50,
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Text(
                            'Chức vụ:',
                            style: textStyleInput,
                          ),
                          Expanded(
                              child: DropdownMenu<String>(
                            controller: roleController,
                            initialSelection: roleOptions.first,
                            onSelected: (String? value) {
                              // This is called when the user selects an item.
                              setState(() {
                                if (value != null) {
                                  if (value != "titleRole") {
                                    setState(() {
                                      roleController.text = value;
                                      print(roleController.text);
                                      isErrorTextRole = false;
                                    });
                                  }
                                }
                              });
                            },
                            dropdownMenuEntries: [
                              const DropdownMenuEntry<String>(
                                value: "titleRole",
                                label: "Chọn chức vụ",
                              ),
                              ...roleOptions.map<DropdownMenuEntry<String>>(
                                  (String value) {
                                return DropdownMenuEntry<String>(
                                  value: value,
                                  label: value,
                                );
                              }).toList(),
                            ],
                            textStyle: textStyleInput,
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                  controller: cccdController,
                  keyboardType: TextInputType.number,
                  maxLength: maxlengthCCCD,
                  style: textStyleInput,
                  decoration: InputDecoration(
                    labelStyle: textStyleInput,
                    labelText: "Mã định danh",
                    hintText: 'Nhập CCCD',
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    errorText: isErrorTextCCCD ? errorTextCCCD : null,
                    errorStyle: textStyleErrorInput,
                  ),
                  onChanged: (value) => {
                        if (value.trim().length > maxlengthCCCD ||
                            value.trim().length <= minlengthCCCD)
                          {
                            setState(() {
                              errorTextCCCD =
                                  "Từ $minlengthCCCD đến $maxlengthCCCD ký tự.";
                              isErrorTextCCCD = true;
                              print(isErrorTextCCCD);
                            })
                          }
                        else
                          {
                            setState(() {
                              errorTextCCCD = "";
                              isErrorTextCCCD = false;
                              print(isErrorTextCCCD);
                            })
                          }
                      }),
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.only(left: 10),
                height: 30,
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            'Giới tính:',
                            style: textStyleInput,
                          ),
                          Theme(
                            data:
                                ThemeData(unselectedWidgetColor: primaryColor),
                            child: Checkbox(
                              value: isMaleSelected,
                              onChanged: (value) {
                                setState(() {
                                  isMaleSelected = value ?? false;
                                  isFemaleSelected = !isMaleSelected;
                                  genderController.text = "Nam";
                                });
                              },
                            ),
                          ),
                          const Text(
                            'Nam',
                            style: textStyleInput,
                          ),
                          marginRight20,
                          marginRight10,
                          Theme(
                            data:
                                ThemeData(unselectedWidgetColor: primaryColor),
                            child: Checkbox(
                              value: isFemaleSelected,
                              onChanged: (value) {
                                setState(() {
                                  isFemaleSelected = value ?? false;
                                  isMaleSelected = !isFemaleSelected;
                                  genderController.text = "Nữ";
                                });
                              },
                            ),
                          ),
                          const Text(
                            'Nữ',
                            style: textStyleInput,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: birthdayController,
                readOnly: true,
                onTap: () {
                  _selectDate(context);
                },
                keyboardType: TextInputType.datetime,
                style: textStyleInput,
                decoration: const InputDecoration(
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    suffixIcon: Icon(Icons.calendar_today),
                    suffixStyle: textStyleInput),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                  controller: phoneController,
                  style: textStyleInput,
                  keyboardType: TextInputType.phone,
                  maxLength: maxlengthPhone,
                  decoration: InputDecoration(
                    labelStyle: textStyleInput,
                    labelText: "Số điện thoại",
                    hintText: 'Nhập số điện thoại',
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    errorText: isErrorTextPhone ? errorTextPhone : null,
                    errorStyle: textStyleErrorInput,
                  ),
                  onChanged: (value) => {
                        if (value.trim().length > maxlengthPhone ||
                            value.trim().length < minlengthPhone)
                          {
                            setState(() {
                              errorTextPhone =
                                  "Từ $minlengthPhone đến $maxlengthPhone ký tự.";
                              isErrorTextPhone = true;

                              if (!value.startsWith('0', 0)) {
                                errorTextPhone = "Số điện thoại không hợp lệ";
                                isErrorTextPhone = true;
                              }
                            }),
                          }
                        else
                          {
                            setState(() {
                              errorTextPhone = "";
                              isErrorTextPhone = false;
                              if (!value.startsWith('0', 0)) {
                                errorTextPhone = "Số điện thoại không hợp lệ";
                                isErrorTextPhone = true;
                              }
                            })
                          }
                      }),
              TextField(
                  controller: emailController,
                  style: textStyleInput,
                  decoration: InputDecoration(
                    labelStyle: textStyleInput,
                    labelText: "Email",
                    hintText: 'Nhập email',
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    errorText: isErrorTextEmail ? errorTextEmail : null,
                    errorStyle: textStyleErrorInput,
                  ),
                  onChanged: (value) => {
                        if (!Utils.isValidEmail(value))
                          {
                            setState(() {
                              errorTextEmail = "Email không hợp lệ!";
                              isErrorTextEmail = true;
                            })
                          }
                        else
                          {
                            setState(() {
                              errorTextEmail = "";
                              isErrorTextEmail = false;
                            })
                          }
                      }),
              const SizedBox(
                height: 20,
              ),
              TextField(
                  controller: addressController,
                  style: textStyleInput,
                  keyboardType: TextInputType.streetAddress,
                  maxLength: maxlengthAddress,
                  decoration: InputDecoration(
                    labelStyle: textStyleInput,
                    labelText: "Địa chỉ",
                    hintText: 'Nhập địa chỉ',
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1)),
                    errorText: isErrorTextAddress ? errorTextAddress : null,
                    errorStyle: textStyleErrorInput,
                  ),
                  onChanged: (value) => {
                        if (value.trim().length > maxlengthAddress ||
                            value.trim().length < minlengthAddress)
                          {
                            setState(() {
                              errorTextAddress =
                                  "Từ $minlengthAddress đến $maxlengthAddress ký tự.";
                              isErrorTextAddress = true;
                            })
                          }
                        else
                          {
                            setState(() {
                              errorTextAddress = "";
                              isErrorTextAddress = false;
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
                          ),
                          child: const Align(
                            alignment: Alignment.center,
                            child: Text("HỦY", style: buttonStyleCancel),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () => {
                          if (!isErrorTextName &&
                              !isErrorTextCCCD &&
                              !isErrorTextPhone &&
                              !isErrorTextEmail &&
                              !isErrorTextRole &&
                              !isErrorTextAddress)
                            {
                              employeeController.createEmployee(
                                  nameController.text,
                                  _pickedImage.value,
                                  cccdController.text,
                                  genderController.text,
                                  birthdayController.text,
                                  phoneController.text,
                                  emailController.text,
                                  "00000000",
                                  "city",
                                  "district",
                                  "ward",
                                  addressController.text,
                                  roleController.text),
                              Navigator.pop(context)
                            }
                          else
                            {
                              print("Chưa nhập đủ trường"),
                            }
                        },
                        child: Container(
                          height: 50,
                          decoration: const BoxDecoration(
                            color: primaryColor,
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
          ),
        ),
      ),
    );
  }
}
