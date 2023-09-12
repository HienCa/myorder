// ignore_for_file: avoid_single_cascade_in_expression_statements, avoid_print, non_constant_identifier_names

// import 'package:awesome_dialog/awesome_dialog.dart';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/Foods/Foods_controller.dart';
import 'package:myorder/controllers/categories/categories_controller.dart';
import 'package:myorder/controllers/units/units_controller.dart';
import 'package:myorder/controllers/vats/vats_controller.dart';
import 'package:myorder/models/Unit.dart';
import 'package:myorder/models/Food.dart';
import 'package:myorder/models/category.dart' as model;
import 'package:myorder/models/vat.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class FoodDetailPage extends StatefulWidget {
  final String foodId;
  final String? food_id;
  final String name;
  final String? image;
  final double price;
  final double? price_with_temporary;
  final DateTime? temporary_price_from_date;
  final DateTime? temporary_price_to_date;
  final double? temporary_price;
  final double? temporary_percent;
  final int active;
  final String vat_id;
  final String category_id;
  final String unit_id;

  const FoodDetailPage({
    super.key,
    required this.foodId,
    this.food_id,
    required this.name,
    required this.price,
    this.image,
    this.price_with_temporary,
    this.temporary_price_from_date,
    this.temporary_price_to_date,
    this.temporary_price,
    this.temporary_percent,
    required this.active,
    required this.vat_id,
    required this.category_id,
    required this.unit_id,
  });
  @override
  State<FoodDetailPage> createState() => _FoodDetailPageState();
}

class _FoodDetailPageState extends State<FoodDetailPage> {
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

  FoodController foodController = Get.put(FoodController());
  late Food food;

