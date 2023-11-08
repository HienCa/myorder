import 'package:flutter/material.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/constants/app_constants.dart';

class DashboardTakeAway extends StatefulWidget {
  const DashboardTakeAway({super.key});

  @override
  State<DashboardTakeAway> createState() => _DashboardTakeAwayState();
}

class _DashboardTakeAwayState extends State<DashboardTakeAway> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                  child: Container(
                decoration: const BoxDecoration(
                  borderRadius: borderContainer8,
                  color: backgroundColor,
                ),
                child: Column(
                  children: [
                    const TabBar(
                      indicator: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: primaryColor,
                            width: 2.5,
                          ),
                        ),
                      ),
                      tabs: [
                        Tab(
                          child: Text(''),
                        ),
                        Tab(text: 'Tab 2'),
                        Tab(text: 'Tab 3'),
                      ],
                      labelColor: Colors.white,
                      indicatorColor: Colors.white,
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          Container(
                            color: Colors.green,
                            child: const Center(
                              child: Text('40% - Tab 1'),
                            ),
                          ),
                          Container(
                            color: Colors.orange,
                            child: const Center(
                              child: Text('40% - Tab 2'),
                            ),
                          ),
                          Container(
                            color: Colors.red,
                            child: const Center(
                              child: Text('40% - Tab 3'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      height: 40,
                      color: primaryColor,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        Container(
          height: 40,
          color: primaryColor,
        )
      ],
    );
  }
}
