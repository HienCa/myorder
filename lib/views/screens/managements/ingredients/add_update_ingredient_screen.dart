// ignore_for_file: avoid_single_cascade_in_expression_statements, avoid_print, use_build_context_synchronously

// import 'package:awesome_dialog/awesome_dialog.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/ingredients/ingredients_controller.dart';
import 'package:myorder/models/ingredient.dart';
import 'package:myorder/models/unit.dart';
import 'package:myorder/utils.dart';
import 'package:myorder/views/widgets/textfields/text_field_label/text_field_string.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

class AddUpdateIngredientPage extends StatefulWidget {
  final Ingredient? ingredient;
  const AddUpdateIngredientPage({
    Key? key,
    this.ingredient,
  }) : super(key: key);

  @override
  State<AddUpdateIngredientPage> createState() =>
      _AddUpdateIngredientPageState();
}

class _AddUpdateIngredientPageState extends State<AddUpdateIngredientPage> {
  var isActive = true;
  String? selectedImagePath;
  final Rx<File?> _pickedImage = Rx<File?>(null);

  bool isCheckWeight = true;

  IngredientController ingredientController = Get.put(IngredientController());

  final TextEditingController nameController = TextEditingController();

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

    super.dispose();
  }

  double heightListCombo = 0;
  double heightListAddition = 0;
  @override
  void initState() {
    super.initState();
    if (widget.ingredient != null) {
      nameController.text = widget.ingredient!.name;
      // isCheckWeight = widget.ingredient!.is_weight == ACTIVE ? true : false;
    }

    getUnits().then((units) {
      setState(() {
        unitOptions = units;
      });
    });

    textUnitIdController.text = widget.ingredient!.unit_id;
  }

  final TextEditingController textSearchUnitController =
      TextEditingController();
  final TextEditingController textUnitIdController = TextEditingController();
  final TextEditingController textVatIdController = TextEditingController();

  // get units
  List<Unit> unitOptions = List.empty();
  Unit unitFirstOption = Unit(unit_id: "", name: "titleUnit", active: 1, value_conversion: 1, unit_id_conversion: '', unit_name_conversion: '');
  bool isErrorTextUnitId = false;
  Unit? selectedUnitValue;
  List<Unit> unitList = [];

  Future<List<Unit>> getUnits() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('units').get();
      for (final doc in querySnapshot.docs) {
        final unit = Unit.fromSnap(doc);
        unitList.add(unit);
        print(unit.name);
      }

      return unitList;
    } catch (e) {
      print('Error fetching units: $e');
    }
    return unitList;
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
        title: Center(
            child: Text(
          widget.ingredient == null ? "THÊM NGUYÊN LIỆU" : "CẬP NHẬT",
          style: const TextStyle(color: secondColor),
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
      body: Theme(
        data: ThemeData(unselectedWidgetColor: primaryColor),
        child: SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: Column(
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
                          mainAxisAlignment:
                              MainAxisAlignment.center, // Căn chỉnh dọc giữa
                          children: [
                            InkWell(
                              onTap: () async {
                                await pickImage();
                              },
                              child: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                radius: 50,
                                child: Image.asset(
                                  'assets/images/user-default.png',
                                ),
                              ),
                            ),
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
                SizedBox(
                  height: MediaQuery.of(context).size.height - 180,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyTextFieldString(
                        textController: nameController,
                        label: 'Tên nguyên liệu',
                        placeholder: 'Nhập tên',
                        isReadOnly: false,
                        min: minlength2,
                        max: maxlength255,
                        isRequire: true,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 5),
                        height: 50,
                        child: Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  const Text(
                                    'Đơn vị:',
                                    style: textStyleInput,
                                  ),
                                  marginRight10,
                                  const Text(
                                    '(*)',
                                    style: textStyleErrorInput,
                                  ),
                                  Expanded(
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton2<Unit>(
                                        isExpanded: true,
                                        hint: Text(
                                          'Tìm kiếm đơn vị tính',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Theme.of(context).hintColor,
                                          ),
                                        ),
                                        items: unitList
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
                                        value: selectedUnitValue,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedUnitValue = value;
                                            print(
                                                "Unit selected: ${selectedUnitValue!.unit_id}");
                                            if (selectedUnitValue!.unit_id !=
                                                "") {
                                              isErrorTextUnitId = false;
                                              textUnitIdController.text =
                                                  selectedUnitValue!.unit_id;
                                            } else {
                                              isErrorTextUnitId = true;
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
                                              textSearchUnitController,
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
                                                  textSearchUnitController,
                                              decoration: InputDecoration(
                                                isDense: true,
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 8,
                                                ),
                                                hintText: 'Tìm kiếm đơn vị...',
                                                hintStyle: const TextStyle(
                                                    fontSize: 12),
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
                                            textSearchUnitController.clear();
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
                      // ListTile(
                      //   leading: Theme(
                      //     data: ThemeData(unselectedWidgetColor: primaryColor),
                      //     child: Checkbox(
                      //       value: isCheckWeight,
                      //       onChanged: (bool? value) {
                      //         setState(() {
                      //           isCheckWeight = value!;
                      //         });
                      //       },
                      //       activeColor: primaryColor,
                      //     ),
                      //   ),
                      //   title: const Text(
                      //     "Bán theo khối lượng",
                      //     style: textStylePriceBold16,
                      //   ),
                      // ),
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
                                    child: Text("QUAY LẠI",
                                        style: buttonStyleCancel),
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
                                  if (!Utils.isValidLengthTextEditController(
                                      nameController, minlength2, maxlength255))
                                    {
                                      Utils.showStylishDialog(
                                          context,
                                          'THÔNG BÁO',
                                          'Tên nguyên liệu phải từ $minlength2 đến $maxlength255 ký tự.',
                                          StylishDialogType.ERROR)
                                    }
                                  else
                                    {
                                      if (widget.ingredient != null)
                                        {
                                          ingredientController.updateIngredient(
                                              widget.ingredient!.ingredient_id,
                                              nameController.text,
                                              _pickedImage.value,
                                              // isCheckWeight == true
                                              //     ? ACTIVE
                                              //     : DEACTIVE,
                                              textUnitIdController.text),
                                          Utils.myPopResult(context, "update")
                                        }
                                      else
                                        {
                                          ingredientController.createIngredient(
                                              nameController.text,
                                              _pickedImage.value,
                                              // isCheckWeight == true
                                              //     ? ACTIVE
                                              //     : DEACTIVE,
                                              textUnitIdController.text),
                                          Utils.myPopResult(context, "add")
                                        }
                                    }
                                },
                                child: Container(
                                  height: 50,
                                  decoration: const BoxDecoration(
                                      color: primaryColor,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                        widget.ingredient == null
                                            ? "THÊM MỚI"
                                            : "CẬP NHẬT",
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
              ],
            )),
      ),
    );
  }
}
