import 'package:flutter/material.dart';
import 'package:myorder/constants.dart';

class CustomDialogCreateUpdateArea extends StatefulWidget {
  final bool isUpdate;

  const CustomDialogCreateUpdateArea({Key? key, required this.isUpdate})
      : super(key: key);
  @override
  State<CustomDialogCreateUpdateArea> createState() =>
      _CustomDialogCreateUpdateAreaState();
}

class _CustomDialogCreateUpdateAreaState
    extends State<CustomDialogCreateUpdateArea> {
  var isActive = true;

  late final bool isUpdate; // Declare isUpdate here
  @override
  void initState() {
    super.initState();
    isUpdate =
        widget.isUpdate; // Initialize isUpdate with the value from the widget
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController areaNameController = TextEditingController();

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Góc bo tròn
      ),
      elevation: 5, // Độ nâng của bóng đổ
      backgroundColor: backgroundColor,
      child: Container(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'KHU VỰC',
                style: textStylePrimaryBold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  border: Border.all(width: 0.05, color: Colors.grey),
                  borderRadius: const BorderRadius.all(Radius.circular(5))),
              margin: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                controller: areaNameController,
                style: const TextStyle(color: textColor),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  label: Text("Tên khu vực ...", style: textStylePlaceholder),
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              leading: Theme(
                data: ThemeData(unselectedWidgetColor: primaryColor),
                child: Checkbox(
                  value: isActive,
                  onChanged: (bool? value) {
                    setState(() {
                      isActive = value!;
                    });
                  },
                  activeColor: primaryColor,
                ),
              ),
              title: const Text(
                "Đang hoạt động",
                style: textStylePriceBold16,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
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
                        borderRadius: BorderRadius.all(Radius.circular(5)),
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
                    onTap: () => {},
                    child: Container(
                      height: 50,
                      width: 136,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: primaryColor,
                      ),
                      child: Center(
                        child: isUpdate == true
                            ? const Text(
                                'CẬP NHẬT',
                                style: textStyleWhiteBold20,
                              )
                            : const Text(
                                'THÊM',
                                style: textStyleWhiteBold20,
                              ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
