import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/area/areas_controller.dart';
import 'package:myorder/views/screens/managements/area_table/custom/dialog_create_update_area.dart';
import 'package:responsive_grid/responsive_grid.dart';

class ManagementOtherDetailPage extends StatefulWidget {
  const ManagementOtherDetailPage({super.key});

  @override
  State<ManagementOtherDetailPage> createState() => _ManagementOtherDetailPageState();
}

class _ManagementOtherDetailPageState extends State<ManagementOtherDetailPage> {
  AreaController areaController = Get.put(AreaController());
  @override
  void initState() {
    super.initState();
    areaController.getAreas("");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: 50,
          width: 400,
          margin: const EdgeInsets.all(kDefaultPadding),
          padding: const EdgeInsets.symmetric(
            horizontal: kDefaultPadding,
            vertical: kDefaultPadding / 4, // 5 top and bottom
          ),
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.4),
              borderRadius: borderRadiusTextField30,
              border: Border.all(width: 1, color: borderColorPrimary)),
          child: TextField(
            onChanged: (value) {
              areaController.getAreas(value);
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
              hintText: 'Tìm kiếm khu vực ...',
              hintStyle: TextStyle(color: borderColorPrimary),
            ),
            cursorColor: borderColorPrimary,
          ),
        ),
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
