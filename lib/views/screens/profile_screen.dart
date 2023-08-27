// ignore_for_file: avoid_single_cascade_in_expression_statements

// import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/profile_controller.dart';
import 'package:myorder/views/screens/home_screen.dart';
import 'package:myorder/views/screens/update_profile_screen.dart';


class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

enum MenuOptions { option1, option2, option3 }

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController profileController = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    profileController.updateUserId(widget.uid);
  }

  _dismissDialog() {
    Navigator.pop(context);
  }

  void showPopupMenu(BuildContext context) {
    // Show the PopupMenuButton as you did before
    showMenu<MenuOptions>(
      context: context,
      position: const RelativeRect.fromLTRB(
          1000, 80, 10, 0), // Change the position as needed
      items: <PopupMenuEntry<MenuOptions>>[
        const PopupMenuItem<MenuOptions>(
          value: MenuOptions.option1,
          child: ListTile(
            leading: Icon(Icons.people),
            title: Text('Bạn bè'),
          ),
        ),
        const PopupMenuItem<MenuOptions>(
          value: MenuOptions.option2,
          child: ListTile(
            leading: Icon(Icons.settings),
            title: Text('Cài đặt'),
          ),
        ),
        const PopupMenuItem<MenuOptions>(
          value: MenuOptions.option3,
          child: ListTile(
            leading: Icon(Icons.logout),
            title: Text('Đăng xuất'),
          ),
        ),
      ],

      elevation: 8.0,
    ).then((selectedOption) {
      // Handle the selected option here
      if (selectedOption != null) {
        switch (selectedOption) {
          case MenuOptions.option1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
            break;
          case MenuOptions.option2:
            break;
          case MenuOptions.option3:
            profileController.updateUserId('');
            authController.signOut();
            break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
        init: ProfileController(),
        builder: (controller) {
          void showCupertinoDialog() {
            showDialog(
                context: context,
                builder: (context) {
                  String name = controller.user['name'];
                  return CupertinoAlertDialog(
                    title: Text('Bạn muốn hủy kết bạn với @$name ?'),
                    content: const Text('Đừng hủy kết bạn với mình mà! huhu!'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          _dismissDialog();
                        },
                        child: const Text('Hủy',
                            style: TextStyle(color: Colors.redAccent)),
                      ),
                      TextButton(
                        onPressed: () {
                          controller.cancelFriend(widget.uid);
                          _dismissDialog();
                        },
                        child: const Text('Xác nhận',
                            style: TextStyle(color: Colors.white)),
                      )
                    ],
                  );
                });
          }

          if (controller.user.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            // print(controller.user);
          }
          return Scaffold(
            appBar: AppBar(
              backgroundColor: backgroundColor,
              leading: const Icon(
                Icons.person_add_alt_1_outlined,
                color: Colors.black54,
              ),
              title: const Center(child: Text('THÔNG TIN CÁ NHÂN', style:TextStyle(color:Colors.redAccent, fontWeight: FontWeight.bold))),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.menu,
                      color: Colors.black), // Add the menu icon here
                  onPressed: () {
                    // Show the PopupMenuButton when the menu icon is pressed
                    showPopupMenu(context);
                  },
                ),
              ],
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ClipOval(
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: controller.user['profilePhoto'],
                                    height: 100,
                                    width: 100,
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(
                                      Icons.error,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '@${controller.user['name']}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                      color: textColor),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      controller.user['following'],
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: textColor),
                                    ),
                                    const SizedBox(height: 5),
                                    const Text(
                                      'Đang follow',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  color: Colors.black54,
                                  width: 1,
                                  height: 15,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                  ),
                                ),
                                Column(
                                  children: [
                                    Text(
                                      controller.user['followers'],
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: textColor),
                                    ),
                                    const SizedBox(height: 5),
                                    const Text(
                                      'Followers',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  color: Colors.black54,
                                  width: 1,
                                  height: 15,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                  ),
                                ),
                                Column(
                                  children: [
                                    Text(
                                      controller.user['likes'],
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: textColor),
                                    ),
                                    const SizedBox(height: 5),
                                    const Text(
                                      'Thích',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width: 140,
                                  height: 47,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.grey[300],
                                  ),
                                  child: Center(
                                    child: InkWell(
                                      onTap: () {
                                        if (widget.uid ==
                                            authController.user.uid) {
                                          //chỉnh sửa hồ sơ
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      UpdateProfile(
                                                          uid: authController
                                                              .user.uid)));
                                        } else {
                                          // chức năng kết bạn
                                          // controller.addFriend(widget.uid);
                                        }
                                      },
                                      child:
                                          widget.uid == authController.user.uid
                                              ? const Text(
                                                  'Sửa hồ sơ',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: textColor),
                                                )
                                              : (FutureBuilder<bool>(
                                                  future: profileController
                                                      .isFriended(widget.uid),
                                                  builder: (context, snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return const CircularProgressIndicator();
                                                    } else if (snapshot
                                                        .hasError) {
                                                      return Text(
                                                          'Error: Lỗi kết nối - ${snapshot.error}');
                                                    } else {
                                                      bool isfriended =
                                                          snapshot.data ??
                                                              false;
                                                      return isfriended
                                                          ? ElevatedButton(
                                                              onPressed: () {
                                                                showCupertinoDialog();
                                                              },
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                backgroundColor:
                                                                    Colors
                                                                        .redAccent,
                                                                elevation: 2.0,
                                                              ),
                                                              child: const Text(
                                                                'Hủy kết bạn',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            )
                                                          : FutureBuilder<bool>(
                                                              future: profileController
                                                                  .isFriendRequestSent(
                                                                      widget
                                                                          .uid),
                                                              builder: (context,
                                                                  snapshot) {
                                                                if (snapshot
                                                                        .connectionState ==
                                                                    ConnectionState
                                                                        .waiting) {
                                                                  // Show a loading indicator while waiting for the result
                                                                  return const CircularProgressIndicator();
                                                                } else if (snapshot
                                                                    .hasError) {
                                                                  // Show an error message if there is an error
                                                                  return Text(
                                                                      'Error: Lỗi kết nối - ${snapshot.error}');
                                                                } else {
                                                                  // Use a ternary operator to display different texts based on the result
                                                                  bool
                                                                      isRequestSent =
                                                                      snapshot.data ??
                                                                          false; // Use 'false' as default value if data is null
                                                                  return isRequestSent
                                                                      ? ElevatedButton(
                                                                          onPressed:
                                                                              () {
                                                                            controller.cancelFriendRequestSent(widget.uid);
                                                                          },
                                                                          style:
                                                                              ElevatedButton.styleFrom(
                                                                            backgroundColor:
                                                                                Colors.redAccent,
                                                                            elevation:
                                                                                2.0,
                                                                          ),
                                                                          child:
                                                                              const Text(
                                                                            'Thu hồi',
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.white,
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : ElevatedButton(
                                                                          onPressed:
                                                                              () {
                                                                            controller.addFriend(widget.uid);
                                                                          },
                                                                          style:
                                                                              ElevatedButton.styleFrom(
                                                                            backgroundColor:
                                                                                Colors.redAccent,
                                                                            elevation:
                                                                                2.0,
                                                                          ),
                                                                          child:
                                                                              const Text(
                                                                            'Kết bạn',
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.white,
                                                                            ),
                                                                          ),
                                                                        );
                                                                }
                                                              });
                                                    }
                                                  })),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 140,
                                  height: 47,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.grey[300],
                                  ),
                                  child: Center(
                                    child: InkWell(
                                      onTap: () {
                                        if (widget.uid ==
                                            authController.user.uid) {
                                          profileController.updateUserId(
                                              '');
                                          authController.signOut();

                                        } else {
                                          controller.followUser();
                                        }
                                      },
                                      child: Text(
                                        widget.uid == authController.user.uid
                                            ? 'Đăng xuất'
                                            : controller.user['isFollowing']
                                                ? 'Bỏ theo dõi'
                                                : 'Theo dõi',
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: textColor),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            // video list
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller.user['thumbnails'].length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 1,
                                crossAxisSpacing: 5,
                              ),
                              itemBuilder: (context, index) {
                                String thumbnail =
                                    controller.user['thumbnails'][index];
                                return CachedNetworkImage(
                                  imageUrl: thumbnail,
                                  fit: BoxFit.cover,
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
