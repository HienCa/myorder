import 'package:flutter/material.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/views/screens/managements/area_table/custom/dialog_create_update_area.dart';
import 'package:responsive_grid/responsive_grid.dart';

class ManagementAreaPage extends StatelessWidget {
  const ManagementAreaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: ResponsiveGridList(
              desiredItemWidth: 100,
              minSpacing: 10,
              children: List.generate(50, (index) => index + 1).map((i) {
                return InkWell(
                  onTap: () => {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const CustomDialogCreateUpdateArea(isUpdate: true,); // Hiển thị hộp thoại tùy chỉnh
                      },
                    )
                  },
                  child: Container(
                    height: 100,
                    alignment: const Alignment(0, 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: primaryColor,
                    ),
                    child: Text(i.toString(), style: textStyleWhiteBold20),
                  ),
                );
              }).toList()),
        ),
        const SizedBox(height: 10,),
        InkWell(
          onTap: () => {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return const CustomDialogCreateUpdateArea(isUpdate: false,); // Hiển thị hộp thoại tùy chỉnh
              },
            )
          },
          child: Container(
            height: 50,
            margin:
                const EdgeInsets.only(left: 10, right: 10, top: 10),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Text(
                "THÊM KHU VỰC",
                style: textStyleWhiteBold20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
