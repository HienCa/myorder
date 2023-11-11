// ignore_for_file: non_constant_identifier_names, avoid_print, prefer_interpolation_to_compose_strings

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/area/areas_controller.dart';
import 'package:myorder/controllers/tables/tables_controller.dart';
import 'package:myorder/models/area.dart';
import 'package:myorder/utils.dart';
import 'package:myorder/views/widgets/textfields/text_field_label/text_field_number.dart';
import 'package:myorder/views/widgets/textfields/text_field_label/text_field_string.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

class CustomDialogCreateUpdateTable extends StatefulWidget {
  final bool isUpdate;
  final String? table_id;
  final String? area_id;
  final String? name;
  final int? total_slot;
  final int? active;
  const CustomDialogCreateUpdateTable(
      {Key? key,
      required this.isUpdate,
      this.table_id,
      this.area_id,
      this.name,
      this.total_slot,
      this.active})
      : super(key: key);

  @override
  State<CustomDialogCreateUpdateTable> createState() =>
      _CustomDialogCreateUpdateTableState();
}

class _CustomDialogCreateUpdateTableState
    extends State<CustomDialogCreateUpdateTable> {
  var isActive = true;
  String? errorTextName = "";
  String? errorTextTotalSlot = "";
  final TextEditingController nameController = TextEditingController();
  final TextEditingController totalSlotController = TextEditingController();
  final TextEditingController areaIdController = TextEditingController();
  final TextEditingController activeController = TextEditingController();
  final TextEditingController textSearchAreaController =
      TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    totalSlotController.dispose();
    areaIdController.dispose();
    activeController.dispose();
    textSearchAreaController.dispose();
    super.dispose();
  }

  TableController tableController = Get.put(TableController());
  AreaController areaController = Get.put(AreaController());
  List<Area> areaOptions = List.empty();
  Area areaFirstOption = Area(area_id: "", name: "titleArea", active: 1);
  bool isErrorTextName = false;
  bool isErrorTextAreaId = false;
  bool isErrorTextTotalSlot = false;
  late final bool isUpdate; // Declare isUpdate here
  @override
  void initState() {
    super.initState();
    isUpdate =
        widget.isUpdate; // Initialize isUpdate with the value from the widget
    if (widget.table_id != null) {
      nameController.text = widget.name ?? "";
      totalSlotController.text = "${widget.total_slot}";
      nameController.text = widget.name ?? "";
      areaIdController.text = widget.area_id ?? "";
      isActive = widget.active == ACTIVE ? true : false;
    }
    getAreasActive().then((areas) {
      setState(() {
        areaOptions = areas;
        if (widget.table_id != null) {
          selectedValue = areaList.firstWhere(
            (area) => area.area_id == widget.area_id,
            orElse: () => Area(area_id: "", name: "", active: 1),
          );
        }
      });
    });
  }

  Area? selectedValue;
  List<Area> areaList = [];
  Future<List<Area>> getAreasActive() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('areas')
          .where('active', isEqualTo: 1)
          .get();
      for (final doc in querySnapshot.docs) {
        final area = Area.fromSnap(doc);
        areaList.add(area);
        print(area.name);
      }
      // In danh sách bàn ra màn hình kiểm tra
      return areaList;
    } catch (e) {
      print('Error fetching tables: $e');
    }
    return areaList;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Góc bo tròn
      ),
      elevation: 5, // Độ nâng của bóng đổ
      backgroundColor: backgroundColor,
      child: Theme(
        data: ThemeData(unselectedWidgetColor: primaryColor),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        'BÀN',
                        style: textStylePrimaryBold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: MyTextFieldString(
                        textController: nameController,
                        label: 'Tên bàn',
                        placeholder: 'Nhập tên bàn...',
                        isReadOnly: false,
                        min: minlength2,
                        max: minlength2,
                        isRequire: true,
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: MyTextFieldNumber(
                            textController: totalSlotController,
                            label: 'Số khách',
                            placeholder: 'Nhập số khách tối đa của bàn',
                            isReadOnly: false,
                            max: MAX_SLOT_TABLE,
                            min: MIN_SLOT_TABLE,
                            isRequire: true)),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      height: 50,
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                const Row(
                                  children: [
                                    Text(
                                      'Khu vực:',
                                      style: textStyleInput,
                                    ),
                                    marginRight10,
                                    Text(
                                      '(*)',
                                      style: textStyleErrorInput,
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton2<Area>(
                                      isExpanded: true,
                                      hint: Text(
                                        'Tìm kiếm khu vực',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Theme.of(context).hintColor,
                                        ),
                                      ),
                                      items: areaList
                                          .map((item) => DropdownMenuItem(
                                                value: item,
                                                child: Text(
                                                  item.name,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ))
                                          .toList(),
                                      value: selectedValue,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedValue = value;
                                          print("area selected: " +
                                              selectedValue!.area_id);
                                          if (selectedValue!.area_id != "") {
                                            isErrorTextAreaId = false;
                                            areaIdController.text =
                                                selectedValue!.area_id;
                                          } else {
                                            isErrorTextAreaId = true;
                                          }
                                        });
                                      },
                                      buttonStyleData: const ButtonStyleData(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16),
                                        height: 40,
                                        width: 200,
                                      ),
                                      dropdownStyleData:
                                          const DropdownStyleData(
                                        maxHeight: 200,
                                      ),
                                      menuItemStyleData:
                                          const MenuItemStyleData(
                                        height: 40,
                                      ),
                                      dropdownSearchData: DropdownSearchData(
                                        searchController:
                                            textSearchAreaController,
                                        searchInnerWidgetHeight: 50,
                                        searchInnerWidget: Container(
                                          height: 50,
                                          padding: const EdgeInsets.only(
                                            top: 8,
                                            bottom: 4,
                                            right: 8,
                                            left: 8,
                                          ),
                                          child: TextFormField(
                                            expands: true,
                                            maxLines: null,
                                            controller:
                                                textSearchAreaController,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 8,
                                              ),
                                              hintText: 'Tìm kiếm khu vực...',
                                              hintStyle:
                                                  const TextStyle(fontSize: 12),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                          ),
                                        ),
                                        searchMatchFn: (item, searchValue) {
                                          print("Search Value: $searchValue");

                                          return item.value!.name
                                              .toLowerCase()
                                              .toString()
                                              .contains(
                                                  searchValue.toLowerCase());
                                        },
                                      ),
                                      //This to clear the search value when you close the menu
                                      onMenuStateChange: (isOpen) {
                                        if (!isOpen) {
                                          textSearchAreaController.clear();
                                        }
                                      },
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
                      height: 10,
                    ),
                    isUpdate
                        ? ListTile(
                            leading: Theme(
                              data: ThemeData(
                                  unselectedWidgetColor: primaryColor),
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
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
                              if (!Utils.isValidLengthTextEditController(
                                  nameController, minlength2, minlength2))
                                {
                                  Utils.showStylishDialog(
                                      context,
                                      'THÔNG BÁO',
                                      'Tên bàn phải đủ 2 ký tự.',
                                      StylishDialogType.ERROR)
                                }
                              else if (!Utils.isValidRangeString(
                                  totalSlotController.text,
                                  MIN_SLOT_TABLE,
                                  MAX_SLOT_TABLE))
                                {
                                  Utils.showStylishDialog(
                                      context,
                                      'THÔNG BÁO',
                                      'Số lượng khách phải từ $MIN_SLOT_TABLE đến $MAX_SLOT_TABLE.',
                                      StylishDialogType.ERROR)
                                }
                              else
                                {
                                  if (widget.table_id != null &&
                                      areaIdController.text != "")
                                    {
                                      tableController.updateTable(
                                          widget.table_id!,
                                          nameController.text,
                                          totalSlotController.text,
                                          areaIdController.text,
                                          isActive)
                                    }
                                  else
                                    {
                                      if (areaIdController.text != "")
                                        {
                                          tableController.createTable(
                                              nameController.text,
                                              totalSlotController.text,
                                              areaIdController.text),
                                        }
                                    },
                                  Utils.myPopSuccess(context)
                                }
                            },
                            child: Container(
                              height: 50,
                              width: 136,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
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
                      height: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
