// import 'package:flutter/material.dart';
// import 'package:your_package_name_here/constants.dart'; // Import your constants

// class CustomSearchBar extends StatelessWidget {
//   final TextEditingController controller;
//   final Function(String) onChanged;

//   const CustomSearchBar({
//     Key? key,
//     required this.controller,
//     required this.onChanged,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 40,
//       width: 250,
//       padding: const EdgeInsets.only(left: 8),
//       margin: const EdgeInsets.only(right: 8, left: 8),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.4),
//         borderRadius: borderRadiusTextField30,
//         border: Border.all(width: 1, color: borderColorPrimary),
//       ),
//       child: TextField(
//         controller: controller,
//         onChanged: onChanged,
//         style: const TextStyle(color: borderColorPrimary),
//         decoration: const InputDecoration(
//           enabledBorder: InputBorder.none,
//           focusedBorder: InputBorder.none,
//           fillColor: borderColorPrimary,
//           icon: Icon(
//             Icons.search,
//             color: iconColorPrimary,
//           ),
//           hintText: 'Tìm kiếm đơn hàng ...',
//           hintStyle: TextStyle(color: borderColorPrimary),
//         ),
//         cursorColor: borderColorPrimary,
//       ),
//     );
//   }
// }
