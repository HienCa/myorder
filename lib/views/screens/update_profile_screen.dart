import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myorder/views/screens/utilities/profile/profile_screen.dart';
import '../../constants.dart';
import 'package:myorder/controllers/profile_controller.dart';
import 'package:myorder/models/employee.dart' as model;

import '../widgets/custom_icon.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key, required this.uid});
  final String uid;

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  // final TextEditingController _emailController = TextEditingController();
  // final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  ProfileController profileController = Get.put(ProfileController());
  late model.Employee currentUser =
      model.Employee(employee_id: "",
        name: "",
        avatar: "",
        cccd: "",
        gender: "",
        birthday: DateTime.now(),
        phone: "",
        email: "",
        password: "",
        city: "",
        district: "",
        ward: "",
        role: "",
        active: 1,);

  @override
  void initState() {
    super.initState();
    profileController.getCurrentUserData().then((userData) {
      setState(() {
        currentUser = userData;
      });
    });
  }

  buildProfile(String profilePhoto, context, uid) {
    return InkWell(
      // onTap: () {
      //   Navigator.push(context,
      //       MaterialPageRoute(builder: (context) => ProfileScreen(uid: uid)));
      // },
      child: SizedBox(
        width: 150,
        height: 150,
        child: Stack(children: [
          Positioned(
            left: 5,
            child: Container(
              width: 150,
              height: 150,
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image(
                  image: NetworkImage(profilePhoto),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }

  int screen = 5;
  int pageIdx = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (idx) {
          setState(() {
            pageIdx = idx;
            screen = 0;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: backgroundColor,
        selectedItemColor: Colors.red,
        unselectedItemColor: unselectedItemColor,
        currentIndex: pageIdx,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, size: 30),
            label: 'Tìm kiếm',
          ),
          BottomNavigationBarItem(
            icon: CustomIcon(),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message, size: 30),
            label: 'Hộp thư',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 30),
            label: 'Hồ sơ',
          ),
        ],
      ),
      body: screen == 5
          ? Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('CẬP NHẬT THÔNG TIN',
                          style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 32)),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Stack(
                    children: [
                      InkWell(
                          onTap: () {
                            profileController.pickImage();
                          },
                          child: ClipOval(
                            child: Image.network(
                              currentUser.avatar ?? "",
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          )
                          // child: buildProfile(
                          //     currentUser.profilePhoto, context, currentUser.uid),
                          ),
                      Positioned(
                        bottom: -10,
                        right: 20,
                        child: IconButton(
                          onPressed: () => authController.pickImage(),
                          icon: const Icon(
                            Icons.add_a_photo,
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text('@${currentUser.name}',
                      style: const TextStyle(
                          color: textColor,
                          fontSize: 30,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5))),
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
                        label: Text("Một cái tên sang chảnh khác?",
                            style: TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold)),
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w300, color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  InkWell(
                    onTap: () => {
                      profileController.updateProfileUser(
                          widget.uid,
                          _usernameController.text,
                          // _emailController.text,
                          // _passwordController.text,
                          profileController.profilePhoto),
                      Navigator.pop(context),
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ProfilePage(uid: widget.uid),
                      )),
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width - 40,
                      height: 50,
                      decoration: BoxDecoration(
                        color: buttonColor,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'CẬP NHẬT',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : pages[pageIdx],
    );
  }
}
