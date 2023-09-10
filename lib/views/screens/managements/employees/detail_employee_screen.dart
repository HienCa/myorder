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
import 'package:myorder/utils.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class EmployeeDetailPage extends StatefulWidget {
  final String employeeId;
  const EmployeeDetailPage({
    Key? key,
    required this.employeeId,
  }) : super(key: key);

  @override
  State<EmployeeDetailPage> createState() => _EmployeeDetailPageState();
}

class _EmployeeDetailPageState extends State<EmployeeDetailPage> {
  var isActive = true;
  String? selectedImagePath;
  final Rx<File?> _pickedImage = Rx<File?>(null);
  final List<String> roleOptions = ROLE_OPTION;
  String? errorTextName = "";
  String? errorTextRole = "";
  String? errorTextCCCD = "";
  String? errorTextPhone = "";
  String? errorTextEmail = "";
  String? errorTextAddress = "";

  bool isErrorTextName = false;
  bool isErrorTextRole = false;
  bool isErrorTextCCCD = false;
  bool isErrorTextPhone = false;
  bool isErrorTextEmail = false;
  bool isErrorTextAddress = false;

  bool isMaleSelected = true;
  bool isFemaleSelected = false;

  EmployeeController employeeController = Get.put(EmployeeController());
  late Employee employee;
  @override
  void initState() {
    super.initState();
    employee = Employee(
        employee_id: '',
        name: '',
        cccd: '',
        gender: '',
        birthday: '',
        phone: '',
        email: '',
        password: '',
        address: '',
        role: '',
        active: 1);
  }

