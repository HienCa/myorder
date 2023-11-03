// // ignore_for_file: avoid_single_cascade_in_expression_statements, avoid_print

// // import 'package:awesome_dialog/awesome_dialog.dart';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:myorder/config.dart';
// import 'package:myorder/constants.dart';
// import 'package:myorder/constants/app_constants.dart';
// import 'package:myorder/controllers/foods/foods_controller.dart';
// import 'package:myorder/models/food.dart';
// import 'package:myorder/utils.dart';
// import 'package:myorder/views/widgets/textfields/text_field_string.dart';

// class AddTestPage extends StatefulWidget {
//   const AddTestPage({
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<AddTestPage> createState() => _AddTestPageState();
// }

// class _AddTestPageState extends State<AddTestPage> {
//   FoodController foodController = Get.put(FoodController());

//   String? errorTextName = "";
//   String? errorTextVatPercent = "";

//   bool isErrorTextName = false;
//   bool isErrorTextVatPercent = false;
//   bool isCheckCombo = false;
//   @override
//   void initState() {
//     super.initState();
//   }

//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController vatPercentController = TextEditingController();

//   void toggleSelectedFood(Food food) {
//     if (food.isSelected == true) {
//       food.isSelected = false;
//     } else {
//       food.isSelected = true;
//     }
//     print("SELECTED");
//     print(food.name);
//     print(food.isSelected);
//   }

//   void unSelectedFood(Food food) {
//     print("UNSELECTED");
//     print(food.isSelected);
//     if (food.isSelected == true) {
//       food.isSelected = false;
//       print(food.name);
//     }
//   }

