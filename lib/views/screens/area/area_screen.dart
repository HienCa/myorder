// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/views/screens/area/describe_table.dart';
import 'package:myorder/views/screens/area/option_area.dart';
import 'package:myorder/views/screens/area/table_item.dart';

class AreaPage extends StatefulWidget {
  const AreaPage({super.key});

  @override
  State<AreaPage> createState() => _AreaPageState();
}

class _AreaPageState extends State<AreaPage> {
  var areaIdSelected = defaultArea; // mặc định lấy tất cả danh sách 
  @override
  Widget build(BuildContext context) {
    print(areaIdSelected);
    return SafeArea(
      bottom: false,
      child: Column(
        children: <Widget>[
          marginTop10,
          OptionArea(
            onOptionSelected: (selectedValue) {
              // Xử lý giá trị trả về từ OptionArea tại đây
              print('Đã nhận được giá trị từ OptionArea: $selectedValue');
              setState(() {
                areaIdSelected = selectedValue;
              });
            },
          ),
          const DescribeTable(),
          Expanded(
            child: Stack(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  decoration: const BoxDecoration(
                    color: kBackgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                ),
                TableItem(
                  areaIdSelected: areaIdSelected,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
