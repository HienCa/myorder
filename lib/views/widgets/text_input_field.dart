// import 'package:flutter/material.dart';

// class MyTextField extends StatefulWidget {
//   final TextEditingController controller;
//   final String hintText;
//   final int maxLength;
//   final bool isError;
//   final String errorText;
//   final ValueChanged<String>? onChanged;

//   const MyTextField({
//     Key? key,
//     required this.controller,
//     required this.hintText,
//     this.maxLength = 50,
//     this.isError = false,
//     this.errorText = "",
//     this.onChanged,
//   }) : super(key: key);

//   @override
//   _CustomTextFieldState createState() => _CustomTextFieldState();
// }

// class _CustomTextFieldState extends State<MyTextField> {
//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       controller: widget.controller,
//       style: const TextStyle(color: Colors.black), // Điều chỉnh màu sắc văn bản
//       decoration: InputDecoration(
//         hintText: widget.hintText,
//         hintStyle: const TextStyle(color: Colors.grey),
//         errorText: widget.isError ? widget.errorText : null,
//         errorStyle:
//             const TextStyle(color: Colors.red), // Điều chỉnh màu sắc lỗi
//         border: InputBorder.none,
//       ),
//       maxLength: widget.maxLength,
//       onChanged: widget.onChanged,
//     );
//   }
// }
