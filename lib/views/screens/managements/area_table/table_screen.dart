import 'package:flutter/material.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/views/screens/managements/area_table/custom/dialog_create_update_table.dart';
import 'package:responsive_grid/responsive_grid.dart';

class ManagementTablePage extends StatelessWidget {
  const ManagementTablePage({super.key});

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
                return Container(
                    height: 100,
                    alignment: const Alignment(0, 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.transparent,
                    ),
                    child: InkWell(
                      onTap: () => {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const CustomDialogCreateUpdateTable(isUpdate: true,); // Hiển thị hộp thoại tùy chỉnh
                          },
                        )
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipOval(
                            child: Image.asset(
                              "assets/images/icon-table-simple-serving.jpg",
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const Text(
                            "A2",
                            style: TextStyle(
                                fontSize: 30,
                                color: textWhiteColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ));
              }).toList()),
        ),
        const SizedBox(height: 10,),
        InkWell(
          onTap: () => {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return const CustomDialogCreateUpdateTable(isUpdate: false,);
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
                "THÊM BÀN",
                style: textStyleWhiteBold20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
