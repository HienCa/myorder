// ignore_for_file: avoid_single_cascade_in_expression_statements

// import 'package:awesome_dialog/awesome_dialog.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/profile_controller.dart';

class EmployeeDetailPage extends StatefulWidget {
  final String uid;
  const EmployeeDetailPage({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<EmployeeDetailPage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<EmployeeDetailPage> {
  final ProfileController profileController = Get.put(ProfileController());
  String? selectedImagePath;
  final Rx<File?> _pickedImage = Rx<File?>(null);

  @override
  void initState() {
    super.initState();
    profileController.updateUserId(widget.uid);
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
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        leading: InkWell(
            onTap: () => {Navigator.pop(context)},
            child: const Icon(Icons.arrow_back_ios)),
        title: const Center(child: Text("CẬP NHẬT TÀI KHOẢN")),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(
                height: 100,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          if (selectedImagePath != null)
                            ClipOval(
                              child: Image.file(
                                File(selectedImagePath!),
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            )
                          else
                            Row(
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
                                const SizedBox(
                                  width: 20,
                                ),
                                const Text(
                                  "Nguyễn Văn Hiền",
                                  style: textStyleFoodNameBold20,
                                ),
                                // Expanded(
                                //   child: Row(
                                //     children: [
                                //       const Expanded(
                                //         child: TextField(

                                //           decoration: InputDecoration(
                                //             border: InputBorder
                                //                 .none, // Xóa border của TextField

                                //           ),
                                //         ),
                                //       ),
                                //       InkWell(
                                //           onTap: () => {},
                                //           child: const Icon(Icons.edit,
                                //               color:
                                //                   iconColor)), // Icon chỉnh sửa
                                //     ],
                                //   ),
                                // ),
                              ],
                            ),
                          Positioned(
                            bottom: -10,
                            left: 60,
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
                    const Icon(Icons.home, color: iconColor),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      "Chức vụ",
                      style: textStyleTitleGrayRegular16,
                    ),
                    const SizedBox(
                      width: 52,
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          const Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                border: InputBorder
                                    .none, // Xóa border của TextField
                              ),
                            ),
                          ),
                          InkWell(
                              onTap: () => {},
                              child: const Icon(Icons.edit,
                                  color: iconColor)), // Icon chỉnh sửa
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
                    const Icon(Icons.home, color: iconColor),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      "CCCC",
                      style: textStyleTitleGrayRegular16,
                    ),
                    const SizedBox(
                      width: 70,
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          const Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                border: InputBorder
                                    .none, // Xóa border của TextField
                              ),
                            ),
                          ),
                          InkWell(
                              onTap: () => {},
                              child: const Icon(Icons.edit,
                                  color: iconColor)), // Icon chỉnh sửa
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
                    const Icon(Icons.home, color: iconColor),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      "Giới Tính",
                      style: textStyleTitleGrayRegular16,
                    ),
                    const SizedBox(
                      width: 49,
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          const Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                border: InputBorder
                                    .none, // Xóa border của TextField
                              ),
                            ),
                          ),
                          InkWell(
                              onTap: () => {},
                              child: const Icon(Icons.edit,
                                  color: iconColor)), // Icon chỉnh sửa
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
                    const Icon(Icons.home, color: iconColor),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      "Sinh nhật",
                      style: textStyleTitleGrayRegular16,
                    ),
                    const SizedBox(
                      width: 45,
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          const Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                border: InputBorder
                                    .none, // Xóa border của TextField
                              ),
                            ),
                          ),
                          InkWell(
                              onTap: () => {},
                              child: const Icon(Icons.edit,
                                  color: iconColor)), // Icon chỉnh sửa
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
                    const Icon(Icons.home, color: iconColor),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      "Số điện thoại",
                      style: textStyleTitleGrayRegular16,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          const Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                border: InputBorder
                                    .none, // Xóa border của TextField
                              ),
                            ),
                          ),
                          InkWell(
                              onTap: () => {},
                              child: const Icon(Icons.edit,
                                  color: iconColor)), // Icon chỉnh sửa
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
                    const Icon(Icons.home, color: iconColor),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      "Email",
                      style: textStyleTitleGrayRegular16,
                    ),
                    const SizedBox(
                      width: 74,
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          const Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                border: InputBorder
                                    .none, // Xóa border của TextField
                              ),
                            ),
                          ),
                          InkWell(
                              onTap: () => {},
                              child: const Icon(Icons.edit,
                                  color: iconColor)), // Icon chỉnh sửa
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
                    const Icon(Icons.home, color: iconColor),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      "Địa chỉ",
                      style: textStyleTitleGrayRegular16,
                    ),
                    const SizedBox(
                      width: 65,
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          const Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                border: InputBorder
                                    .none, // Xóa border của TextField
                              ),
                            ),
                          ),
                          InkWell(
                              onTap: () => {},
                              child: const Icon(Icons.edit,
                                  color: iconColor)), // Icon chỉnh sửa
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
                    child: Text("CẬP NHẬT", style: buttonStyleBlackBold),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
