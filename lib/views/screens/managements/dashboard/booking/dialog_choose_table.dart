// ignore_for_file: non_constant_identifier_names, avoid_print, prefer_interpolation_to_compose_strings, constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/views/screens/area/option_area.dart';
import 'package:myorder/views/screens/managements/dashboard/booking/table_item_booking.dart';

class MyDialogChooseTable extends StatefulWidget {
  const MyDialogChooseTable({
    Key? key,
  }) : super(key: key);

  @override
  State<MyDialogChooseTable> createState() => _MyDialogChooseTableState();
}

class _MyDialogChooseTableState extends State<MyDialogChooseTable> {
  var areaIdSelected = defaultArea; // mặc định lấy tất cả danh sách
  final searchSlotTableTextEditingController = TextEditingController();
  String keySearch = "";
  int categoryCodeSelected = 0;
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
          children: [
            //THÊM TÌM KIẾM THEO SỐ LƯỢNG NGƯỜI
            OptionArea(
              onOptionSelected: (selectedValue) {
                print('Received value from OptionArea: $selectedValue');
                setState(() {
                  areaIdSelected = selectedValue;
                });
              },
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                decoration: const BoxDecoration(
                  color: secondColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: TableItemBooking(
                  areaIdSelected: areaIdSelected,
                  slot: (int.tryParse(
                          searchSlotTableTextEditingController.text) ??
                      1), 
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
