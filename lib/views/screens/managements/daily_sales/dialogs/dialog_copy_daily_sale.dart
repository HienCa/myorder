// ignore_for_file: non_constant_identifier_names, avoid_print, prefer_interpolation_to_compose_strings, constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/daily_sales/daily_sales_controller.dart';
import 'package:myorder/models/daily_sales.dart';
import 'package:myorder/utils.dart';
import 'package:myorder/views/widgets/headers/header_icon_close.dart';
import 'package:myorder/views/widgets/textfields/text_field_label/text_field_string.dart';
import 'package:myorder/views/widgets/textfields/text_field_label/text_field_string_select.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

class MyDialogCopyDailySale extends StatefulWidget {
  final DailySales dailySale;

  const MyDialogCopyDailySale({
    Key? key,
    required this.dailySale,
  }) : super(key: key);

  @override
  State<MyDialogCopyDailySale> createState() => _MyDialogCopyDailySaleState();
}

class _MyDialogCopyDailySaleState extends State<MyDialogCopyDailySale> {
  var nameEditingController = TextEditingController();
  var dateApplyShowEditingController = TextEditingController();
  var dateApplyEditingController = TextEditingController();

  DailySalesController dailySalesController = Get.put(DailySalesController());

  @override
  void dispose() {
    super.dispose();
    dateApplyShowEditingController.dispose();
    dateApplyEditingController.dispose();
    nameEditingController.dispose();
  }

  @override
  void initState() {
    super.initState();

    nameEditingController.text = widget.dailySale.name;
    dateApplyEditingController.text =
        Utils.getDateTimeAddOne((widget.dailySale.date_apply.toDate()))
            .toString();

    dateApplyShowEditingController.text = Utils.formatDateTime(
        Utils.getDateTimeAddOne((widget.dailySale.date_apply.toDate())));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
      backgroundColor: grayColor200,
      child: Theme(
        data: ThemeData(unselectedWidgetColor: primaryColor),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const MyHeaderIconClose(
              title: "THÊM MỚI TỪ COPY",
            ),
            marginTop10,
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  MyTextFieldString(
                      textController: nameEditingController,
                      label: "Tên gợi nhớ",
                      placeholder: "",
                      isReadOnly: false,
                      min: 0,
                      max: 255,
                      isRequire: false),
                  InkWell(
                    onTap: () async {
                      DateTime? dateApplied = await Utils.selectDate(context);

                      if (dateApplied != null) {
                        setState(() {
                          //giá trị lưu firebase
                          dateApplyEditingController.text =
                              dateApplied.toString();
                          //hiển thị giao diện
                          dateApplyShowEditingController.text =
                              Utils.formatDateTime(dateApplied);
                        });
                      }
                    },
                    child: MyTextFieldStringOnTap(
                        textController: dateApplyShowEditingController,
                        label: "Ngày áp dụng",
                        placeholder: "Chọn ngày áp dụng",
                        isRequire: true),
                  )
                ],
              ),
            ),
            InkWell(
              onTap: () async {
                if (dateApplyEditingController.text == "") {
                  Utils.showStylishDialog(context, "THÔNG BÁO",
                      "Vui lòng chọn ngày áp dụng", StylishDialogType.INFO);
                } else {
                  //thêm mới
                  bool isExist = true;
                  isExist =
                      await dailySalesController.searchDailySalesByDateTime(
                          Utils.convertDatetimeStringToTimestamp(
                                  dateApplyEditingController.text)
                              .toDate());

                  if (isExist == false) {
                    dailySalesController.createDailySaleCopy(
                        widget.dailySale.daily_sale_id,
                        nameEditingController.text,
                        Utils.convertDatetimeStringToTimestamp(
                            dateApplyEditingController.text));
                    Utils.myPopResult(context, "add");
                  } else {
                    Utils.showStylishDialog(
                        context,
                        "THÔNG BÁO",
                        "Đã lên lịch cho ngày ${dateApplyShowEditingController.text}",
                        StylishDialogType.INFO);
                  }
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                margin: const EdgeInsets.all(8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("XÁC NHẬN", style: textStyleWhiteBold16),
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
