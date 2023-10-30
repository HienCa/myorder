// ignore_for_file: avoid_single_cascade_in_expression_statements, avoid_print, use_build_context_synchronously

// import 'package:awesome_dialog/awesome_dialog.dart';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/categories/categories_controller.dart';
import 'package:myorder/controllers/foods/foods_controller.dart';
import 'package:myorder/controllers/units/units_controller.dart';
import 'package:myorder/controllers/vats/vats_controller.dart';
import 'package:myorder/models/food.dart';
import 'package:myorder/models/unit.dart';
import 'package:myorder/models/vat.dart';
import 'package:myorder/models/category.dart' as model;
import 'package:myorder/utils.dart';
import 'package:myorder/views/widgets/textfields/text_field_price.dart';
import 'package:myorder/views/widgets/textfields/text_field_string.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

class AddFoodPage extends StatefulWidget {
  const AddFoodPage({
    Key? key,
  }) : super(key: key);

  @override
  State<AddFoodPage> createState() => _AddFoodPageState();
}

class _AddFoodPageState extends State<AddFoodPage> {
  var isActive = true;
  String? selectedImagePath;
  final Rx<File?> _pickedImage = Rx<File?>(null);
  final List<String> roleOptions = ROLE_OPTION;
  String? errorTextName = "";
  String? errorTextPrice = "";
  String? errorTextTemporaryPriceFromDate = "";
  String? errorTextTemporaryPriceToDate = "";
  String? errorTextTemporaryPrice = "";
  String? errorTextTemporaryPercent = "";

  bool isErrorTextName = false;
  bool isErrorTextPrice = false;
  bool isErrorTextTemporaryPriceFromDate = false;
  bool isErrorTextTemporaryPriceToDate = false;
  bool isErrorTextTemporaryPrice = false;
  bool isErrorTextTemporaryPercent = false;

  bool isMaleSelected = true;
  bool isFemaleSelected = false;

  bool isCheckTemporaryWithPrice = true;
  bool isCheckTemporaryWithPercent = false;

  bool isOnlyReadTemporaryWithPrice = false;
  bool isOnlyReadTemporaryWithPercent = true;

  FoodController foodController = Get.put(FoodController());
  late Food food;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController temporaryWithPriceController =
      TextEditingController();
  final TextEditingController temporaryWithPercentController =
      TextEditingController();
  final TextEditingController temporaryPriceFromDateController =
      TextEditingController();

  final TextEditingController temporaryPriceToDateController =
      TextEditingController();
  final TextEditingController temporaryPriceController =
      TextEditingController();
  final TextEditingController temporaryPercentController =
      TextEditingController();

  final TextEditingController increasePriceController = TextEditingController();
  final TextEditingController decreasePriceController = TextEditingController();
  bool isCheckIncrease = true;
  bool isCheckDecrease = false;

  String temporaryPriceFromDate = "";
  String temporaryPriceToDate = "";
  DateTime? _selectedtemporaryPriceFromDate;
  DateTime? _selectedtemporaryPriceToDate;
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

  late DateTime pickedFromDateTime = DateTime.now();
  late DateTime pickedToDateTime = DateTime.now();
  bool isFromDateTimeSelected = false;
  bool isToDateTimeSelected = false;
  Future<void> _selectTemporaryFromDate(BuildContext context) async {
    final DateTime currentDate = DateTime.now();
    final TimeOfDay currentTime = TimeOfDay.fromDateTime(currentDate);
    final DateTime pickedDate = (await showDatePicker(
          context: context,
          initialDate: _selectedtemporaryPriceFromDate ?? currentDate,
          firstDate: currentDate,
          lastDate:
              DateTime(2200), // You can adjust this to a suitable maximum date.
        )) ??
        currentDate;

    final TimeOfDay pickedTime = (await showTimePicker(
          context: context,
          initialTime:
              TimeOfDay(hour: currentTime.hour, minute: currentTime.minute),
        )) ??
        TimeOfDay(hour: currentTime.hour, minute: currentTime.minute);

    final DateTime pickedDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    if (pickedDateTime.isAfter(currentDate)) {
      setState(() {
        isFromDateTimeSelected = true;

        pickedFromDateTime = pickedDateTime;

        isErrorTextTemporaryPriceFromDate = false;
        errorTextTemporaryPriceFromDate = "";

        _selectedtemporaryPriceFromDate = pickedDateTime;
        temporaryPriceFromDateController.text =
            "${pickedDateTime.day.toString().padLeft(2, '0')}/${pickedDateTime.month.toString().padLeft(2, '0')}/${pickedDateTime.year} ${pickedTime.format(context)}";

        temporaryPriceFromDate =
            "${pickedDateTime.day.toString().padLeft(2, '0')}/${pickedDateTime.month.toString().padLeft(2, '0')}/${pickedDateTime.year} ${pickedTime.format(context)}";

        if (!pickedToDateTime.isAfter(pickedFromDateTime) &&
            temporaryPriceToDateController.text != "") {
          isErrorTextTemporaryPriceToDate = true;
          errorTextTemporaryPriceToDate =
              "Thời gian kết thúc phải lớn hơn thời gian bắt đầu.";
        }
      });
    } else {
      setState(() {
        isFromDateTimeSelected = false;

        isErrorTextTemporaryPriceFromDate = true;
        errorTextTemporaryPriceFromDate =
            "Thời gian bắt đầu phải lớn hơn hiện tại.";
        // Alert(
        //   context: context,
        //   title: "THÔNG BÁO",
        //   desc: "Thời gian bắt đầu phải lớn hơn hiện tại!",
        //   image: alertImageError,
        //   buttons: [],
        // ).show();
        // Future.delayed(const Duration(seconds: 2), () {
        //   Navigator.pop(context);
        // });
        Utils.showStylishDialog(
            context,
            'THÔNG BÁO',
            'Thời gian bắt đầu phải lớn hơn hiện tại.',
            StylishDialogType.ERROR);
      });
    }
  }

