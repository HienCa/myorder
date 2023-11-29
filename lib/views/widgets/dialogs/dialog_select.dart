// ignore_for_file: non_constant_identifier_names, avoid_print, prefer_interpolation_to_compose_strings, constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/utils.dart';
import 'package:myorder/views/widgets/icons/icon_close.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

class MyDialogSelect extends StatefulWidget {
  final String lable;
  final List<dynamic> list;
  final String keyNameSearch;

  const MyDialogSelect({
    Key? key,
    required this.lable,
    required this.list,
    required this.keyNameSearch,
  }) : super(key: key);

  @override
  State<MyDialogSelect> createState() => _MyDialogSelectState();
}

class _MyDialogSelectState extends State<MyDialogSelect> {
  var textEditingController = TextEditingController();
  String keySearch = "";
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
      backgroundColor: grayColor200,
      child: Theme(
        data: ThemeData(unselectedWidgetColor: primaryColor),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                color: primaryColor,
                height: 40,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      marginRight20,
                      const Spacer(),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Marquee(
                          direction: Axis.horizontal,
                          textDirection: TextDirection.ltr,
                          animationDuration: const Duration(seconds: 1),
                          backDuration: const Duration(milliseconds: 4000),
                          pauseDuration: const Duration(milliseconds: 1000),
                          directionMarguee: DirectionMarguee.TwoDirection,
                          child: Text(
                            widget.lable.toUpperCase(),
                            style: textStyleWhiteBold20,
                          ),
                        ),
                      ),
                      const Spacer(),
                      marginRight10,
                      const MyCloseIcon(heightWidth: 30, sizeIcon: 16),
                    ],
                  ),
                )),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 50,
                  width: 400,
                  margin: const EdgeInsets.all(kDefaultPadding),
                  padding: const EdgeInsets.symmetric(
                    horizontal: kDefaultPadding,
                    vertical: kDefaultPadding / 4, // 5 top and bottom
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.4),
                      borderRadius: borderRadiusTextField30,
                      border: Border.all(width: 1, color: borderColorPrimary)),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        keySearch = value;
                      });
                    },
                    style: const TextStyle(color: borderColorPrimary),
                    decoration: const InputDecoration(
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      fillColor: borderColorPrimary,
                      icon: Icon(
                        Icons.search,
                        color: iconColorPrimary,
                      ),
                      hintText: 'Tìm kiếm',
                      hintStyle: TextStyle(color: borderColorPrimary),
                    ),
                    cursorColor: borderColorPrimary,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: ListView.builder(
                    itemCount: widget.list
                        .where((element) => element.name.contains(keySearch))
                        .length,
                    itemBuilder: (context, index) {
                      var filteredList = widget.list
                          .where((element) => element.name.contains(keySearch))
                          .toList();
                      return InkWell(
                        onTap: () {
                          //Trả về 1 model đã chọn
                          Utils.myPopResult(context, filteredList[index]);
                        },
                        child: Column(
                          children: [
                            ListTile(
                              title: Marquee(
                                direction: Axis.horizontal,
                                textDirection: TextDirection.ltr,
                                animationDuration: const Duration(seconds: 1),
                                backDuration: const Duration(milliseconds: 4000),
                                pauseDuration: const Duration(milliseconds: 1000),
                                directionMarguee: DirectionMarguee.TwoDirection,
                                child: Text(
                                  filteredList[index].name ?? "",
                                  style: textStyleNameBlackRegular,
                                ),
                              ),
                            ),
                            deviderColor1
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            marginTop10
          ],
        ),
      ),
    );
  }
}
