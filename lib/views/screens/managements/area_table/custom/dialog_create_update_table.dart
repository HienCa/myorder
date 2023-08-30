import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:myorder/constants.dart';

class CustomDialogCreateUpdateTable extends StatefulWidget {
  final bool isUpdate;

  const CustomDialogCreateUpdateTable({Key? key, required this.isUpdate})
      : super(key: key);

  @override
  State<CustomDialogCreateUpdateTable> createState() =>
      _CustomDialogDecreasePriceState();
}

class _CustomDialogDecreasePriceState
    extends State<CustomDialogCreateUpdateTable> {
  late final bool isUpdate;
  var isActive = true;

  @override
  void initState() {
    super.initState();
    isUpdate = widget.isUpdate;
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController decreasePrice = TextEditingController();

    final TextEditingController textEditingController =
        TextEditingController(text: "");
    final List<String> items = ['Khu A', 'Khu B', 'Khu C', 'Khu D'];
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
                'CẬP NHẬT THÔNG TIN BÀN',
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
                  border: Border.all(width: 0.5, color: Colors.grey),
                  borderRadius: const BorderRadius.all(Radius.circular(5))),
              margin: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                controller: decreasePrice,
                style: const TextStyle(color: textColor),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  label: Text("Tên bàn ...",
                      style: textStylePlaceholder),
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.w300, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Colors.grey),
                  borderRadius: const BorderRadius.all(Radius.circular(5))),
              margin: const EdgeInsets.symmetric(horizontal: 12),
              child: TypeAheadField<String>(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: textEditingController,
                  decoration: InputDecoration(
                    labelText: textEditingController.text.isEmpty
                        ? 'Chọn khu vực'
                        : "",
                    border: const OutlineInputBorder(),
                    labelStyle: const TextStyle(color: tableemptyColor),
                  ),
                  style: const TextStyle(color: textColor),
                ),
                suggestionsCallback: (pattern) async {
                  return items.where((item) =>
                      item.toLowerCase().contains(pattern.toLowerCase()));
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(
                      suggestion,
                    ),
                  );
                },
                onSuggestionSelected: (suggestion) {
                  setState(() {
                    textEditingController.text =
                        suggestion; // Set the input value
                  });
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 30,
              child: ListTile(
                leading: const Text('Số khách:'),
                title: TextField(
                  controller: decreasePrice,
                  style: const TextStyle(color: textColor),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 0.2),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                  
                    hintStyle: TextStyle(
                         color: Colors.grey),
                  ),
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
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
