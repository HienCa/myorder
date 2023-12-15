// ignore_for_file: avoid_single_cascade_in_expression_statements, avoid_print

// import 'package:awesome_dialog/awesome_dialog.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/employees/employees_controller.dart';
import 'package:myorder/models/employee.dart';
import 'package:myorder/models/role.dart';
import 'package:myorder/utils.dart';
import 'package:myorder/views/widgets/dialogs/dialog_select.dart';
import 'package:myorder/views/widgets/textfields/text_field_label/text_field_email.dart';
import 'package:myorder/views/widgets/textfields/text_field_label/text_field_number_length.dart';
import 'package:myorder/views/widgets/textfields/text_field_label/text_field_phone.dart';
import 'package:myorder/views/widgets/textfields/text_field_label/text_field_string.dart';
import 'package:myorder/views/widgets/textfields/text_field_label/text_field_string_select.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

class StaffDetailPage extends StatefulWidget {
  final Employee employee;
  const StaffDetailPage({
    Key? key,
    required this.employee,
  }) : super(key: key);

  @override
  State<StaffDetailPage> createState() => _StaffDetailPageState();
}

class _StaffDetailPageState extends State<StaffDetailPage> {
  var isActive = true;
  String? selectedImagePath;
  final Rx<File?> _pickedImage = Rx<File?>(null);

  bool isMaleSelected = true;
  bool isFemaleSelected = false;

  EmployeeController employeeController = Get.put(EmployeeController());

