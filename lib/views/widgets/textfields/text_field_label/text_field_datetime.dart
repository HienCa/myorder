// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/constants/app_constants.dart';
import 'package:myorder/utils.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

class MyTextFieldDateTime extends StatefulWidget {
  final TextEditingController textEditingController;
  final double height;
  final String lable;
  final String placeholder;
  final bool isRequire;
  final DateTime greaterThanDatetime;

  const MyTextFieldDateTime({
    super.key,
    required this.textEditingController,
    required this.placeholder,
    required this.height,
    required this.isRequire,
    required this.lable,
    required this.greaterThanDatetime, 
  });

  @override
  State<MyTextFieldDateTime> createState() => _MyTextFieldDateTimeState();
}

class _MyTextFieldDateTimeState extends State<MyTextFieldDateTime> {
  final dateTextEditingController = TextEditingController();
  var timeString = 'dd/MM/yyyy';

  Future<void> selectDateTime(BuildContext context) async {
    if (widget.greaterThanDatetime.toString() != "") {
      final DateTime currentDate = widget.greaterThanDatetime;

      final TimeOfDay currentTime = TimeOfDay.fromDateTime(currentDate);
      final DateTime pickedDate = (await showDatePicker(
            context: context,
            initialDate: currentDate,
            firstDate: currentDate,
            lastDate: DateTime(
                2200), // You can adjust this to a suitable maximum date.
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
          Utils.showStylishDialog(
              context,
              'THÔNG BÁO',
              'Thời gian phải lớn hơn ${Utils.formatDatetime(currentDate)}.',
              StylishDialogType.ERROR);
        });
      }
    } else {
      setState(() {
        Utils.showStylishDialog(context, 'THÔNG BÁO', 'Thời gian phải lớn hơn.',
            StylishDialogType.ERROR);
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
        Padding(
          padding: const EdgeInsets.all(4),
          child: Row(
            children: [
              Text(
                widget.lable,
                style: textStyleLabel16,
              ),
              marginRight10,
              widget.isRequire
                  ? const Text(
                      '(*)',
                      style: textStyleErrorInput,
                    )
                  : const Text('')
            ],
          ),
        ),
        Container(
          height: widget.height,
          padding: paddingLeftRight8,
          decoration: BoxDecoration(
              borderRadius: borderContainer8,
              border: Border.all(color: borderColor, width: 1)),
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  controller: dateTextEditingController,
                  style: Utils.isLandscapeOrientation(context)
                      ? textStyleInputLandscape
                      : textStyleInput,
                  readOnly: true,
                  enableInteractiveSelection: true,
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