  Future<void> _selectTemporaryToDate(BuildContext context) async {
    final DateTime currentDate = DateTime.now();
    final TimeOfDay currentTime = TimeOfDay.fromDateTime(currentDate);
    final DateTime pickedDate = (await showDatePicker(
          context: context,
          initialDate: _selectedtemporaryPriceToDate ?? currentDate,
          firstDate: currentDate,
          lastDate: DateTime(2200),
        )) ??
        currentDate;

    final TimeOfDay pickedTime = (await showTimePicker(
          context: context,
          initialTime:
              TimeOfDay(hour: currentTime.hour, minute: currentTime.minute),
        )) ??
        TimeOfDay(hour: currentTime.hour, minute: currentTime.minute);

    final DateTime pickedDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
    if (!isFromDateTimeSelected) {
      isErrorTextTemporaryPriceToDate = true;
      // Alert(
      //   context: context,
      //   title: "THÔNG BÁO",
      //   desc: "Vui lòng chọn thời gian bắt đầu!",
      //   image: alertImageError,
      //   buttons: [],
      // ).show();
      // Future.delayed(const Duration(seconds: 2), () {
      //   Navigator.pop(context);
      // });
      Utils.showStylishDialog(context, 'THÔNG BÁO',
          "Vui lòng chọn thời gian bắt đầu!", StylishDialogType.ERROR);
    }
    if (pickedDateTime.isAfter(currentDate) &&
        pickedDateTime.isAfter(pickedFromDateTime) &&
        isFromDateTimeSelected) {
      setState(() {
        pickedToDateTime = pickedDateTime;
        isToDateTimeSelected = true;
        isErrorTextTemporaryPriceToDate = false;
        errorTextTemporaryPriceToDate = "";

        _selectedtemporaryPriceToDate = pickedDateTime;
        temporaryPriceToDateController.text =
            "${pickedDateTime.day.toString().padLeft(2, '0')}/${pickedDateTime.month.toString().padLeft(2, '0')}/${pickedDateTime.year} ${pickedTime.format(context)}";

        temporaryPriceToDate =
            "${pickedDateTime.day.toString().padLeft(2, '0')}/${pickedDateTime.month.toString().padLeft(2, '0')}/${pickedDateTime.year} ${pickedTime.format(context)}";
      });
    } else {
      if (isFromDateTimeSelected) {
        isErrorTextTemporaryPriceToDate = true;
        setState(() {
          if (temporaryPriceToDateController.text == "") {
            errorTextTemporaryPriceToDate =
                "Thời gian kết thúc phải lớn hơn thời gian bắt đầu.";
          } else {
            errorTextTemporaryPriceToDate = "";
          }

          // Alert(
          //   context: context,
          //   title: "THÔNG BÁO",
          //   desc: "Thời gian kết thúc phải lớn hơn thời gian bắt đầu!",
          //   image: alertImageError,
          //   buttons: [],
          // ).show();
          // Future.delayed(const Duration(seconds: 2), () {
          //   Navigator.pop(context);
          // });
          Utils.showStylishDialog(
              context,
              'THÔNG BÁO',
              "Thời gian kết thúc phải lớn hơn thời gian bắt đầu!",
              StylishDialogType.ERROR);
        });
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    temporaryWithPriceController.dispose();
    temporaryPriceFromDateController.dispose();
    temporaryPriceToDateController.dispose();
    temporaryPriceController.dispose();
    temporaryPercentController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    getCategories().then((categories) {
      setState(() {
        categoryOptions = categories;
        // selectedCategoryValue = categoryList.firstWhere(
        //   (category) => category.category_id == widget.category_id,
        //   orElse: () => model.Category(category_id: "", name: "", active: 1),
        // );
      });
    });
    getUnits().then((units) {
      setState(() {
        unitOptions = units;
        // selectedUnitValue = unitList.firstWhere(
        //   (unit) => unit.unit_id == widget.unit_id,
        //   orElse: () => Unit(unit_id: "", name: "", active: 1),
        // );
      });
    });
    getVats().then((vats) {
      setState(() {
        vatOptions = vats;
        // selectedVatValue = vatList.firstWhere(
        //   (vat) => vat.vat_id == widget.vat_id,
        //   orElse: () => Vat(vat_id: "", name: "", active: 1, vat_percent: 0),
        // );
      });
    });
  }

  final TextEditingController textSearchCategotyController =
      TextEditingController();
  final TextEditingController textSearchUnitController =
      TextEditingController();
  final TextEditingController textSearchVatController = TextEditingController();
  final TextEditingController textCategoryIdController =
      TextEditingController();
  final TextEditingController textCategoryCodeController =
      TextEditingController();
  final TextEditingController textUnitIdController = TextEditingController();
  final TextEditingController textVatIdController = TextEditingController();

  VatController vatController = Get.put(VatController());
  UnitController unitController = Get.put(UnitController());
  CategoryController categoryController = Get.put(CategoryController());

  // get units
  List<Unit> unitOptions = List.empty();
  Unit unitFirstOption = Unit(unit_id: "", name: "titleUnit", active: 1);
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
        print("lits unit");
        print(unit.name);
      }
      // In danh sách bàn ra màn hình kiểm tra
      return unitList;
    } catch (e) {
      print('Error fetching units: $e');
    }
    return unitList;
  }

  bool isCheckTemporaryPrice = false;
  bool isCheckVAT = false;
  //get vats
  List<Vat> vatOptions = List.empty();
  Vat vatFirstOption =
      Vat(vat_id: "", name: "titleVat", active: 1, vat_percent: 0);
  bool isErrorTextVatId = false;
  Vat? selectedVatValue;
  List<Vat> vatList = [];

  Future<List<Vat>> getVats() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('vats').get();
      for (final doc in querySnapshot.docs) {
        final vat = Vat.fromSnap(doc);
        vatList.add(vat);
        print("lits vat");
        print(vat.name);
      }
      // In danh sách bàn ra màn hình kiểm tra
      return vatList;
    } catch (e) {
      print('Error fetching units: $e');
    }
    return vatList;
  }

  // get Categories
  List<model.Category> categoryOptions = List.empty();
  model.Category categoryFirstOption = model.Category(
      category_id: "",
      name: "titleCategory",
      active: 1,
      category_code: CATEGORY_ALL);
  bool isErrorTextCategoryId = false;
  model.Category? selectedCategoryValue;
  List<model.Category> categoryList = [];

  Future<List<model.Category>> getCategories() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('categories').get();
      for (final doc in querySnapshot.docs) {
        final category = model.Category.fromSnap(doc);
        categoryList.add(category);
        print("lits category");
        print(category.name);
      }
      // In danh sách bàn ra màn hình kiểm tra
      return categoryList;
    } catch (e) {
      print('Error fetching categories: $e');
    }
    return categoryList;
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
          "THÊM MÓN",
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
      body: Theme(
        data: ThemeData(unselectedWidgetColor: primaryColor),
        child: SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(10.0),
                  child: SingleChildScrollView(
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
                                  mainAxisAlignment: MainAxisAlignment
                                      .center, // Căn chỉnh dọc giữa
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
                        MyTextFieldString(
                          textController: nameController,
                          label: 'Tên món',
                          placeholder: 'Nhập tên món',
                          isReadOnly: false,
                          min: minlength2,
                          max: maxlength255,
                          isRequire: true,
                        ),
                        MyTextFieldPrice(
                            textEditingController: priceController,
                            label: 'Đơn giá',
                            placeholder: 'Nhập giá món',
                            min: MIN_PRICE,
                            max: MAX_PERCENT,
                            isRequire: true),
                        Container(
                          margin: const EdgeInsets.only(left: 5),
                          height: 50,
                          child: Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    const Text(
                                      'Danh mục:',
                                      style: textStyleInput,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton2<model.Category>(
                                          isExpanded: true,
                                          hint: Text(
                                            'Tìm kiếm danh mục',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color:
                                                  Theme.of(context).hintColor,
                                            ),
                                          ),
                                          items: categoryList
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
                                          value: selectedCategoryValue,
                                          onChanged: (value) {
                                            setState(() {
                                              selectedCategoryValue = value;
                                              print(
                                                  "Unit selected: ${selectedCategoryValue!.category_id}");
                                              if (selectedCategoryValue!
                                                      .category_id !=
                                                  "") {
                                                isErrorTextCategoryId = false;
                                                textCategoryIdController.text =
                                                    selectedCategoryValue!
                                                        .category_id;
                                                textCategoryCodeController
                                                        .text =
                                                    '${selectedCategoryValue!.category_code}';
                                              } else {
                                                isErrorTextCategoryId = true;
                                              }
                                            });
                                          },
                                          buttonStyleData:
                                              const ButtonStyleData(
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
                                          dropdownSearchData:
                                              DropdownSearchData(
                                            searchController:
                                                textSearchCategotyController,
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
                                                    textSearchCategotyController,
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                    horizontal: 10,
                                                    vertical: 8,
                                                  ),
                                                  hintText:
                                                      'Tìm kiếm danh mục...',
                                                  hintStyle: const TextStyle(
                                                      fontSize: 12),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            searchMatchFn: (item, searchValue) {
                                              print(
                                                  "Search Category Value: $searchValue");

                                              return item.value!.name
                                                  .toLowerCase()
                                                  .toString()
                                                  .contains(searchValue
                                                      .toLowerCase());
                                            },
                                          ),
                                          //This to clear the search value when you close the menu
                                          onMenuStateChange: (isOpen) {
                                            if (!isOpen) {
                                              textSearchCategotyController
                                                  .clear();
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
                        Container(
                          margin: const EdgeInsets.only(left: 5),
                          height: 50,
                          child: Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    const Text(
                                      'Đơn vị:       ',
                                      style: textStyleInput,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton2<Unit>(
                                          isExpanded: true,
                                          hint: Text(
                                            'Tìm kiếm đơn vị tính',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color:
                                                  Theme.of(context).hintColor,
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
                                          buttonStyleData:
                                              const ButtonStyleData(
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
                                          dropdownSearchData:
                                              DropdownSearchData(
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
                                                      const EdgeInsets
                                                          .symmetric(
                                                    horizontal: 10,
                                                    vertical: 8,
                                                  ),
                                                  hintText:
                                                      'Tìm kiếm đơn vị...',
                                                  hintStyle: const TextStyle(
                                                      fontSize: 12),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            searchMatchFn: (item, searchValue) {
                                              print(
                                                  "Search Value: $searchValue");

                                              return item.value!.name
                                                  .toLowerCase()
                                                  .toString()
                                                  .contains(searchValue
                                                      .toLowerCase());
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
                        const SizedBox(
                          height: 10,
                        ),
                        ListTile(
                          leading: Theme(
                            data:
                                ThemeData(unselectedWidgetColor: primaryColor),
                            child: Checkbox(
                              value: isCheckVAT,
                              onChanged: (bool? value) {
                                setState(() {
                                  isCheckVAT = value!;
                                });
                              },
                              activeColor: primaryColor,
                            ),
                          ),
                          title: const Text(
                            "Áp dụng VAT",
                            style: textStylePriceBold16,
                          ),
                        ),
                        AnimatedOpacity(
                          opacity:
                              isCheckVAT ? 1.0 : 0.0, // 1.0 là hiện, 0.0 là ẩn
                          duration: const Duration(
                              milliseconds: 500), // Độ dài của animation
                          child: isCheckVAT
                              ? Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  height: 50,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            const Text(
                                              'VAT:          ',
                                              style: textStyleInput,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child:
                                                  DropdownButtonHideUnderline(
                                                child: DropdownButton2<Vat>(
                                                  isExpanded: true,
                                                  hint: Text(
                                                    'Tìm kiếm vat',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Theme.of(context)
                                                          .hintColor,
                                                    ),
                                                  ),
                                                  items: vatList
                                                      .map((item) =>
                                                          DropdownMenuItem(
                                                            value: item,
                                                            child: Text(
                                                              item.name,
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                          ))
                                                      .toList(),
                                                  value: selectedVatValue,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      selectedVatValue = value;
                                                      print(
                                                          "Unit selected: ${selectedVatValue!.vat_id}");
                                                      if (selectedVatValue!
                                                              .vat_id !=
                                                          "") {
                                                        isErrorTextVatId =
                                                            false;
                                                        textVatIdController
                                                                .text =
                                                            selectedVatValue!
                                                                .vat_id;
                                                      } else {
                                                        isErrorTextVatId = true;
                                                      }
                                                    });
                                                  },
                                                  buttonStyleData:
                                                      const ButtonStyleData(
                                                    padding:
                                                        EdgeInsets.symmetric(
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
                                                  dropdownSearchData:
                                                      DropdownSearchData(
                                                    searchController:
                                                        textSearchVatController,
                                                    searchInnerWidgetHeight: 50,
                                                    searchInnerWidget:
                                                        Container(
                                                      height: 50,
                                                      padding:
                                                          const EdgeInsets.only(
                                                        top: 8,
                                                        bottom: 4,
                                                        right: 8,
                                                        left: 8,
                                                      ),
                                                      child: TextFormField(
                                                        expands: true,
                                                        maxLines: null,
                                                        controller:
                                                            textSearchVatController,
                                                        decoration:
                                                            InputDecoration(
                                                          isDense: true,
                                                          contentPadding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            horizontal: 10,
                                                            vertical: 8,
                                                          ),
                                                          hintText:
                                                              'Tìm kiếm vat...',
                                                          hintStyle:
                                                              const TextStyle(
                                                                  fontSize: 12),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    searchMatchFn:
                                                        (item, searchValue) {
                                                      print(
                                                          "Search Value: $searchValue");

                                                      return item.value!.name
                                                          .toLowerCase()
                                                          .toString()
                                                          .contains(searchValue
                                                              .toLowerCase());
                                                    },
                                                  ),
                                                  //This to clear the search value when you close the menu
                                                  onMenuStateChange: (isOpen) {
                                                    if (!isOpen) {
                                                      textSearchVatController
                                                          .clear();
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
                                )
                              : const SizedBox(),
                        ),
                        isCheckVAT
                            ? const SizedBox(
                                height: 10,
                              )
                            : const SizedBox(),
                        ListTile(
                          leading: Theme(
                            data:
                                ThemeData(unselectedWidgetColor: primaryColor),
                            child: Checkbox(
                              value: isCheckTemporaryPrice,
                              onChanged: (bool? value) {
                                setState(() {
                                  isCheckTemporaryPrice = value!;
                                });
                              },
                              activeColor: primaryColor,
                            ),
                          ),
                          title: const Text(
                            "Áp dụng giá thời vụ:",
                            style: textStylePriceBold16,
                          ),
                        ),
                        AnimatedOpacity(
                          opacity: isCheckTemporaryPrice
                              ? 1.0
                              : 0.0, // 1.0 là hiện, 0.0 là ẩn
                          duration: const Duration(
                              milliseconds: 500), // Độ dài của animation
                          child: isCheckTemporaryPrice
                              ? Column(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(left: 10),
                                      height: 50,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(
                                            child: RadioListTile<bool>(
                                              title: const Text('Tăng',
                                                  style: textStyleInput),
                                              value: true,
                                              groupValue: isCheckIncrease,
                                              onChanged: (value) {
                                                setState(() {
                                                  isCheckIncrease =
                                                      value ?? false;
                                                  isCheckDecrease =
                                                      !isCheckIncrease;
                                                });
                                              },
                                            ),
                                          ),
                                          Expanded(
                                            child: RadioListTile<bool>(
                                              title: const Text('Giảm',
                                                  style: textStyleInput),
                                              value: true,
                                              groupValue: isCheckDecrease,
                                              onChanged: (value) {
                                                setState(() {
                                                  isCheckDecrease =
                                                      value ?? false;
                                                  isCheckIncrease =
                                                      !isCheckDecrease;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    ListTile(
                                      leading: Theme(
                                        data: ThemeData(
                                            unselectedWidgetColor:
                                                primaryColor),
                                        child: Checkbox(
                                          value: isCheckTemporaryWithPrice,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              isCheckTemporaryWithPrice =
                                                  value!;
                                              isCheckTemporaryWithPercent =
                                                  !value;

                                              isOnlyReadTemporaryWithPercent =
                                                  true;
                                              isOnlyReadTemporaryWithPrice =
                                                  false;
                                            });
                                          },
                                          activeColor: primaryColor,
                                        ),
                                      ),
                                      title: TextField(
                                          controller:
                                              temporaryWithPriceController,
                                          readOnly:
                                              isOnlyReadTemporaryWithPrice,
                                          style: textStyleInput,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly, // Only allows digits
                                          ],
                                          decoration: InputDecoration(
                                              labelStyle: textStyleInput,
                                              labelText: "Giá tiền thời vụ",
                                              hintText: 'Nhập giá tiền áp dụng',
                                              hintStyle: const TextStyle(
                                                  color: Colors.grey),
                                              border: const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.grey),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(30))),
                                              errorText:
                                                  isErrorTextTemporaryPrice
                                                      ? errorTextTemporaryPrice
                                                      : null,
                                              errorStyle: textStyleErrorInput),
                                          onChanged: (value) => {
                                                if (value.isNotEmpty &&
                                                    value.startsWith('0'))
                                                  {
                                                    temporaryWithPriceController
                                                            .text =
                                                        value.substring(
                                                            1), // Loại bỏ ký tự đầu tiên (số 0)
                                                  },
                                                if (int.tryParse(
                                                        temporaryWithPriceController
                                                            .text)! <=
                                                    int.tryParse(priceController
                                                        .text
                                                        .replaceAll(
                                                            RegExp(r','), ''))!)
                                                  {
                                                    setState(() {
                                                      errorTextTemporaryPrice =
                                                          "";
                                                      isErrorTextTemporaryPrice =
                                                          false;
                                                      temporaryWithPriceController
                                                              .text =
                                                          Utils.convertTextFieldPrice(
                                                              value); // Format price 100,000,000
                                                    })
                                                  }
                                                else
                                                  {
                                                    setState(() {
                                                      errorTextTemporaryPrice =
                                                          "Giá thời vụ không lớn hơn giá gốc.";
                                                      isErrorTextTemporaryPrice =
                                                          true;
                                                      if (int.tryParse(
                                                              temporaryWithPriceController
                                                                  .text)! >
                                                          int.tryParse(
                                                              priceController
                                                                  .text
                                                                  .replaceAll(
                                                                      RegExp(
                                                                          r','),
                                                                      ''))!) {
                                                        temporaryWithPriceController
                                                                .text =
                                                            priceController
                                                                .text;
                                                        errorTextTemporaryPrice =
                                                            "";
                                                        isErrorTextTemporaryPrice =
                                                            false;
                                                      }
                                                    }),
                                                  }
                                              }),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    ListTile(
                                      leading: Theme(
                                        data: ThemeData(
                                            unselectedWidgetColor:
                                                primaryColor),
                                        child: Checkbox(
                                          value: isCheckTemporaryWithPercent,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              isCheckTemporaryWithPercent =
                                                  value!;
                                              isCheckTemporaryWithPrice =
                                                  !value;

                                              isOnlyReadTemporaryWithPrice =
                                                  true;
                                              isOnlyReadTemporaryWithPercent =
                                                  false;
                                            });
                                          },
                                          activeColor: primaryColor,
                                        ),
                                      ),
                                      title: TextField(
                                          controller:
                                              temporaryWithPercentController,
                                          readOnly:
                                              isOnlyReadTemporaryWithPercent,
                                          style: textStyleInput,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly, // Only allows digits
                                          ],
                                          decoration: InputDecoration(
                                              labelStyle: textStyleInput,
                                              labelText:
                                                  "Phần trăm (%) thời vụ",
                                              hintText: 'Nhập % áp dụng',
                                              hintStyle: const TextStyle(
                                                  color: Colors.grey),
                                              border: const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.grey),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(30))),
                                              errorText:
                                                  isErrorTextTemporaryPercent
                                                      ? errorTextTemporaryPercent
                                                      : null,
                                              errorStyle: textStyleErrorInput),
                                          onChanged: (value) => {
                                                if (value.isEmpty)
                                                  {
                                                    temporaryWithPriceController
                                                        .text = "0",
                                                  },
                                                if (value.isNotEmpty &&
                                                    value.startsWith('0'))
                                                  {
                                                    temporaryWithPercentController
                                                            .text =
                                                        value.substring(
                                                            1), // Loại bỏ ký tự đầu tiên (số 0)
                                                  },
                                                if (int.tryParse(
                                                            temporaryWithPercentController
                                                                .text)! >
                                                        0 &&
                                                    int.tryParse(
                                                            temporaryWithPercentController
                                                                .text)! <=
                                                        100)
                                                  {
                                                    setState(() {
                                                      errorTextTemporaryPercent =
                                                          "";
                                                      isErrorTextTemporaryPercent =
                                                          false;
                                                      temporaryWithPercentController
                                                          .text = value;

                                                      //phần trăm thời vụ thay đổi thì price with temporary thay đổi theo để gợi ý số tiền giảm
                                                      temporaryWithPriceController
                                                          .text = Utils.formatCurrency((double
                                                              .tryParse(priceController
                                                                  .text
                                                                  .replaceAll(
                                                                      RegExp(
                                                                          r','),
                                                                      ''))! *
                                                          (int.tryParse(
                                                                  value)! /
                                                              100)));
                                                    })
                                                  }
                                                else
                                                  {
                                                    setState(() {
                                                      errorTextTemporaryPercent =
                                                          "Phần trăm (%) phải lơn 1";
                                                      isErrorTextTemporaryPercent =
                                                          true;
                                                      if (int.tryParse(
                                                              temporaryWithPercentController
                                                                  .text)! >=
                                                          100) {
                                                        temporaryWithPercentController
                                                            .text = "100";
                                                        errorTextTemporaryPercent =
                                                            "";
                                                        isErrorTextTemporaryPercent =
                                                            false;
                                                      }
                                                    }),
                                                  }
                                              }),
                                    ),
                                    TextField(
                                      controller:
                                          temporaryPriceFromDateController,
                                      style: textStyleInput,
                                      readOnly: true,
                                      onTap: () {
                                        _selectTemporaryFromDate(context);
                                      },
                                      keyboardType: TextInputType.datetime,
                                      decoration: InputDecoration(
                                          labelStyle: textStyleInput,
                                          labelText: "Thời gian bắt đầu:",
                                          hintText: 'Chọn thời gian bắt đầu',
                                          hintStyle: const TextStyle(
                                              color: Colors.grey),
                                          suffixIcon:
                                              const Icon(Icons.calendar_today),
                                          border: InputBorder.none,
                                          errorText:
                                              isErrorTextTemporaryPriceFromDate
                                                  ? errorTextTemporaryPriceFromDate
                                                  : null,
                                          errorStyle: textStyleErrorInput),
                                    ),
                                    TextField(
                                      controller:
                                          temporaryPriceToDateController,
                                      style: textStyleInput,
                                      readOnly: true,
                                      onTap: () {
                                        _selectTemporaryToDate(context);
                                      },
                                      keyboardType: TextInputType.datetime,
                                      decoration: InputDecoration(
                                          labelStyle: textStyleInput,
                                          labelText: "Thời gian kết thúc:",
                                          hintText: 'Chọn thời gian kết thúc',
                                          hintStyle: const TextStyle(
                                              color: Colors.grey),
                                          suffixIcon:
                                              const Icon(Icons.calendar_today),
                                          border: InputBorder.none,
                                          errorText:
                                              isErrorTextTemporaryPriceToDate
                                                  ? errorTextTemporaryPriceToDate
                                                  : null,
                                          errorStyle: textStyleErrorInput),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                        ),
                        isCheckTemporaryPrice && isCheckVAT
                            ? SizedBox(
                                height: MediaQuery.of(context).size.height *
                                    0.00005,
                              )
                            : const SizedBox(),
                        !isCheckTemporaryPrice && !isCheckVAT
                            ? SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.12,
                              )
                            : const SizedBox(),
                        isCheckVAT
                            ? SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.12,
                              )
                            : const SizedBox(),
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
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
                                    priceController.text =
                                        Utils.formatCurrencytoDouble(
                                            priceController.text),
                                    temporaryWithPriceController.text =
                                        Utils.formatCurrencytoDouble(
                                            temporaryWithPriceController.text),
                                    if (!Utils.isValidLengthTextEditController(
                                        nameController,
                                        minlength2,
                                        maxlength255))
                                      {
                                        Utils.showStylishDialog(
                                            context,
                                            'THÔNG BÁO',
                                            'Tên món phải từ $minlength2 đến $maxlength255 ký tự.',
                                            StylishDialogType.ERROR)
                                      }
                                    else if (textCategoryIdController.text ==
                                        "")
                                      {
                                        Utils.showStylishDialog(
                                            context,
                                            'THÔNG BÁO',
                                            'Vui lòng chọn loại danh mục.',
                                            StylishDialogType.ERROR)
                                      }
                                    else if (textUnitIdController.text == "")
                                      {
                                        Utils.showStylishDialog(
                                            context,
                                            'THÔNG BÁO',
                                            'Vui lòng chọn loại đơn vị.',
                                            StylishDialogType.ERROR)
                                      }
                                    else if (textCategoryIdController.text !=
                                            "" &&
                                        textUnitIdController.text != "")
                                      {
                                        if (isCheckTemporaryPrice)
                                          {
                                            if (isCheckDecrease)
                                              {
                                                temporaryWithPriceController
                                                        .text =
                                                    "-${temporaryWithPriceController.text}"
                                              },
                                            if (isFromDateTimeSelected &&
                                                isToDateTimeSelected &&
                                                temporaryWithPriceController
                                                        .text !=
                                                    "")
                                              {
                                                print(
                                                    "create with temporary price"),
                                                foodController.createFood(
                                                    nameController.text,
                                                    _pickedImage.value,
                                                    priceController.text,
                                                    temporaryWithPriceController
                                                        .text,
                                                    pickedFromDateTime, //thời gian bắt đầu giá thời vụ
                                                    pickedToDateTime, //thời gian kết thúc giá thời vụ

                                                    textCategoryIdController
                                                        .text,
                                                    textUnitIdController.text,
                                                    textVatIdController.text,
                                                    int.tryParse(
                                                            temporaryWithPercentController
                                                                .text) ??
                                                        0,
                                                    int.tryParse(
                                                            textCategoryCodeController
                                                                .text) ??
                                                        CATEGORY_FOOD),
                                                Utils.myPopSuccess(context)
                                              }
                                            else if (isFromDateTimeSelected &&
                                                isToDateTimeSelected &&
                                                temporaryWithPercentController
                                                        .text !=
                                                    "")
                                              {
                                                //NẾU % giá thời vụ được áp dụng thì chuyển % thành tiền
                                                if (isCheckTemporaryWithPercent)
                                                  {
                                                    if (isCheckDecrease)
                                                      {
                                                        temporaryWithPriceController
                                                            .text = ((-1) *
                                                                (int.tryParse(
                                                                        priceController
                                                                            .text)! *
                                                                    (int.tryParse(
                                                                            temporaryWithPercentController.text)! /
                                                                        100)))
                                                            .toString(),
                                                        print(
                                                            "thời vụ % áp dụng: ${(int.tryParse(priceController.text)! * (int.tryParse(temporaryWithPercentController.text)! / 100)).toString()}")
                                                      }
                                                    else
                                                      {
                                                        temporaryWithPriceController
                                                            .text = (int.tryParse(
                                                                    priceController
                                                                        .text)! *
                                                                (10 / 100))
                                                            .toString(),
                                                        print(
                                                            "thời vụ % áp dụng: ${(int.tryParse(priceController.text)! * (int.tryParse(temporaryWithPercentController.text)! / 100)).toString()}")
                                                      },
                                                  },

                                                print(
                                                    "create with temporary percent"),

                                                foodController.createFood(
                                                    nameController.text,
                                                    _pickedImage.value,
                                                    priceController.text,
                                                    temporaryWithPriceController
                                                        .text,
                                                    pickedFromDateTime, //thời gian bắt đầu giá thời vụ
                                                    pickedToDateTime, //thời gian kết thúc giá thời vụ

                                                    textCategoryIdController
                                                        .text,
                                                    textUnitIdController.text,
                                                    textVatIdController.text,
                                                    int.tryParse(
                                                            temporaryWithPercentController
                                                                .text) ??
                                                        0,
                                                    int.tryParse(
                                                            textCategoryCodeController
                                                                .text) ??
                                                        CATEGORY_FOOD),
                                                Utils.myPopSuccess(context)
                                              }
                                          }
                                        else
                                          {
                                            if (isCheckVAT)
                                              {
                                                foodController.createFood(
                                                    nameController.text,
                                                    _pickedImage.value,
                                                    priceController.text,
                                                    "",
                                                    null, //thời gian bắt đầu giá thời vụ
                                                    null, //thời gian kết thúc giá thời vụ

                                                    textCategoryIdController
                                                        .text,
                                                    textUnitIdController.text,
                                                    textVatIdController.text,
                                                    int.tryParse(
                                                            temporaryWithPercentController
                                                                .text) ??
                                                        0,
                                                    int.tryParse(
                                                            textCategoryCodeController
                                                                .text) ??
                                                        CATEGORY_FOOD),
                                                Utils.myPopSuccess(context)
                                              }
                                            else
                                              {
                                                print("create"),
                                                foodController.createFood(
                                                    nameController.text,
                                                    _pickedImage.value,
                                                    priceController.text,
                                                    "",
                                                    null, //thời gian bắt đầu giá thời vụ
                                                    null, //thời gian kết thúc giá thời vụ

                                                    textCategoryIdController
                                                        .text,
                                                    textUnitIdController.text,
                                                    "",
                                                    int.tryParse(
                                                            temporaryWithPercentController
                                                                .text) ??
                                                        0,
                                                    int.tryParse(
                                                            textCategoryCodeController
                                                                .text) ??
                                                        CATEGORY_FOOD),
                                                Utils.myPopSuccess(context)
                                              }
                                          },
                                      }
                                    else
                                      {
                                        print("Chưa nhập đủ trường"),
                                        Utils.showStylishDialog(
                                            context,
                                            'THÔNG BÁO',
                                            'Vui lòng nhập đầy đủ các trường!',
                                            StylishDialogType.ERROR)
                                      }
                                  },
                                  child: Container(
                                    height: 50,
                                    decoration: const BoxDecoration(
                                        color: primaryColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                    child: const Align(
                                      alignment: Alignment.center,
                                      child: Text("THÊM MỚI",
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
                ),
              ],
            )),
      ),
    );
  }
}
