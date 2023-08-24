// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:myorder/controllers/search_controller.dart';
// import 'package:get/get.dart';
// import 'package:myorder/models/employee.dart';
// import 'package:myorder/views/screens/profile_screen.dart';
// import 'package:myorder/constants.dart';

// import 'chat/chat_page.dart';

// class SearchScreen extends StatefulWidget {
//   const SearchScreen({Key? key}) : super(key: key);

//   @override
//   State<SearchScreen> createState() => _SearchScreenState();
// }

// class _SearchScreenState extends State<SearchScreen> {
//   final SearchControllerCustom searchController =
//       Get.put(SearchControllerCustom());

//   final TextEditingController _textEditingController = TextEditingController();
//   @override
//   void initState() {
//     super.initState();
//     searchController.searchEmployee("");
//   }

//   List<Employee> friendsList = [];
//   Future<bool> isFriended(String id) async {
//     var userDoc = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(authController.user.uid)
//         .get();

//     if (userDoc.exists) {
//       var friends = userDoc.data()?['friends'] ?? [];

//       return friends.contains(id);
//     }

//     return false;
//   }

//   Future<void> addFriend(String id) async {
//     var userSendDocRef =
//         firestore.collection('users').doc(authController.user.uid);
//     var userSendDoc = await userSendDocRef.get();

//     var userTargetDocRef = firestore.collection('users').doc(id);
//     var userTargetDoc = await userTargetDocRef.get();

//     if (userSendDoc.exists && userTargetDoc.exists) {
//       // Check if they are not already friends
//       var isfriended = await isFriended(id);
//       if (!isfriended) {
//         var sentFriendRequests =
//             userTargetDoc.data()?['receivedFriendRequests'] ?? [];

//         sentFriendRequests = [
//           ...sentFriendRequests,
//           authController.user.uid
//         ]; // uid là uid người gửi

//         await userTargetDocRef.set({
//           'receivedFriendRequests': sentFriendRequests,
//         }, SetOptions(merge: true));
//       }
//     }
//     Get.snackbar(
//       'KẾT BẠN!',
//       'Bạn đã gửi lời mời kết bạn thành công.',
//       backgroundColor: Colors.lightBlue, // Màu nền
//       colorText: Colors.white, // M
//     );
//   }

//   Future<bool> isFollowed(String currentUser, String targetUser) async {
//     try {
//       var snapshot = await firestore
//           .collection('users')
//           .doc(targetUser)
//           .collection('followers')
//           .doc(currentUser)
//           .get();

//       return snapshot.exists;
//     } catch (error) {
//       return false;
//     }
//   }

//   followUser(String uid) async {
//     var doc = await firestore
//         .collection('users')
//         .doc(uid)
//         .collection('followers')
//         .doc(authController.user.uid)
//         .get();

//     if (!doc.exists) {
//       await firestore
//           .collection('users')
//           .doc(uid)
//           .collection('followers')
//           .doc(authController.user.uid)
//           .set({});
//       await firestore
//           .collection('users')
//           .doc(authController.user.uid)
//           .collection('following')
//           .doc(uid)
//           .set({});

//       Get.snackbar(
//         'THEO DÕI!',
//         'Bạn đã theo dõi người dùng này.',
//         backgroundColor: Colors.lightBlue, // Màu nền
//         colorText: Colors.white, // M
//       );
//     } else {
//       await firestore
//           .collection('users')
//           .doc(uid)
//           .collection('followers')
//           .doc(authController.user.uid)
//           .delete();
//       await firestore
//           .collection('users')
//           .doc(authController.user.uid)
//           .collection('following')
//           .doc(uid)
//           .delete();

//       Get.snackbar(
//         'THEO DÕI!',
//         'Bạn đã hủy theo dõi người dùng này.',
//         backgroundColor: Colors.lightBlue, // Màu nền
//         colorText: Colors.white, // M
//       );
//     }
//     setState(() {});
//   }

//   _dismissDialog() {
//     Navigator.pop(context);
//   }

//   void _showSimpleDialog(String uid, String name) {
//     showDialog(
//         context: context,
//         builder: (context) {
//           return SimpleDialog(
//             backgroundColor: Colors.white,
//             // title: const Text(''),
//             children: <Widget>[
//               SimpleDialogOption(
//                 onPressed: () {
//                   _dismissDialog();
//                 },
//                 child: InkWell(
//                     onTap: () => {
//                           Navigator.of(context).push(
//                             MaterialPageRoute(
//                               builder: (context) => ProfileScreen(uid: uid),
//                             ),
//                           ),
//                         },
//                     child: const Center(
//                         child: Text(
//                       'Xem trang cá nhân',
//                       style: TextStyle(fontSize: 20, color: textColor),
//                     ))),
//               ),
//               uid != authController.user.uid
//                   ? const Divider(
//                       color: textColor,
//                     )
//                   : Container(),
//               uid != authController.user.uid
//                   ? SimpleDialogOption(
//                       onPressed: () {
//                         _dismissDialog();
//                       },
//                       child: InkWell(
//                           onTap: () => {addFriend(uid)},
//                           child: const Center(
//                               child: Text(
//                             'Kết bạn',
//                             style: TextStyle(fontSize: 20, color: textColor),
//                           ))),
//                     )
//                   : const SimpleDialogOption(),
//               const Divider(
//                 color: textColor,
//               ),
//               SimpleDialogOption(
//                 onPressed: () {
//                   _dismissDialog();
//                 },
//                 child: InkWell(
//                     onTap: () => {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => ChatPage(
//                                       receiverUserName: name,
//                                       receierUserId: uid,
//                                     )),
//                           )
//                         },
//                     child: const Center(
//                         child: Text(
//                       'Nhắn tin',
//                       style: TextStyle(fontSize: 20, color: textColor),
//                     ))),
//               ),
//               const Divider(
//                 color: textColor,
//               ),
//               SimpleDialogOption(
//                 onPressed: () {
//                   _dismissDialog();
//                 },
//                 child: InkWell(
//                     onTap: () => {},
//                     child: const Center(
//                         child: Text(
//                       'Chặn',
//                       style: TextStyle(fontSize: 20, color: textColor),
//                     ))),
//               ),
//             ],
//           );
//         });
//   }

