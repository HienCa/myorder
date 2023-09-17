import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/models/area.dart';

class OptionArea extends StatefulWidget {
  final Function(String) onOptionSelected; // Callback function

  const OptionArea({Key? key, required this.onOptionSelected})
      : super(key: key);

  @override
  _OptionAreaState createState() => _OptionAreaState();
}

class _OptionAreaState extends State<OptionArea> {
  List<Area> areaList = [];
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    
    // Khởi tạo lắng nghe dữ liệu realtime từ Firebase Firestore
    FirebaseFirestore.instance
        .collection('areas')
        .where('active', isEqualTo: 1)
        .snapshots()
        .listen((snapshot) {
      List<Area> areas = [];
      areas.add(Area(area_id: defaultArea, name: 'Tất cả khu vực', active: 1)); // thêm một phần tử tất cả để gọi all
      for (final doc in snapshot.docs) {
        final unit = Area.fromSnap(doc);
        areas.add(unit);
      }
      setState(() {
        areaList = areas;
      });
    });
  }

  // Example function to trigger the callback
  void _optionSelected(String selectedValue) {
    widget.onOptionSelected(selectedValue); // Gọi callback và truyền giá trị
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
      height: 35,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: areaList.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            setState(() {
              selectedIndex = index;
              _optionSelected(areaList[index].area_id);
            });
          },
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(
              left: kDefaultPadding,
              // At end item it adds extra 20 right padding
              right: index == areaList.length - 1 ? kDefaultPadding : 0,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                color: index == selectedIndex ? kBlueColor : textWhiteColor,
                borderRadius: BorderRadius.circular(20),
                border: index == selectedIndex
                    ? Border.all(width: 5, color: borderColorPrimary)
                    : Border.all(width: 1, color: borderColorPrimary)),
            child: Text(
              areaList[index].name,
              style: index == selectedIndex
                  ? const TextStyle(
                      color: textWhiteColor, fontWeight: FontWeight.bold)
                  : const TextStyle(
                      color: primaryColor, fontWeight: FontWeight.normal),
            ),
          ),
        ),
      ),
    );
  }
}
