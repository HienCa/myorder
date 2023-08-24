import 'package:flutter/material.dart';

import '../../constants.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.red,
            title: const Text(
              "Hộp thư cá nhân",
              style: TextStyle(color: Colors.white),
            )),
        body: 1 == 1
            ? const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                    child: Text(
                      'Tính năng này đang phát triển !',
                      style: TextStyle(
                        fontSize: 25,
                        color: textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            )
            : Container()
        // : ListView.builder(
        //     itemCount: searchController.searchedUsers.length,
        //     itemBuilder: (context, index) {
        //       User user = searchController.searchedUsers[index];
        //       return InkWell(
        //         onTap: () => Navigator.of(context).push(
        //           MaterialPageRoute(
        //             builder: (context) => ProfileScreen(uid: user.uid),
        //           ),
        //         ),
        //         child: ListTile(
        //           leading: CircleAvatar(
        //             backgroundImage: NetworkImage(
        //               user.profilePhoto,
        //             ),
        //           ),
        //           title: Text(
        //             user.name,
        //             style: const TextStyle(
        //                 fontSize: 18,
        //                 color: textColor,
        //                 fontWeight: FontWeight.bold),
        //           ),
        //         ),
        //       );
        //     },
        //   ),
        );
  }
}
