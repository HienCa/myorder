// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:myorder/constants.dart';

class OptionArea extends StatefulWidget {
  const OptionArea({super.key});

  @override
  _OptionAreaState createState() => _OptionAreaState();
}

class _OptionAreaState extends State<OptionArea> {
  // by default first item will be selected
  int selectedIndex = 0;
  List options = ['Khu A', 'Khu B'];
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
      height: 35,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: options.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            setState(() {
              selectedIndex = index;
            });
          },
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(
              left: kDefaultPadding,
              // At end item it add extra 20 right  padding
              right: index == options.length - 1 ? kDefaultPadding : 0,
            ),
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            decoration: BoxDecoration(
              color: index == selectedIndex
                  ? kBlueColor
                  : textWhiteColor,
              borderRadius: BorderRadius.circular(20),
              border: index == selectedIndex
                  ? Border.all(width: 5, color: borderColorPrimary)
                  : Border.all(width: 1, color: borderColorPrimary)
            ),
            child: Text(
              options[index],
              style: index == selectedIndex ? const TextStyle(color: textWhiteColor,  fontWeight: FontWeight.bold) : const TextStyle(color: primaryColor,  fontWeight: FontWeight.normal),
            ),
          ),
        ),
      ),
    );
  }
}