// ignore_for_file: non_constant_identifier_names, avoid_print, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:myorder/constants.dart';

class MyDialogMessagePopScreen extends StatefulWidget {
  final String title;
  final String discription;
  final String? note;
  const MyDialogMessagePopScreen({
    Key? key,
    required this.title,
    required this.discription,
    this.note,
  }) : super(key: key);

  @override
  State<MyDialogMessagePopScreen> createState() =>
      _MyDialogMessagePopScreenState();
}

class _MyDialogMessagePopScreenState extends State<MyDialogMessagePopScreen> {
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
        borderRadius: BorderRadius.circular(10.0), // Góc bo tròn
      ),
      elevation: 5, // Độ nâng của bóng đổ
      backgroundColor: backgroundColor,
      child: Theme(
        data: ThemeData(unselectedWidgetColor: primaryColor),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        widget.title.toUpperCase(),
                        style: textStylePrimaryBold,
                      ),
                    ),
                    marginTop20,
                    ListTile(
                      title: Center(
                        child: Text(
                          widget.discription,
                          style: textStyleBlackRegular,
                        ),
                      ),
                      subtitle: Center(
                        child: Text(
                          widget.note ?? '',
                          style: textStyleBlackRegular,
                        ),
                      ),
                    ),
                    marginTop20,
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () => {Navigator.pop(context)},
                              child: Container(
                                height: 50,
                                width: 136,
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  color: backgroundColorGray,
                                ),
                                child: const Center(
                                  child: Text(
                                    'HỦY BỎ',
                                    style: textStyleCancel,
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () => {Navigator.pop(context, 'success')},
                              child: Container(
                                height: 50,
                                width: 136,
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  color: primaryColor,
                                ),
                                child: const Center(
                                  child: Text(
                                    'XÁC NHẬN',
                                    style: textStyleWhiteBold16,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
