// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/suppliers/suppliers_controller.dart';
import 'package:myorder/utils.dart';
import 'package:myorder/views/screens/managements/suppliers/add_update_supplier_screen.dart';
import 'package:myorder/views/widgets/dialogs.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

class ManagementSupplierPage extends StatefulWidget {
  const ManagementSupplierPage({Key? key}) : super(key: key);
  @override
  _ManagementSupplierPageState createState() => _ManagementSupplierPageState();
}

class _ManagementSupplierPageState extends State<ManagementSupplierPage> {
  SupplierController supplierController = Get.put(SupplierController());

  @override
  void initState() {
    super.initState();
    supplierController.getSuppliers("");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: primaryColor,
          secondary: primaryColor,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          leading: InkWell(
              onTap: () => {Navigator.pop(context)},
              child: const Icon(Icons.arrow_back_ios)),
          title: const Center(child: Text("QUẢN LÝ NHÂN VIÊN")),
          actions: [
            Container(
                margin: const EdgeInsets.only(right: 10),
                child: InkWell(
                    onTap: () async {
                      final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const AddUpdateSupplierPage()));
                      if (result == 'success') {
                        Utils.showStylishDialog(
                            context,
                            'THÀNH CÔNG!',
                            'Thêm mới nhân viên thành công!',
                            StylishDialogType.SUCCESS);
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(Icons.add_circle_outline),
                    )))
          ],
          backgroundColor: primaryColor,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 50,
                  width: 400,
                  margin: const EdgeInsets.all(kDefaultPadding),
                  padding: const EdgeInsets.symmetric(
                    horizontal: kDefaultPadding,
                    vertical: kDefaultPadding / 4, // 5 top and bottom
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.4),
                      borderRadius: borderRadiusTextField30,
                      border: Border.all(width: 1, color: borderColorPrimary)),
                  child: TextField(
                    onChanged: (value) {
                      supplierController.getSuppliers(value);
                    },
                    style: const TextStyle(color: borderColorPrimary),
                    decoration: const InputDecoration(
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      fillColor: borderColorPrimary,
                      icon: Icon(
                        Icons.search,
                        color: iconColorPrimary,
                      ),
                      hintText: 'Tìm kiếm nhà cung cấp',
                      hintStyle: TextStyle(color: borderColorPrimary),
                    ),
                    cursorColor: borderColorPrimary,
                  ),
                ),
                marginTop10,
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.87,
                  child: Obx(() {
                    return ListView.builder(
                        itemCount: supplierController.suppliers.length,
                        itemBuilder: (context, index) {
                          final supplier = supplierController.suppliers[index];
                          String string;
                          return InkWell(
                            onTap: () async {
                              final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AddUpdateSupplierPage(
                                            supplier: supplier,
                                          )));
                              if (result == 'add') {
                                Utils.showStylishDialog(
                                    context,
                                    'THÀNH CÔNG!',
                                    'Thêm mới nhà cung cấp thành công!',
                                    StylishDialogType.SUCCESS);
                              } else if (result == 'update') {
                                Utils.showStylishDialog(
                                    context,
                                    'THÀNH CÔNG!',
                                    'Cập nhật thông tin nhà cung cấp thành công!',
                                    StylishDialogType.SUCCESS);
                              }
                            },
                            child: Card(
                              child: ListTile(
                                leading: supplier.avatar != ""
                                    ? CircleAvatar(
                                        radius: 25,
                                        backgroundColor: Colors.black,
                                        backgroundImage:
                                            NetworkImage(supplier.avatar!),
                                      )
                                    : CircleAvatar(
                                        child: Image.asset(
                                          'assets/images/user-default.png',
                                          width: 100,
                                          height: 100,
                                        ),
                                      ),
                                title: Row(
                                  children: [
                                    Marquee(
                                      direction: Axis.horizontal,
                                      textDirection: TextDirection.ltr,
                                      animationDuration:
                                          const Duration(seconds: 1),
                                      backDuration:
                                          const Duration(milliseconds: 4000),
                                      pauseDuration:
                                          const Duration(milliseconds: 1000),
                                      directionMarguee:
                                          DirectionMarguee.TwoDirection,
                                      child: Text(
                                        supplier.name,
                                        style: textStyleNameBlackRegular,
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: RichText(
                                  text: TextSpan(
                                    text: supplier.phone,
                                    style: const TextStyle(
                                        color: Colors
                                            .black), // Đặt kiểu cho văn bản
                                  ),
                                  maxLines: 5, // Giới hạn số dòng hiển thị
                                  overflow: TextOverflow
                                      .ellipsis, // Hiển thị dấu ba chấm khi văn bản quá dài
                                ),
                                trailing: InkWell(
                                  onTap: () => {
                                    string = supplier.active == ACTIVE
                                        ? "khóa"
                                        : "bỏ khóa",
                                    showCustomAlertDialogConfirm(
                                      context,
                                      "TRẠNG THÁI HOẠT ĐỘNG",
                                      "Bạn có chắc chắn muốn $string người dùng này?",
                                      colorWarning,
                                      () async {
                                        await supplierController
                                            .updateToggleActive(
                                                supplier.supplier_id,
                                                supplier.active);
                                      },
                                    )
                                  },
                                  child: supplier.active == ACTIVE
                                      ? const Icon(
                                          Icons.key,
                                          size: 25,
                                          color: activeColor,
                                        )
                                      : const Icon(
                                          Icons.key_off,
                                          size: 25,
                                          color: deActiveColor,
                                        ),
                                ),
                              ),
                            ),
                          );
                        });
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
