import 'package:flutter/material.dart';

class CustomIcon extends StatelessWidget {
  const CustomIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 40,
      child: Stack(
        children: [
          Center(
            child: SizedBox(
              height: double.infinity,
              width: 50,
              child: Image.asset(
                "assets/images/logo.jpg",
                width: 150,
                height: 150,
                fit: BoxFit.contain,
              ),
            ),
          )
        ],
      ),
    );
  }
}
