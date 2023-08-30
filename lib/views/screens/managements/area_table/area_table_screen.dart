import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/views/screens/managements/area_table/area_screen.dart';
import 'package:myorder/views/screens/managements/area_table/table_screen.dart';

class ManagementAreaTablePage extends StatefulWidget {
  const ManagementAreaTablePage({Key? key}) : super(key: key);

  @override
  State<ManagementAreaTablePage> createState() =>
      _ManagementAreaTablePageState();
}

class _ManagementAreaTablePageState extends State<ManagementAreaTablePage> {
  TextStyle headingStyle = const TextStyle(
      fontSize: 16, fontWeight: FontWeight.w600, color: primaryColor);

  bool lockAppSwitchVal = true;
  bool fingerprintSwitchVal = false;
  bool changePassSwitchVal = true;

  TextStyle headingStyleIOS = const TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 16,
    color: CupertinoColors.inactiveGray,
  );
  TextStyle descStyleIOS = const TextStyle(color: CupertinoColors.inactiveGray);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: primaryColor,
            secondary: primaryColor,
          ),
        ),
        home: const AreaTableTab());
  }
}

class AreaTableTab extends StatelessWidget {
  const AreaTableTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            leading: InkWell(
                onTap: () => {Navigator.pop(context)},
                child: const Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: Colors.white,
                )),
            bottom: const TabBar(
              tabs: [
                Tab(
                  text: "QUẢN LÝ KHU VỰC",
                ),
                Tab(
                  text: "QUẢN LÝ BÀN",
                ),
              ],
            ),
            title: const Text('QUẢN LÝ KHU VỰC / BÀN'),
          ),
          body: TabBarView(
            children: [
              Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: const ManagementAreaPage()),
              Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: const ManagementTablePage()),
            ],
          ),
        ));
  }
}