  @override
  void initState() {
    super.initState();
    String roleString = widget.employee.role == ROLE_CUSTOMER
        ? ROLE_CUSTOMER_STRING
        : widget.employee.role == ROLE_STAFF
            ? ROLE_STAFF_STRING
            : widget.employee.role == ROLE_MANAGER
                ? ROLE_MANAGER_STRING
                : widget.employee.role == ROLE_CASHIER
                    ? ROLE_CASHIER_STRING
                    : widget.employee.role == ROLE_OWNER
                        ? ROLE_OWNER_STRING
                        : ROLE_STAFF_STRING;
    roleController.text = roleString;
    roleIdController.text = widget.employee.role.toString();
    nameController.text = widget.employee.name;
    cccdController.text = widget.employee.cccd;
    birthdayController.text = widget.employee.birthday;
    phoneController.text = widget.employee.phone;
    addressController.text = widget.employee.address;
    genderController.text = widget.employee.gender;
    emailController.text = widget.employee.email;

    if (widget.employee.gender == MALE) {
      isMaleSelected = true;
      isFemaleSelected = false;
    } else {
      isMaleSelected = false;
      isFemaleSelected = true;
    }
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController roleIdController = TextEditingController();
  final TextEditingController cccdController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  String birthday = "";
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
    final DateTime minDate =
        DateTime(currentDate.year - 16, currentDate.month, currentDate.day);

    final DateTime picked = (await showDatePicker(
          context: context,
          initialDate: _selectedDate ?? minDate,
          firstDate: DateTime(1900), // Bất kỳ năm nào trước năm 2007
          lastDate: minDate, // Không cho phép chọn sau ngày hiện tại - 16 năm
        )) ??
        minDate;

    if (picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        birthdayController.text =
            "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";

        birthday =
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
          "THÔNG TIN NHÂN VIÊN",
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
                                    child: widget.employee.avatar != ""
                                        ? CircleAvatar(
                                            radius: 55,
                                            backgroundColor: primaryColor,
                                            child: CircleAvatar(
                                              radius: 50,
                                              backgroundColor:
                                                  Colors.transparent,
                                              backgroundImage: NetworkImage(
                                                  widget.employee.avatar!),
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
                      MyTextFieldString(
                        textController: nameController,
                        label: 'Họ tên',
                        placeholder: 'Nhập họ tên nhân viên',
                        isReadOnly: false,
                        min: minlength2,
                        max: maxlength255,
                        isRequire: true,
                      ),
                      marginTop10,
                      InkWell(
                          onTap: () async {
                            Role result = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return MyDialogSelect(
                                    lable: "DANH SÁCH CHỨC VỤ",
                                    list: LIST_ROLE_OPTION,
                                    keyNameSearch: "name");
                              },
                            );

                            if (result.role_id >= 0) {
                              setState(() {
                                roleController.text = result.name;
                                roleIdController.text =
                                    result.role_id.toString();
                              });
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: MyTextFieldStringOnTap(
                                textController: roleController,
                                label: "Chức vụ",
                                placeholder: "",
                                isRequire: true),
                          )),
                      marginTop20,
                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        height: 30,
                        child: Row(
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  const Row(
                                    children: [
                                      Text(
                                        'Giới tính',
                                        style: textStyleLabel16,
                                      ),
                                      marginRight10,
                                      Text(
                                        '(*)',
                                        style: textStyleErrorInput,
                                      )
                                    ],
                                  ),
                                  marginRight10,
                                  Theme(
                                    data: ThemeData(
                                        unselectedWidgetColor: primaryColor),
                                    child: Checkbox(
                                      value: isMaleSelected,
                                      onChanged: (value) {
                                        setState(() {
                                          isMaleSelected = value ?? false;
                                          isFemaleSelected = !isMaleSelected;
                                          genderController.text = MALE;
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
                                    data: ThemeData(
                                        unselectedWidgetColor: primaryColor),
                                    child: Checkbox(
                                      value: isFemaleSelected,
                                      onChanged: (value) {
                                        setState(() {
                                          isFemaleSelected = value ?? false;
                                          isMaleSelected = !isFemaleSelected;
                                          genderController.text = FEMALE;
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
                      marginTop20,
                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        height: 30,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Row(
                              children: [
                                Text(
                                  'Ngày sinh',
                                  style: textStyleLabel16,
                                ),
                                marginRight10,
                                Text(
                                  '(*)',
                                  style: textStyleErrorInput,
                                )
                              ],
                            ),
                            marginRight10,
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
                                    suffixIcon: Icon(Icons.calendar_today),
                                    suffixStyle: textStyleInput),
                              ),
                            ),
                          ],
                        ),
                      ),
                      marginTop20,
                      MyTextFieldNumberLength(
                          textController: cccdController,
                          label: 'Mã định danh',
                          placeholder: 'Nhập mã định danh',
                          isRequire: true,
                          min: maxlengthCCCD,
                          max: maxlengthCCCD),
                      MyTextFieldPhone(
                          textController: phoneController,
                          label: 'Số điện thoại',
                          placeholder: 'Nhập số điện thoại',
                          isRequire: true),
                      MyTextFieldEmail(
                          textController: emailController,
                          label: 'Email',
                          placeholder: 'Nhập Email',
                          isRequire: true),
                      MyTextFieldString(
                        textController: addressController,
                        label: 'Địa chỉ',
                        placeholder: 'Nhập địa chỉ',
                        isReadOnly: false,
                        min: minlengthAddress,
                        max: maxlengthAddress,
                        isRequire: true,
                      ),
                      marginTop20,
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
                            marginRight10,
                            Expanded(
                              child: InkWell(
                                onTap: () => {
                                  if (!Utils.isValidLengthTextEditController(
                                      nameController, minlength2, maxlength255))
                                    {
                                      Utils.showStylishDialog(
                                          context,
                                          'THÔNG BÁO',
                                          'Họ tên nhân viên phải từ $minlength2 đến $maxlength255 ký tự.',
                                          StylishDialogType.ERROR)
                                    }
                                  else if (roleController.text.trim() == '')
                                    {
                                      Utils.showStylishDialog(
                                          context,
                                          'THÔNG BÁO',
                                          'Vui lòng chọn chức vụ!',
                                          StylishDialogType.ERROR)
                                    }
                                  else if (birthdayController.text.trim() ==
                                      'dd/MM/yyyy')
                                    {
                                      Utils.showStylishDialog(
                                          context,
                                          'THÔNG BÁO',
                                          'Vui lòng chọn ngày sinh!',
                                          StylishDialogType.ERROR)
                                    }
                                  else if (!Utils
                                      .isValidLengthTextEditController(
                                          cccdController,
                                          minlength2,
                                          maxlength255))
                                    {
                                      Utils.showStylishDialog(
                                          context,
                                          'THÔNG BÁO',
                                          'Mã định danh phải đủ $maxlengthCCCD số',
                                          StylishDialogType.ERROR)
                                    }
                                  else if (!Utils.startsWithZero(
                                          phoneController.text) &&
                                      (phoneController.text.trim().length <
                                              minlengthPhone ||
                                          phoneController.text.trim().length >
                                              maxlengthPhone))
                                    {
                                      Utils.showStylishDialog(
                                          context,
                                          'THÔNG BÁO',
                                          'Số điện thoại chưa hợp lệ',
                                          StylishDialogType.ERROR)
                                    }
                                  else if (!Utils.isValidEmail(
                                      emailController.text))
                                    {
                                      Utils.showStylishDialog(
                                          context,
                                          'THÔNG BÁO',
                                          'Email chưa hợp lệ',
                                          StylishDialogType.ERROR)
                                    }
                                  else if (!Utils
                                      .isValidLengthTextEditController(
                                          addressController,
                                          minlengthAddress,
                                          maxlengthAddress))
                                    {
                                      Utils.showStylishDialog(
                                          context,
                                          'THÔNG BÁO',
                                          'Địa chỉ phải từ $minlengthAddress đến $maxlengthAddress ký tự.',
                                          StylishDialogType.ERROR)
                                    }
                                  else
                                    {
                                      employeeController.updateEmployee(
                                          widget.employee.employee_id,
                                          nameController.text,
                                          widget.employee.avatar,
                                          _pickedImage.value,
                                          cccdController.text,
                                          genderController.text,
                                          birthdayController.text,
                                          phoneController.text,
                                          emailController.text,
                                          "00000000",
                                          addressController.text,
                                          (int.parse(roleIdController.text)), widget.employee),
                                      Utils.myPopSuccess(context)
                                    }
                                },
                                child: Container(
                                  height: 50,
                                  decoration: const BoxDecoration(
                                    color: primaryColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                  ),
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
