import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/views/screens/auth/signup_screen.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../controllers/profile_controller.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipOval(
                child: Image.asset(
                  "assets/images/logo.jpg",
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'HIENCA-ORDER',
                style: GoogleFonts.bungee(
                  fontSize: 24,
                  color: buttonColor,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(
                height: 25,
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
                height: 25,
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
                child: InkWell(
                  onTap: () => {
                    authController.loginUser(
                      _emailController.text,
                      _passwordController.text,
                    ),
                    profileController.updateUserId(
                        authController.user.uid) // update current user
                  },
                  child: const Center(
                    child: Text(
                      'ĐĂNG NHẬP',
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
                        builder: (context) => const SignupScreen(),
                      ),
                    ),
                    child: const Text(
                      'Quên mật khẩu? ',
                      style: TextStyle(fontSize: 20, color: Colors.blueAccent),
                    ),
                  ),
                  // InkWell(
                  //   // onTap: () => Navigator.of(context).push(
                  //   //   MaterialPageRoute(
                  //   //     builder: (context) => const SignupScreen(),
                  //   //   ),
                  //   // ),
                  //   child: Text(
                  //     'Nhận OTP',
                  //     style: TextStyle(fontSize: 20, color: buttonColor),
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
