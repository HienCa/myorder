// ignore_for_file: non_constant_identifier_names, avoid_print, prefer_interpolation_to_compose_strings, constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/views/screens/area/option_area.dart';
import 'package:myorder/views/screens/managements/dashboard/booking/table_item_booking.dart';

class ManagementQuantityFood extends StatefulWidget {
  const ManagementQuantityFood({
    Key? key,
  }) : super(key: key);

  @override
  State<ManagementQuantityFood> createState() => _ManagementQuantityFoodState();
}

class _ManagementQuantityFoodState extends State<ManagementQuantityFood> {
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
    return Scaffold(
      body: Theme(
        data: ThemeData(unselectedWidgetColor: primaryColor),
        child: Column(
          children: [
            Container(
                color: primaryColor,
                height: 50,
                child: const Center(
                    child:
                        Text("QUẢN LÝ SỐ LƯỢNG MÓN", style: textStyleWhiteBold16))),
            marginTop5,
            
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.only(left: 16),
                    margin: const EdgeInsets.only(right: 8, left: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.4),
                      borderRadius: borderRadiusTextField30,
                      border: Border.all(width: 1, color: borderColorPrimary),
                    ),
                    child: TextField(
                      controller: searchSlotTableTextEditingController,
                      onChanged: (value) {
                        print(value);
                        setState(() {});
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
                ),
                Expanded(
                  child: SizedBox(
                    child: OptionArea(
                      onOptionSelected: (selectedValue) {
                        print('Received value from OptionArea: $selectedValue');
                        setState(() {
                          areaIdSelected = selectedValue;
                        });
                      },
                    ),
                  ),
                )
              ],
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
                  keySearch: searchSlotTableTextEditingController.text,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
