// ignore_for_file: avoid_print, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/area/areas_controller.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class CustomDialogCreateUpdateArea extends StatefulWidget {
  final bool isUpdate;
  final String? area_id;
  final String? name;
  final int? active;

  const CustomDialogCreateUpdateArea(
      {Key? key, required this.isUpdate, this.area_id, this.name, this.active})
      : super(key: key);
  @override
  State<CustomDialogCreateUpdateArea> createState() =>
      _CustomDialogCreateUpdateAreaState();
}

class _CustomDialogCreateUpdateAreaState
    extends State<CustomDialogCreateUpdateArea> {
  var isActive = true;
  String? errorTextName = "";
  final TextEditingController nameController = TextEditingController();
  final TextEditingController activeController = TextEditingController();
  AreaController areaController = Get.put(AreaController());

  bool isErrorTextName = false;
  late final bool isUpdate; // Declare isUpdate here
  @override
  void initState() {
    super.initState();
    isUpdate =
        widget.isUpdate; // Initialize isUpdate with the value from the widget
    if (widget.area_id != null) {
      nameController.text = widget.name ?? "";
      isActive = widget.active == ACTIVE ? true : false;
    }
  }

  @override
  Widget build(BuildContext context) {
    areaController.getAreas();
    return Theme(
       data: ThemeData(unselectedWidgetColor: primaryColor),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // Góc bo tròn
        ),
        elevation: 5, // Độ nâng của bóng đổ
        backgroundColor: backgroundColor,
        child: Container(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'KHU VỰC',
                  style: textStylePrimaryBold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: TextField(
                    controller: nameController,
                    style: textStyleInput,
                    decoration: InputDecoration(
                        labelStyle: textStyleInput,
                        labelText: "Tên khu vực",
                        hintText: 'Nhập tên khu vực',
                        hintStyle: const TextStyle(color: Colors.grey),
                        border:  const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),borderRadius: BorderRadius.all(Radius.circular(30))),
                        errorText: isErrorTextName ? errorTextName : null,
                        errorStyle: textStyleErrorInput),
                    maxLength: maxlengthAreaName,
                    onChanged: (value) => {
                          if (value.trim().length > maxlengthAreaName ||
                              value.trim().length < minlengthAreaName)
                            {
                              setState(() {
                                errorTextName =
                                    "Từ $minlengthAreaName đến $maxlengthAreaName ký tự.";
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
              ),
              const SizedBox(
                height: 10,
              ),
              isUpdate
                  ? ListTile(
                      leading: Theme(
                        data: ThemeData(unselectedWidgetColor: primaryColor),
                        child: Checkbox(
                          value: isActive,
                          onChanged: (bool? value) {
                            setState(() {
                              isActive = value!;
                            });
                          },
                          activeColor: primaryColor,
                        ),
                      ),
                      title: const Text(
                        "Đang hoạt động",
                        style: textStylePriceBold16,
                      ),
                    )
                  : const SizedBox(),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () => {Navigator.pop(context)},
                      child: Container(
                        height: 50,
                        width: 136,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: backgroundColorGray,
                        ),
                        child: const Center(
                          child: Text(
                            'HỦY BỎ',
                            style: textStyleCancel,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => {
                        if (!isErrorTextName)
                          {
                            if (widget.area_id != null)
                              {
                                areaController.updateArea(widget.area_id!,
                                    nameController.text, isActive)
                              }
                            else
                              {
                                areaController.createArea(nameController.text),
                              },
                            Navigator.pop(context),
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
                            Future.delayed(const Duration(seconds: 2), () {
                              Navigator.pop(context);
                            })
                          }
                          
                      },
                      child: Container(
                        height: 50,
                        width: 136,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: primaryColor,
                        ),
                        child: Center(
                          child: isUpdate == true
                              ? const Text(
                                  'CẬP NHẬT',
                                  style: textStyleWhiteBold20,
                                )
                              : const Text(
                                  'THÊM',
                                  style: textStyleWhiteBold20,
                                ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
