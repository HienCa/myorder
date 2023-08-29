import 'package:flutter/material.dart';
import 'package:myorder/constants.dart';
import 'package:responsive_grid/responsive_grid.dart';

class TableItem extends StatelessWidget {
  const TableItem({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveGridList(
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
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipOval(
                    child: Image.asset(
                      "assets/images/icon-table-simple-empty.jpg",
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const Text(
                    "A2",
                    style: TextStyle(fontSize: 30, color: textWhiteColor, fontWeight:FontWeight.bold),
                  ),
                ],
              ));
        }).toList());
  }
}
