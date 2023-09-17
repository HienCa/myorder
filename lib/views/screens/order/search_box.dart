import 'package:flutter/material.dart';
import 'package:myorder/constants.dart';




class SearchBox extends StatelessWidget {
  
  const SearchBox({super.key, 
    required this.onChanged,
  });

  final ValueChanged onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 400,
      margin: const EdgeInsets.all(kDefaultPadding),
      padding: const EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
        vertical: kDefaultPadding / 4, // 5 top and bottom
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.4),
        borderRadius:borderRadiusTextField30,
        border: Border.all(width: 1, color: borderColorPrimary)
        
      ),
      child: TextField(
        onChanged: onChanged,
        style: const TextStyle(color: borderColorPrimary),
        decoration: const InputDecoration(
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          fillColor: borderColorPrimary,
          
          icon: Icon(Icons.search, color: iconColorPrimary,),
          hintText: 'Tìm kiếm đơn hàng ...',
          hintStyle: TextStyle(color: borderColorPrimary),
        ),
        cursorColor: borderColorPrimary,
      ),
    );
  }
}
