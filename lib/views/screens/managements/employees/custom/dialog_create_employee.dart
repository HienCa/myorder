import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/utils.dart';

class CustomDialogCreateEmployeee extends StatefulWidget {
  const CustomDialogCreateEmployeee({Key? key}) : super(key: key);

  @override
  State<CustomDialogCreateEmployeee> createState() =>
      _CustomDialogCreateEmployeeeState();
}

class _CustomDialogCreateEmployeeeState
    extends State<CustomDialogCreateEmployeee> {
  var isActive = true;
  String? selectedImagePath;
  final Rx<File?> _pickedImage = Rx<File?>(null);
  final List<String> roleOptions = <String>[
    'Nhân viên',
    'Thu ngân',
    'Chủ nhà hàng'
  ];
  String? errorTextName = "";
  String? errorTextRole = "";
  String? errorTextCCCD = "";
  String? errorTextPhone = "";
  String? errorTextEmail = "";
  String? errorTextAddress = "";

  bool isErrorTextName = true;
  bool isErrorTextRole = true;
  bool isErrorTextCCCD = true;
  bool isErrorTextPhone = true;
  bool isErrorTextEmail = true;
  bool isErrorTextAddress = true;

  bool isMaleSelected = true;
  bool isFemaleSelected = false;
  @override
  void initState() {
    super.initState();
    birthdayController.text = "dd/MM/yyyy";
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController cccdController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

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
              SizedBox(
                height: 60,
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Text(
                            'Tên nhân viên:',
                            style: textStyleInput,
                          ),
                          marginRight10,
                          Expanded(
                              child: TextField(
                                  controller: nameController,
                                  style: textStyleInput,
                                  decoration: InputDecoration(
                                      // prefix:Icon(Icons.home, color: iconColor,),
                                      hintText: 'Nhập tên nhân viên',
                                      hintStyle:
                                          const TextStyle(color: Colors.grey),
                                      border: InputBorder
                                          .none, // Xóa border của TextField
                                      errorText: isErrorTextName
                                          ? errorTextName
                                          : null,
                                      errorStyle: textStyleErrorInput),
                                  maxLength: 50,
                                  autofocus: true,
                                  onChanged: (value) => {
                                        if (value.trim().length >
                                                maxlengthName ||
                                            value.trim().length <=
                                                minlengthName)
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
                                      })),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: dividerColor, height: 0.05),
              SizedBox(
                height: 60,
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
                                roleController.text = value!;
                                print(roleController.text);
                              });
                            },
                            dropdownMenuEntries: roleOptions
                                .map<DropdownMenuEntry<String>>((String value) {
                              return DropdownMenuEntry<String>(
                                value: value,
                                label: value,
                              );
                            }).toList(),
                            textStyle: textStyleInput,
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: dividerColor, height: 0.05),
              SizedBox(
                height: 60,
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Text(
                            'CCCD/CMND:',
                            style: textStyleInput,
                          ),
                          marginRight10,
                          Expanded(
                            child: TextField(
                                controller: cccdController,
                                keyboardType: TextInputType.number,
                                maxLength: maxlengthCCCD,
                                style: textStyleInput,
                                decoration: InputDecoration(
                                  hintText: 'Nhập CCCD',
                                  hintStyle:
                                      const TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                  errorText:
                                      isErrorTextCCCD ? errorTextCCCD : null,
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
                                          })
                                        }
                                      else
                                        {
                                          setState(() {
                                            errorTextCCCD = "";
                                            isErrorTextCCCD = false;
                                          })
                                        }
                                    }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: dividerColor, height: 0.05),
              SizedBox(
                height: 60,
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
              const Divider(color: dividerColor, height: 0.05),
              SizedBox(
                height: 60,
                child: Row(
                  children: [
                    const Text(
                      'Ngày sinh:',
                      style: textStyleInput,
                    ),
                    marginRight10,
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
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
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: dividerColor, height: 0.05),
              SizedBox(
                height: 60,
                child: Row(
                  children: [
                    const Text(
                      'Số điện thoại:',
                      style: textStyleInput,
                    ),
                    marginRight10,
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                                controller: phoneController,
                                style: textStyleInput,
                                keyboardType: TextInputType.phone,
                                maxLength: maxlengthPhone,
                                decoration: InputDecoration(
                                  hintText: 'Nhập số điện thoại',
                                  hintStyle:
                                      const TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                  errorText:
                                      isErrorTextPhone ? errorTextPhone : null,
                                  errorStyle: textStyleErrorInput,
                                ),
                                onChanged: (value) => {
                                      if (value.trim().length >
                                              maxlengthPhone ||
                                          value.trim().length < minlengthPhone)
                                        {
                                          setState(() {
                                            errorTextPhone =
                                                "Từ $minlengthPhone đến $maxlengthPhone ký tự.";
                                            isErrorTextPhone = true;
                                          })
                                        }
                                      else
                                        {
                                          setState(() {
                                            errorTextPhone = "";
                                            isErrorTextPhone = false;
                                          })
                                        }
                                    }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: dividerColor, height: 0.05),
              SizedBox(
                height: 60,
                child: Row(
                  children: [
                    const Text(
                      'Email:',
                      style: textStyleInput,
                    ),
                    marginRight10,
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                                controller: emailController,
                                style: textStyleInput,
                                decoration: InputDecoration(
                                  hintText: 'Nhập email',
                                  hintStyle:
                                      const TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                  errorText:
                                      isErrorTextEmail ? errorTextEmail : null,
                                  errorStyle: textStyleErrorInput,
                                ),
                                onChanged: (value) => {
                                      if (!Utils.isValidEmail(value))
                                        {
                                          setState(() {
                                            errorTextEmail =
                                                "Email không hợp lệ!";
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
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: dividerColor, height: 0.05),
              SizedBox(
                height: 60,
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Địa chỉ:',
                            style: textStyleInput,
                          ),
                          marginRight10,
                          Expanded(
                            child: TextField(
                                controller: addressController,
                                style: textStyleInput,
                                keyboardType: TextInputType.streetAddress,
                                maxLength: maxlengthAddress,
                                decoration: InputDecoration(
                                  hintText: 'Nhập địa chỉ',
                                  hintStyle:
                                      const TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                  errorText: isErrorTextAddress
                                      ? errorTextAddress
                                      : null,
                                  errorStyle: textStyleErrorInput,
                                ),
                                onChanged: (value) => {
                                      if (value.trim().length >
                                              maxlengthAddress ||
                                          value.trim().length <
                                              minlengthAddress)
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
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
                        onTap: () => {},
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
