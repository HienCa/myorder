
import 'package:flutter/material.dart';
import 'package:myorder/views/screens/managements/dashboard/dashboard_screen.dart';

class MyLandscapeScreen extends StatelessWidget {
  const MyLandscapeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.landscape) {
          return const Scaffold(
            
            body: MyDashBoard(),
          );
        } else {
          return const Scaffold(
            body: Center(
              child: Text('Chỉ hỗ trợ màn hình ngang'),
            ),
          );
        }
      },
    );
  }
}