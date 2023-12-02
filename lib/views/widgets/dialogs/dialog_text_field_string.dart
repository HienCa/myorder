// ignore_for_file: non_constant_identifier_names, avoid_print, prefer_interpolation_to_compose_strings, constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/utils.dart';
import 'package:myorder/views/widgets/icons/icon_close.dart';
import 'package:myorder/views/widgets/textfields/text_field_label/text_field_string.dart';

class MyDialogTextFieldString extends StatefulWidget {
  final String title;
  final String label;
  final String placeholder;
  final bool isRequire;
  final String textDefault;
  final int minLength;
  final int maxLength;

  const MyDialogTextFieldString({
    Key? key,
    required this.title,
    required this.label,
    required this.textDefault,
    required this.minLength,
    required this.maxLength,
    required this.placeholder,
    required this.isRequire,
  }) : super(key: key);

  @override
  State<MyDialogTextFieldString> createState() =>
      _MyDialogTextFieldStringState();
}

class _MyDialogTextFieldStringState extends State<MyDialogTextFieldString> {
  var textEditingController = TextEditingController();
  String keySearch = "";
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    textEditingController.text = widget.textDefault;
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
                            widget.title.toUpperCase(),
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
            marginTop10,
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MyTextFieldString(
                  textController: textEditingController,
                  label: widget.label,
                  placeholder: widget.placeholder,
                  isReadOnly: false,
                  min: widget.minLength,
                  max: widget.maxLength,
                  isRequire: widget.isRequire),
            ),
            InkWell(
              onTap: () {
                Utils.myPopResult(context, textEditingController.text.trim());
              },
              child: Container(
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                margin: const EdgeInsets.all(8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("OK", style: textStyleWhiteBold16),
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
