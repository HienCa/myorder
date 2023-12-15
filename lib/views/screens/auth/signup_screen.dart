import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/views/screens/auth/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _usernameController = TextEditingController();
  // final TextEditingController _cccdController = TextEditingController();
  // final TextEditingController _genderController = TextEditingController();
  // final TextEditingController _birthdayController = TextEditingController();
  // final TextEditingController _phoneController = TextEditingController();
  // final TextEditingController _cityController = TextEditingController();
  // final TextEditingController _districtController = TextEditingController();
  // final TextEditingController _wardController = TextEditingController();
  // final TextEditingController _roleController = TextEditingController();

  String? selectedImagePath;
  final Rx<File?> _pickedImage = Rx<File?>(null);
  @override
  void initState() {
    super.initState();
    // Truy xuất dữ liệu từ Firestore trong hàm initState và lưu vào trường receivedFriendRequests
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
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'VANHIEN-ORDER',
              style: GoogleFonts.bungee(
                fontSize: 40,
                color: buttonColor,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Stack(
              children: [
                if (selectedImagePath != null)
                  ClipOval(
                    child: Image.file(
                      File(selectedImagePath!),
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  InkWell(
                    onTap: () async {
                      await pickImage();
                    },
                    child: ClipOval(
                      child: Image.asset(
                        defaultLogoImageString,
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                Positioned(
                  bottom: -10,
                  left: 80,
                  child: IconButton(
                    onPressed: () async {
                      await pickImage();
                    },
                    icon: const Icon(
                      Icons.add_a_photo,
                      color: Colors.redAccent,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  borderRadius: const BorderRadius.all(Radius.circular(5))),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _usernameController,
                style: const TextStyle(color: textColor),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Colors.redAccent,
                  ),
                  label: Text("Tên người dùng",
                      style: TextStyle(color: Colors.black)),
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.w300, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  borderRadius: const BorderRadius.all(Radius.circular(5))),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _emailController,
                style: const TextStyle(color: textColor),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Colors.redAccent,
                  ),
                  label: Text("Email", style: TextStyle(color: Colors.black)),
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.w300, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  borderRadius: const BorderRadius.all(Radius.circular(5))),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                style: const TextStyle(color: textColor),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Colors.redAccent,
                  ),
                  label:
                      Text("Mật khẩu", style: TextStyle(color: Colors.black)),
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.w300, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              width: MediaQuery.of(context).size.width - 40,
              height: 50,
              decoration: BoxDecoration(
                color: buttonColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              child: const InkWell(
                // onTap: () => authController.registerUser(
                //   _usernameController.text,
                //   _emailController.text,
                //   _passwordController.text,
                // )
                child: Center(
                  child: Text(
                    'ĐĂNG KÝ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  ),
                  child: const Text(
                    'Bạn đã có tài khoản rồi? ',
                    style: TextStyle(fontSize: 20, color: Colors.blueAccent),
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  ),
                  child: Text(
                    'Đăng nhập',
                    style: TextStyle(fontSize: 20, color: buttonColor),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
