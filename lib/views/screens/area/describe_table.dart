// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:myorder/constants.dart';

class DescribeTable extends StatefulWidget {
  const DescribeTable({super.key});

  @override
  _DescribeTableState createState() => _DescribeTableState();
}

class _DescribeTableState extends State<DescribeTable> {

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
        height: 35,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(children: [
              ClipOval(
                child: Image.asset(
                  "assets/images/icon-table-simple-empty.jpg",
                  width: 20,
                  height: 20,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 5,),
              const Text("Bàn trống", style: TextStyle(color: Colors.grey),)
            ]),
            Row(children: [
              ClipOval(
                child: Image.asset(
                  "assets/images/icon-table-simple-serving.jpg",
                  width: 20,
                  height: 20,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 5,),
              const Text("Bàn phục vụ", style: TextStyle(color: primaryColor))
            ]),
            Row(children: [
              ClipOval(
                child: Image.asset(
                  "assets/images/icon-table-simple-booking.jpg",
                  width: 20,
                  height: 20,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 5,),
              const Text("Bàn đặt", style: TextStyle(color: Colors.green))
            ]),
            Row(children: [
              ClipOval(
                child: Image.asset(
                  "assets/images/icon-table-simple-cancel.jpg",
                  width: 20,
                  height: 20,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 5,),
              const Text("Bàn gộp", style: TextStyle(color: Colors.redAccent))
            ])
          ],
        ));
  }
}
