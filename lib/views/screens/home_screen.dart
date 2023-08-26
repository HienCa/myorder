import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/views/widgets/custom_icon.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int pageIdx = 0;
  pickVideo(ImageSource src, BuildContext context) async {
    final video = await ImagePicker().pickVideo(source: src);
    if (video != null) {
      // ignore: use_build_context_synchronously
      // Navigator.of(context).push(
      //   MaterialPageRoute(
      //     builder: (context) => ConfirmScreen(
      //       videoFile: File(video.path),
      //       videoPath: video.path,
      //     ),
      //   ),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (idx) {
          setState(() {
            pageIdx = idx;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: backgroundColor,
        selectedItemColor: iconColorPrimary,
        unselectedItemColor: unselectedItemColor,
        currentIndex: pageIdx,
        items:  [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30),
            label: 'Tổng quan',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.notes, size: 30),
            label: 'Đơn hàng',
          ),
          BottomNavigationBarItem(
            // icon: CustomIcon(),
            icon: IconButton(
              onPressed: () => pickVideo(
                  ImageSource.gallery, context), 
              icon: const CustomIcon(),
            ),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.table_bar_sharp, size: 30),
            label: 'Khu vực',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 30),
            label: 'Tiện ích',
          ),
        ],
      ),
      body: pages[pageIdx],
    );
  }
}