  Future<void> loadFood() async {
    final Food result = await foodController.getFoodById(widget.foodId);
    if (result.food_id != "") {
      setState(() {
        food = result;
        nameController.text = food.name;
        priceController.text = "${food.price}";
        temporaryWithPriceController.text = "${food.price_with_temporary}";
        temporaryPriceFromDateController.text =
            "${food.temporary_price_from_date}";
        temporaryPriceToDateController.text = "${food.temporary_price_to_date}";
        temporaryPriceController.text = "${food.temporary_price}";
        temporaryPercentController.text = "${food.temporary_percent}";
        if (food.price_with_temporary != 0.0) {
          isMaleSelected = true;
          isFemaleSelected = false;
        } else {
          isMaleSelected = false;
          isFemaleSelected = true;
        }
      });
    }
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController temporaryWithPriceController =
      TextEditingController();
  final TextEditingController temporaryPriceFromDateController =
      TextEditingController();
  final TextEditingController temporaryPriceToDateController =
      TextEditingController();
  final TextEditingController temporaryPriceController =
      TextEditingController();
  final TextEditingController temporaryPercentController =
      TextEditingController();
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

  Future<void> _selectTemporaryFromDate(BuildContext context) async {
    final DateTime currentDate = DateTime.now();
    final DateTime minDate =
        DateTime(currentDate.year - 16, currentDate.month, currentDate.day);

    final DateTime picked = (await showDatePicker(
          context: context,
          initialDate: _selectedtemporaryPriceFromDate ?? minDate,
          firstDate: DateTime(1900), // Bất kỳ năm nào trước năm 2007
          lastDate: minDate, // Không cho phép chọn sau ngày hiện tại - 16 năm
        )) ??
        minDate;

    if (picked != _selectedtemporaryPriceFromDate) {
      setState(() {
        _selectedtemporaryPriceFromDate = picked;
        temporaryPriceFromDateController.text =
            "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";

        temporaryPriceFromDate =
            "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  Future<void> _selectTemporaryToDate(BuildContext context) async {
    final DateTime currentDate = DateTime.now();
    final DateTime minDate =
        DateTime(currentDate.year - 16, currentDate.month, currentDate.day);

    final DateTime picked = (await showDatePicker(
          context: context,
          initialDate: _selectedtemporaryPriceToDate ?? minDate,
          firstDate: DateTime(1900), // Bất kỳ năm nào trước năm 2007
          lastDate: minDate, // Không cho phép chọn sau ngày hiện tại - 16 năm
        )) ??
        minDate;

    if (picked != _selectedtemporaryPriceToDate) {
      setState(() {
        _selectedtemporaryPriceToDate = picked;
        temporaryPriceToDateController.text =
            "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";

        temporaryPriceToDate =
            "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
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
    loadFood();
    double price_init = 0.0;
    food = Food(
        food_id: '',
        name: '',
        active: 1,
        price: price_init,
        vat_id: '',
        category_id: '',
        unit_id: '');

    getCategories().then((categories) {
      setState(() {
        categoryOptions = categories;
        selectedCategoryValue = categoryList.firstWhere(
          (ctegory) => ctegory.category_id == widget.category_id,
          orElse: () => model.Category(category_id: "", name: "", active: 1),
        );
      });
    });
    getUnits().then((units) {
      setState(() {
        unitOptions = units;
        selectedUnitValue = unitList.firstWhere(
          (unit) => unit.unit_id == widget.unit_id,
          orElse: () => Unit(unit_id: "", name: "", active: 1),
        );
      });
    });
    getVats().then((vats) {
      setState(() {
        vatOptions = vats;
        selectedVatValue = vatList.firstWhere(
          (vat) => vat.vat_id == widget.vat_id,
          orElse: () => Vat(vat_id: "", name: "", active: 1, vat_percent: 0),
        );
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
  model.Category categoryFirstOption =
      model.Category(category_id: "", name: "titleCategory", active: 1);
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
    if (food.food_id == "") {
      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          leading: InkWell(
              onTap: () => {Navigator.pop(context)},
              child: const Icon(Icons.arrow_back_ios)),
          title: const Center(child: Text("CẬP NHẬT MÓN")),
          backgroundColor: primaryColor,
        ),
        body: const Center(
          child: CircularProgressIndicator(), // Display a loading indicator.
        ),
      );
    }
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        leading: InkWell(
            onTap: () => {Navigator.pop(context)},
            child: const Icon(Icons.arrow_back_ios)),
        title: const Center(child: Text("CẬP NHẬT MÓN")),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
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
                                    child: food.image != ""
                                        ? CircleAvatar(
                                            radius: 55,
                                            backgroundColor: primaryColor,
                                            child: CircleAvatar(
                                              radius: 50,
                                              backgroundColor:
                                                  Colors.transparent,
                                              backgroundImage:
                                                  NetworkImage(food.image!),
                                            ),
                                          )
                                        : CircleAvatar(
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
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                          controller: nameController,
                          style: textStyleInput,
                          decoration: InputDecoration(
                              labelStyle: textStyleInput,
                              labelText: "Tên món ăn",
                              hintText: 'Nhập tên món ăn',
                              hintStyle: const TextStyle(color: Colors.grey),
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)),
                              errorText: isErrorTextName ? errorTextName : null,
                              errorStyle: textStyleErrorInput),
                          maxLength: 50,
                          // autofocus: true,
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
                                    'Khu vực:',
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
                                          'Tìm kiếm khu vực',
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
                                            print("Unit selected: " +
                                                selectedUnitValue!.unit_id);
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
                      const SizedBox(
                        height: 30,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        height: 30,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Ngày sinh:',
                              style: textStyleInput,
                            ),
                            const Text(
                              '     ',
                              style: textStyleInput,
                            ),
                            Expanded(
                              child: TextField(
                                controller: temporaryPriceFromDateController,
                                readOnly: true,
                                onTap: () {
                                  _selectTemporaryFromDate(context);
                                },
                                keyboardType: TextInputType.datetime,
                                style: textStyleInput,
                                decoration: const InputDecoration(
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                    suffixIcon: Icon(Icons.calendar_today),
                                    suffixStyle: textStyleInput),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
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
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  child: const Align(
                                    alignment: Alignment.center,
                                    child:
                                        Text("HỦY", style: buttonStyleCancel),
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
                                  if (!isErrorTextName &&
                                      !isErrorTextPrice &&
                                      !isErrorTextTemporaryPriceFromDate &&
                                      !isErrorTextTemporaryPriceToDate &&
                                      !isErrorTextTemporaryPercent &&
                                      !isErrorTextTemporaryPrice)
                                    {
                                      // foodController.updateFood(food.food_id, nameController.text, food.image ?? "", _pickedImage.value, priceController.text, textVatIdController.text, temporaryWithPriceController.text, temporaryPriceFromDateController.text, temporaryPriceToDateController.text, temporaryPriceController.text, temporaryPercentController.text, food.active, textCategoryIdController.text, textUnitIdController.text),
                                      foodController.updateFood(
                                          food.food_id,
                                          nameController.text,
                                          food.image ?? "",
                                          _pickedImage.value,
                                          priceController.text,
                                          temporaryWithPriceController.text,
                                          temporaryPriceFromDateController.text,
                                          temporaryPriceToDateController.text,
                                          temporaryPriceController.text,
                                          temporaryPercentController.text,
                                          textCategoryIdController.text,
                                          textUnitIdController.text,
                                          textVatIdController.text),
                                      Navigator.pop(context)
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
                                      Future.delayed(const Duration(seconds: 2),
                                          () {
                                        Navigator.pop(context);
                                      })
                                    }
                                },
                                child: Container(
                                  height: 50,
                                  decoration: const BoxDecoration(
                                      color: primaryColor,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  child: const Align(
                                    alignment: Alignment.center,
                                    child: Text("CẬP NHẬT",
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
    );
  }
}
