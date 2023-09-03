import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myorder/constants.dart';

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
  @override
  void initState() {
    super.initState();
  }

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
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController roleController = TextEditingController();
    final TextEditingController cccdController = TextEditingController();
    final TextEditingController genderController = TextEditingController();
    final TextEditingController birthdayController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController addressController = TextEditingController();

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
                    const Text(
                      "Họ tên:",
                      style: textStyleTitleGrayRegular16,
                    ),
                    const SizedBox(
                      width: 62,
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                              child: TextField(
                            controller: nameController,
                           
                            style: textStyleInput,
                            decoration: const InputDecoration(
                              hintText: 'Nhập tên của bạn',
                              hintStyle: TextStyle(color: Colors.grey),
                              border:
                                  InputBorder.none, // Xóa border của TextField
                            ),
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
                    const Text(
                      "Chức vụ:",
                      style: textStyleTitleGrayRegular16,
                    ),
                    const SizedBox(
                      width: 52,
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: roleController,
                              
                              style: textStyleInput,
                              decoration: const InputDecoration(
                                hintText: 'Nhập chức vụ',
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder
                                    .none, // Xóa border của TextField
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
                      "CCCC:",
                      style: textStyleTitleGrayRegular16,
                    ),
                    const SizedBox(
                      width: 70,
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: cccdController,
                             
                              style: textStyleInput,
                              decoration: const InputDecoration(
                                hintText: 'Nhập CCCD',
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder
                                    .none, // Xóa border của TextField
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
                      "Giới Tính:",
                      style: textStyleTitleGrayRegular16,
                    ),
                    const SizedBox(
                      width: 49,
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: genderController,
                              
                              style: textStyleInput,
                              decoration: const InputDecoration(
                                hintText: 'Nhập tên của bạn',
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder
                                    .none, // Xóa border của TextField
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
                      "Sinh nhật:",
                      style: textStyleTitleGrayRegular16,
                    ),
                    const SizedBox(
                      width: 45,
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: birthdayController,
                             
                              keyboardType: TextInputType
                                  .datetime, // Kiểu bàn phím để hiển thị bàn phím số và chọn ngày
                              onTap: () async {
                                // Xử lý khi ô nhập liệu được nhấn
                                final selectedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime(2101),
                                );

                                if (selectedDate != null) {
                                  setState(() {
                                    birthdayController.text = selectedDate
                                        .toLocal()
                                        .toString()
                                        .split(' ')[0];
                                  });
                                }
                              },
                              style: textStyleInput,
                              decoration: const InputDecoration(
                                hintText: 'Chọn ngày sinh',
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder
                                    .none, // Xóa border của TextField
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
                      "Số điện thoại:",
                      style: textStyleTitleGrayRegular16,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: phoneController,
                             
                              style: textStyleInput,
                              decoration: const InputDecoration(
                                hintText: 'Nhập số điện thoại',
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder
                                    .none, // Xóa border của TextField
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
                      "Email:",
                      style: textStyleTitleGrayRegular16,
                    ),
                    const SizedBox(
                      width: 74,
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: emailController,
                             
                              style: textStyleInput,
                              decoration: const InputDecoration(
                                hintText: 'Nhập email',
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder
                                    .none, // Xóa border của TextField
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
                      "Địa chỉ:",
                      style: textStyleTitleGrayRegular16,
                    ),
                    const SizedBox(
                      width: 65,
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: addressController,
                              
                              style: textStyleInput,
                              decoration: const InputDecoration(
                                hintText: 'Nhập địa chỉ',
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder
                                    .none, // Xóa border của TextField
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: () => {},
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 50,
                  decoration: const BoxDecoration(
                      color: primaryColor, borderRadius: boderButtonPrimary),
                  child: const Align(
                    alignment: Alignment.center,
                    child: Text("THÊM MỚI", style: buttonStyleBlackBold),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
