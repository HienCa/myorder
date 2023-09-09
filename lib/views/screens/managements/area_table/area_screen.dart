import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/area/areas_controller.dart';
import 'package:myorder/views/screens/managements/area_table/custom/dialog_create_update_area.dart';
import 'package:responsive_grid/responsive_grid.dart';

class ManagementAreaPage extends StatefulWidget {
  const ManagementAreaPage({super.key});

  @override
  State<ManagementAreaPage> createState() => _ManagementAreaPageState();
}

class _ManagementAreaPageState extends State<ManagementAreaPage> {
  AreaController areaController = Get.put(AreaController());

  @override
  Widget build(BuildContext context) {
    areaController.getAreas();
    print("reloaded......");
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: ResponsiveGridList(
              desiredItemWidth: 100,
              minSpacing: 10,
              children:
                  List.generate(areaController.areas.length, (index) => index)
                      .map((i) {
                return InkWell(
                  onTap: () => {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CustomDialogCreateUpdateArea(
                          isUpdate: true,
                          area_id: areaController.areas[i].area_id,
                          name: areaController.areas[i].name,
                          active: areaController.areas[i].active,
                        );
                      },
                    )
                  },
                  child: Container(
                    height: 100,
                    alignment: const Alignment(0, 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: areaController.areas[i].active == ACTIVE
                          ? activeColor
                          : deActiveColor,
                    ),
                    child: Text(areaController.areas[i].name,
                        style: textStyleWhiteBold20),
                  ),
                );
              }).toList()),
        ),
        const SizedBox(
          height: 10,
        ),
        InkWell(
          onTap: () => {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return const CustomDialogCreateUpdateArea(
                  isUpdate: false,
                );
              },
            )
          },
          child: Container(
            height: 50,
            margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Text(
                "+ THÊM KHU VỰC",
                style: textStyleWhiteBold20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