//   // Danh sách các đối tượng User
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       return Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.red,
//           title: TextFormField(
//             controller: _textEditingController,
//             decoration: const InputDecoration(
//               filled: false,
//               hintText: 'Tìm kiếm người dùng...',
//               hintStyle: TextStyle(
//                 fontSize: 18,
//                 color: Colors.white,
//               ),
//             ),
//             onChanged: (value) {
//               searchController.searchEmployee(value);
//             },
//             onFieldSubmitted: (value) {
//               searchController.searchEmployee(value);
//             },
//           ),
//         ),
//         body: searchController.searchedUsers.isEmpty
//             ? const Center(
//                 child: Text(
//                   'Tìm kiếm người dùng!',
//                   style: TextStyle(
//                     fontSize: 25,
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               )
//             : ListView.builder(
//                 itemCount: searchController.searchedUsers.length,
//                 itemBuilder: (context, index) {
//                   Employee user = searchController.searchedUsers[index];
//                   return InkWell(
//                     onTap: () => Navigator.of(context).push(
//                       MaterialPageRoute(
//                         builder: (context) =>
//                             ProfileScreen(uid: user.employee_id),
//                       ),
//                     ),
//                     onLongPress: () =>
//                         _showSimpleDialog(user.employee_id, user.name),
//                     child: user.employee_id != authController.user.uid
//                         ? ListTile(
//                             leading: CircleAvatar(
//                               backgroundImage: NetworkImage(
//                                 user.avatar ?? "",
//                               ),
//                             ),
//                             title: Text(
//                               user.name,
//                               style: const TextStyle(
//                                   fontSize: 18,
//                                   color: textColor,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                             trailing: user.employee_id !=
//                                     authController.user.uid
//                                 ? InkWell(
//                                     onTap: () => {followUser(user.employee_id)},
//                                     child: Container(
//                                       width: 100,
//                                       height: 30,
//                                       decoration: const BoxDecoration(
//                                           color: Colors.redAccent,
//                                           borderRadius: BorderRadius.all(
//                                               Radius.circular(10))),
//                                       child: FutureBuilder<bool>(
//                                         future: isFollowed(user.employee_id,
//                                             authController.user.uid),
//                                         builder: (context, snapshot) {
//                                           if (snapshot.connectionState ==
//                                               ConnectionState.waiting) {
//                                             return const Text('');
//                                           } else if (snapshot.hasError) {
//                                             return Text(
//                                                 'Error: ${snapshot.error}');
//                                           } else {
//                                             if (snapshot.data == true) {
//                                               return FutureBuilder<bool>(
//                                                 future: isFollowed(
//                                                     authController.user.uid,
//                                                     user.employee_id),
//                                                 builder: (context, snapshot) {
//                                                   if (snapshot
//                                                           .connectionState ==
//                                                       ConnectionState.waiting) {
//                                                     return const Text('');
//                                                   } else if (snapshot
//                                                       .hasError) {
//                                                     return Text(
//                                                         'Error: ${snapshot.error}');
//                                                   } else {
//                                                     if (snapshot.data == true) {
//                                                       return const Center(
//                                                           child: Text(
//                                                               'Hủy follow'));
//                                                     } else {
//                                                       return const Center(
//                                                           child: Text(
//                                                               'Follow lại'));
//                                                     }
//                                                   }
//                                                 },
//                                               );
//                                             } else {
//                                               return FutureBuilder<bool>(
//                                                 future: isFollowed(
//                                                     authController.user.uid,
//                                                     user.employee_id),
//                                                 builder: (context, snapshot) {
//                                                   if (snapshot
//                                                           .connectionState ==
//                                                       ConnectionState.waiting) {
//                                                     return const Text('');
//                                                   } else if (snapshot
//                                                       .hasError) {
//                                                     return Text(
//                                                         'Error: ${snapshot.error}');
//                                                   } else {
//                                                     if (snapshot.data == true) {
//                                                       return const Center(
//                                                           child: Text(
//                                                               'Hủy follow'));
//                                                     } else {
//                                                       return const Center(
//                                                           child:
//                                                               Text('Follow'));
//                                                     }
//                                                   }
//                                                 },
//                                               );
//                                             }
//                                           }
//                                         },
//                                       ),
//                                     ),
//                                   )
//                                 : Container(),
//                           )
//                         : Container(),
//                   );
//                 },
//               ),
//       );
//     });
//   }
// }
