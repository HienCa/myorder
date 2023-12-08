import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:myorder/models/report.dart';
import 'package:myorder/views/screens/home/chart/color_of_charts/app_colors.dart';

class PieChartExample extends StatefulWidget {
  final List<Report> report;
  final String title;
  const PieChartExample({super.key, required this.report, required this.title});

  @override
  State<StatefulWidget> createState() => _PieChartExampleState();
}

class _PieChartExampleState extends State {
  int touchedIndex = -1;

  List<PieChartSectionData> showingSections() {
    // Các phần tử trong danh sách số liệu của bạn
    List<Map<String, dynamic>> data = [
      {
        'color': AppColors.contentColorBlue,
        'value': 40,
        'title': '40%',
        'icon': 'assets/icons/ophthalmology-svgrepo-com.svg'
      },
      {
        'color': AppColors.contentColorYellow,
        'value': 30,
        'title': '30%',
        'icon': 'assets/icons/librarian-svgrepo-com.svg'
      },
      {
        'color': AppColors.contentColorPurple,
        'value': 16,
        'title': '16%',
        'icon': 'assets/icons/fitness-svgrepo-com.svg'
      },
      {
        'color': AppColors.contentColorGreen,
        'value': 15,
        'title': '15%',
        'icon': 'assets/icons/worker-svgrepo-com.svg'
      },
    ];

    return List.generate(data.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 110.0 : 100.0;
      final widgetSize = isTouched ? 55.0 : 40.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      return PieChartSectionData(
        color: data[i]['color'],
        value: data[i]['value'].toDouble(),
        title: data[i]['title'],
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: const Color(0xffffffff),
          shadows: shadows,
        ),
        badgeWidget: _Badge(
          data[i]['icon'],
          size: widgetSize,
          borderColor: AppColors.contentColorBlack,
        ),
        badgePositionPercentageOffset: .98,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pie Chart Example'),
      ),
      body: AspectRatio(
        aspectRatio: 1.3,
        child: PieChart(
          PieChartData(
            // pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
            //   setState(() {
            //     final desiredTouch = pieTouchResponse.touchInput is! PointerExitEvent;
            //     touchedIndex = desiredTouch ? pieTouchResponse.touchedSectionIndex : -1;
            //   });
            // }),
            borderData: FlBorderData(
              show: false,
            ),
            sectionsSpace: 0,
            centerSpaceRadius: 40,
            sections: showingSections(),
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String iconPath;
  final double size;
  final Color borderColor;

  const _Badge(this.iconPath,
      {Key? key, required this.size, required this.borderColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: borderColor, width: 2),
        ),
        child: Center(
          child: Image.asset(
            iconPath,
            width: size / 2,
            height: size / 2,
          ),
        ),
      ),
    );
  }
}
