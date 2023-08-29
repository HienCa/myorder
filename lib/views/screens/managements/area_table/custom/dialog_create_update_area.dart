import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:myorder/constants.dart';

class CustomDialogCreateUpdateArea extends StatefulWidget {
  const CustomDialogCreateUpdateArea({super.key});

  @override
  State<CustomDialogCreateUpdateArea> createState() =>
      _CustomDialogDecreasePriceState();
}

class _CustomDialogDecreasePriceState extends State<CustomDialogCreateUpdateArea> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController decreasePrice = TextEditingController();

    final TextEditingController textEditingController = TextEditingController(text: "");
    final List<String> items = [
      'Khách quen',
      'Ngày khuyến mãi',
      'Hóa đơn trên 5 triệu',
      'Khác'
    ];
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
                'CẬP NHẬT KHU VỰC',
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
                  label: Text("Vui lòng nhập % muốn giảm ...",
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
                    labelText: textEditingController.text.isEmpty ? 'Vui lòng chọn khuyến mãi' : "",

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
                    title: Text(suggestion,),
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
                      child: const Center(
                        child: Text(
                          'XÁC NHẬN',
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