//   @override
//   void dispose() {
//     nameController.dispose();
//     vatPercentController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: InkWell(
//           onTap: () {
//             Navigator.pop(context);
//           },
//           child: const Icon(
//             Icons.arrow_back_ios,
//             color: secondColor,
//           ),
//         ),
//         title: const Center(
//             child: Text(
//           "THÊM MỚI TEST",
//           style: TextStyle(color: secondColor),
//         )),
//         actions: [
//           Container(
//             margin: const EdgeInsets.only(right: 10),
//             child: const Padding(
//               padding: EdgeInsets.all(10),
//               child: Icon(
//                 Icons.add_circle_outline,
//                 color: transparentColor,
//               ),
//             ),
//           ),
//         ],
//         backgroundColor: primaryColor,
//       ),
//       body: Theme(
//         data: ThemeData(unselectedWidgetColor: primaryColor),
//         child: SingleChildScrollView(
//             padding: const EdgeInsets.all(10),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       marginTop10,
//                       MyTextFieldString(
//                         textController: nameController,
//                         label: 'TÊN TEST',
//                         placeholder: 'Nhập tên',
//                         isReadOnly: false,
//                         min: minlength2,
//                         max: maxlength50,
//                         isRequire: true,
//                       ),
//                       ListTile(
//                         leading: Theme(
//                           data: ThemeData(unselectedWidgetColor: primaryColor),
//                           child: Checkbox(
//                             value: isCheckCombo,
//                             onChanged: (bool? value) {
//                               setState(() {
//                                 isCheckCombo = value!;
//                                 if (isCheckCombo == false) {
//                                   Utils.refeshSelected(foodController.foods);
//                                 }
//                               });
//                             },
//                             activeColor: primaryColor,
//                           ),
//                         ),
//                         title: Utils.counterSelected(foodController.foods) > 0
//                             ? Text(
//                                 "Món Combo (${Utils.counterSelected(foodController.foods)})",
//                                 style: textStylePriceBold16,
//                               )
//                             : const Text(
//                                 "Món Combo",
//                                 style: textStylePriceBold16,
//                               ),
//                       ),
//                       AnimatedOpacity(
//                         opacity: isCheckCombo ? 1.0 : 0.0,
//                         duration: const Duration(milliseconds: 500),
//                         child: isCheckCombo
//                             ? Column(
//                                 children: [
//                                   Container(
//                                     decoration: BoxDecoration(
//                                       color: primaryColor,
//                                       borderRadius: BorderRadius.circular(5),
//                                     ),
//                                     margin: const EdgeInsets.symmetric(
//                                         vertical: kDefaultPadding / 2),
//                                     height: 50,
//                                     child: ListView.builder(
//                                       scrollDirection: Axis.horizontal,
//                                       itemCount: Utils.filterSelected(
//                                               foodController.foods)
//                                           .length,
//                                       itemBuilder: (context, index) =>
//                                           GestureDetector(
//                                         onTap: () => {
//                                           setState(() {
//                                             unSelectedFood(
//                                                 foodController.foods[index]);
//                                           })
//                                         },
//                                         child: Container(
//                                           alignment: Alignment.center,
//                                           margin: EdgeInsets.only(
//                                             left: kDefaultPadding,
//                                             right: index ==
//                                                     Utils.filterSelected(
//                                                                 foodController
//                                                                     .foods)
//                                                             .length -
//                                                         1
//                                                 ? kDefaultPadding
//                                                 : 0,
//                                           ),
//                                           padding: const EdgeInsets.symmetric(
//                                               horizontal: 10),
//                                           decoration: BoxDecoration(
//                                               color: textWhiteColor,
//                                               borderRadius:
//                                                   BorderRadius.circular(20),
//                                               border: Border.all(
//                                                   width: 5,
//                                                   color: borderColorPrimary)),
//                                           child: Row(
//                                             children: [
//                                               Text(
//                                                 Utils.filterSelected(
//                                                         foodController
//                                                             .foods)[index]
//                                                     .name,
//                                                 style: const TextStyle(
//                                                     color: primaryColor,
//                                                     fontWeight:
//                                                         FontWeight.normal),
//                                               ),
//                                               iconClose
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   Container(
//                                     decoration: BoxDecoration(
//                                       color: primaryColor,
//                                       borderRadius: BorderRadius.circular(5),
//                                     ),
//                                     padding: const EdgeInsets.all(10),
//                                     height: 300,
//                                     child: ListView.builder(
//                                       scrollDirection: Axis.vertical,
//                                       itemCount: foodController.foods.length,
//                                       itemBuilder: (context, index) =>
//                                           GestureDetector(
//                                         onTap: () {
//                                           setState(() {
//                                             toggleSelectedFood(
//                                                 foodController.foods[index]);
//                                           });
//                                         },
//                                         child: Stack(children: [
//                                           Container(
//                                             height: 50,
//                                             alignment: Alignment.center,
//                                             margin: const EdgeInsets.only(
//                                               bottom: 5,
//                                             ),
//                                             padding: const EdgeInsets.symmetric(
//                                                 horizontal: 10),
//                                             decoration: BoxDecoration(
//                                               color: secondColor,
//                                               borderRadius:
//                                                   BorderRadius.circular(10),
//                                             ),
//                                             child: Text(
//                                               foodController.foods[index].name,
//                                               style: const TextStyle(
//                                                   color: primaryColor,
//                                                   fontWeight:
//                                                       FontWeight.normal),
//                                             ),
//                                           ),
//                                           Utils.isSelected(
//                                                   foodController.foods[index])
//                                               ? Positioned(
//                                                   top: 0,
//                                                   right: 10,
//                                                   child: Container(
//                                                     color: Colors.transparent,
//                                                     height: 30,
//                                                     width: 30,
//                                                     child: ClipRRect(
//                                                       child: checkImageGreen,
//                                                     ),
//                                                   ))
//                                               : const SizedBox()
//                                         ]),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               )
//                             : const SizedBox(),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   height: MediaQuery.of(context).size.height * 0.5,
//                 ),
//                 SizedBox(
//                   height: 50,
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Expanded(
//                         child: InkWell(
//                           onTap: () => {Navigator.pop(context)},
//                           child: Container(
//                             height: 50,
//                             decoration: const BoxDecoration(
//                                 color: dividerColor,
//                                 borderRadius:
//                                     BorderRadius.all(Radius.circular(5))),
//                             child: const Align(
//                               alignment: Alignment.center,
//                               child: Text("QUAY LẠI", style: buttonStyleCancel),
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(
//                         width: 10,
//                       ),
//                       Expanded(
//                         child: InkWell(
//                           onTap: () {},
//                           child: Container(
//                             height: 50,
//                             decoration: const BoxDecoration(
//                               color: primaryColor,
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(5)),
//                             ),
//                             child: const Align(
//                               alignment: Alignment.center,
//                               child:
//                                   Text("THÊM MỚI", style: buttonStyleBlackBold),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               ],
//             )),
//       ),
//     );
//   }
// }
