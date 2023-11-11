// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/constants/app_constants.dart';
import 'package:myorder/utils.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

class MyTextFieldIconDateTime extends StatefulWidget {
  final TextEditingController textEditingController;
  final double height;
  final String placeholder;
  final bool isBorder;

  const MyTextFieldIconDateTime({
    super.key,
    required this.textEditingController,
    required this.placeholder,
    required this.height,
    required this.isBorder,
  });

  @override
  State<MyTextFieldIconDateTime> createState() =>
      _MyTextFieldIconDateTimeState();
}

class _MyTextFieldIconDateTimeState extends State<MyTextFieldIconDateTime> {
  final dateTextEditingController = TextEditingController();
  var timeString = 'dd/MM/yyyy';

  Future<void> selectDateTime(BuildContext context) async {
    final DateTime currentDate = DateTime.now();
    final TimeOfDay currentTime = TimeOfDay.fromDateTime(currentDate);
    final DateTime pickedDate = (await showDatePicker(
          context: context,
          initialDate: currentDate,
          firstDate: currentDate,
          lastDate:
              DateTime(2200), // You can adjust this to a suitable maximum date.
        )) ??
        currentDate;

    final TimeOfDay pickedTime = (await showTimePicker(
          context: context,
          initialTime:
              TimeOfDay(hour: currentTime.hour, minute: currentTime.minute),
        )) ??
        TimeOfDay(hour: currentTime.hour, minute: currentTime.minute);

    final DateTime pickedDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    if (pickedDateTime.isAfter(currentDate)) {
      setState(() {
        //Giá trị cần lưu db
        widget.textEditingController.text = pickedDateTime.toString();
        print(widget.textEditingController.text);
        //Giá trị hiển thị
        dateTextEditingController.text =
            "${pickedDateTime.day.toString().padLeft(2, '0')}/${pickedDateTime.month.toString().padLeft(2, '0')}/${pickedDateTime.year} ${pickedTime.format(context)}";
      });
    } else {
      setState(() {
        Utils.showStylishDialog(context, 'THÔNG BÁO',
            'Thời gian phải lớn hơn hiện tại.', StylishDialogType.ERROR);
      });
    }
  }

  bool isInValid = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: widget.height,
          padding: Utils.isLandscapeOrientation(context)
              ? paddingLeftRight4
              : paddingLeftRight8,
          decoration: widget.isBorder == true
              ? BoxDecoration(
                  borderRadius: borderContainer8,
                  border: Border.all(color: borderColor, width: 1))
              : null,
          width: MediaQuery.of(context).size.width,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(FontAwesomeIcons.calendarDays,
                  color: iconColor,
                  size: Utils.isLandscapeOrientation(context) ? 10 : 16),
              marginRight5,
              Expanded(
                child: TextField(
                  controller: dateTextEditingController,
                  style: Utils.isLandscapeOrientation(context)
                      ? textStyleInputLandscape
                      : textStyleInput,
                  readOnly: true,
                  onTap: () {
                    selectDateTime(context);
                  },
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(
                    isDense: true,
                    labelStyle: Utils.isLandscapeOrientation(context)
                        ? textStyleInputLandscape
                        : textStyleInput,
                    hintText: widget.placeholder,
                    hintStyle: const TextStyle(color: Colors.grey),
                    suffixIcon: const Icon(Icons.calendar_today),
                    border: InputBorder.none,
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