  Future<void> loadEmployee() async {
    final Employee result =
        await employeeController.getEmployeeById(widget.employeeId);
    if (result.employee_id != "") {
      setState(() {
        employee = result;
        nameController.text = employee.name;
        cccdController.text = employee.cccd;
        phoneController.text = employee.phone;
        emailController.text = employee.email;
        birthdayController.text = employee.birthday;
        genderController.text = employee.gender;
        addressController.text = employee.address;
        roleController.text = employee.role;
        if (employee.gender == MALE) {
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
  final TextEditingController roleController = TextEditingController();
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
    if (employee.employee_id == "") {
      loadEmployee();

      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          leading: InkWell(
              onTap: () => {Navigator.pop(context)},
              child: const Icon(Icons.arrow_back_ios)),
          title: const Center(child: Text("CẬP NHẬT NHÂN VIÊN")),
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
        title: const Center(child: Text("CẬP NHẬT NHÂN VIÊN")),
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
                                    child: employee.avatar != ""
                                        ? CircleAvatar(
                                            radius: 55,
                                            backgroundColor: primaryColor,
                                            child: CircleAvatar(
                                              radius: 50,
                                              backgroundColor:
                                                  Colors.transparent,
                                              backgroundImage: NetworkImage(
                                                  employee.avatar!),
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
                              labelText: "Họ tên",
                              hintText: 'Nhập tên nhân viên',
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
                                    'Chức vụ:',
                                    style: textStyleInput,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                      child: DropdownMenu<String>(
                                    controller: roleController,
                                    initialSelection: roleOptions.firstWhere(
                                        (element) => element == employee.role),
                                    onSelected: (String? value) {
                                      // This is called when the user selects an item.
                                      setState(() {
                                        if (value != null) {
                                          if (value != "titleRole") {
                                            setState(() {
                                              roleController.text = value;
                                              print(roleController.text);
                                              isErrorTextRole = false;
                                            });
                                          }
                                        }
                                      });
                                    },
                                    dropdownMenuEntries: [
                                      const DropdownMenuEntry<String>(
                                        value: "titleRole",
                                        label: "Chọn chức vụ",
                                      ),
                                      ...roleOptions
                                          .map<DropdownMenuEntry<String>>(
                                              (String value) {
                                        return DropdownMenuEntry<String>(
                                          value: value,
                                          label: value,
                                        );
                                      }).toList(),
                                    ],
                                    textStyle: textStyleInput,
                                  )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextField(
                          controller: cccdController,
                          keyboardType: TextInputType.number,
                          maxLength: maxlengthCCCD,
                          style: textStyleInput,
                          decoration: InputDecoration(
                            labelStyle: textStyleInput,
                            labelText: "Mã định danh",
                            hintText: 'Nhập CCCD',
                            hintStyle: const TextStyle(color: Colors.grey),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            errorText: isErrorTextCCCD ? errorTextCCCD : null,
                            errorStyle: textStyleErrorInput,
                          ),
                          onChanged: (value) => {
                                if (value.trim().length > maxlengthCCCD ||
                                    value.trim().length <= minlengthCCCD)
                                  {
                                    setState(() {
                                      errorTextCCCD =
                                          "Từ $minlengthCCCD đến $maxlengthCCCD ký tự.";
                                      isErrorTextCCCD = true;
                                      print(isErrorTextCCCD);
                                    })
                                  }
                                else
                                  {
                                    setState(() {
                                      errorTextCCCD = "";
                                      isErrorTextCCCD = false;
                                      print(isErrorTextCCCD);
                                    })
                                  }
                              }),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        height: 30,
                        child: Row(
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  const Text(
                                    'Giới tính:',
                                    style: textStyleInput,
                                  ),
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
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                          controller: phoneController,
                          style: textStyleInput,
                          keyboardType: TextInputType.phone,
                          maxLength: maxlengthPhone,
                          decoration: InputDecoration(
                            labelStyle: textStyleInput,
                            labelText: "Số điện thoại",
                            hintText: 'Nhập số điện thoại',
                            hintStyle: const TextStyle(color: Colors.grey),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            errorText: isErrorTextPhone ? errorTextPhone : null,
                            errorStyle: textStyleErrorInput,
                          ),
                          onChanged: (value) => {
                                if (value.trim().length > maxlengthPhone ||
                                    value.trim().length < minlengthPhone)
                                  {
                                    setState(() {
                                      errorTextPhone =
                                          "Từ $minlengthPhone đến $maxlengthPhone ký tự.";
                                      isErrorTextPhone = true;

                                      if (!value.startsWith('0', 0)) {
                                        errorTextPhone =
                                            "Số điện thoại không hợp lệ";
                                        isErrorTextPhone = true;
                                      }
                                    }),
                                  }
                                else
                                  {
                                    setState(() {
                                      errorTextPhone = "";
                                      isErrorTextPhone = false;
                                      if (!value.startsWith('0', 0)) {
                                        errorTextPhone =
                                            "Số điện thoại không hợp lệ";
                                        isErrorTextPhone = true;
                                      }
                                    })
                                  }
                              }),
                      TextField(
                          controller: emailController,
                          style: textStyleInput,
                          decoration: InputDecoration(
                            labelStyle: textStyleInput,
                            labelText: "Email",
                            hintText: 'Nhập email',
                            hintStyle: const TextStyle(color: Colors.grey),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            errorText: isErrorTextEmail ? errorTextEmail : null,
                            errorStyle: textStyleErrorInput,
                          ),
                          onChanged: (value) => {
                                if (!Utils.isValidEmail(value))
                                  {
                                    setState(() {
                                      errorTextEmail = "Email không hợp lệ!";
                                      isErrorTextEmail = true;
                                    })
                                  }
                                else
                                  {
                                    setState(() {
                                      errorTextEmail = "";
                                      isErrorTextEmail = false;
                                    })
                                  }
                              }),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                          controller: addressController,
                          style: textStyleInput,
                          keyboardType: TextInputType.streetAddress,
                          maxLength: maxlengthAddress,
                          decoration: InputDecoration(
                            labelStyle: textStyleInput,
                            labelText: "Địa chỉ",
                            hintText: 'Nhập địa chỉ',
                            hintStyle: const TextStyle(color: Colors.grey),
                            border: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1)),
                            errorText:
                                isErrorTextAddress ? errorTextAddress : null,
                            errorStyle: textStyleErrorInput,
                          ),
                          onChanged: (value) => {
                                if (value.trim().length > maxlengthAddress ||
                                    value.trim().length < minlengthAddress)
                                  {
                                    setState(() {
                                      errorTextAddress =
                                          "Từ $minlengthAddress đến $maxlengthAddress ký tự.";
                                      isErrorTextAddress = true;
                                    })
                                  }
                                else
                                  {
                                    setState(() {
                                      errorTextAddress = "";
                                      isErrorTextAddress = false;
                                    })
                                  }
                              }),
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
                                      !isErrorTextCCCD &&
                                      !isErrorTextPhone &&
                                      !isErrorTextEmail &&
                                      !isErrorTextRole &&
                                      !isErrorTextAddress)
                                    {
                                      employeeController.updateEmployee(
                                          employee.employee_id,
                                          nameController.text,
                                          employee.avatar,
                                          _pickedImage.value,
                                          cccdController.text,
                                          genderController.text,
                                          birthdayController.text,
                                          phoneController.text,
                                          emailController.text,
                                          "00000000",
                                          "city",
                                          "district",
                                          "ward",
                                          addressController.text,
                                          roleController.text),
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
