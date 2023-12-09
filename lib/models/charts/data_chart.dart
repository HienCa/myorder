// ignore_for_file: non_constant_identifier_names

import 'package:myorder/views/screens/home/chart/bar_chart_sample7.dart';
import 'package:myorder/views/screens/home/chart/pie_chart_sample3.dart';

class DataChart {
  List<DataItemPieChart> listDataPieChart = [];
  List<BarData> listDataBarChartFood = [];
  List<BarData> listDataBarChartCategory = [];
  MyDataBarChart myDataBarChart;
  DataChart({
    required this.listDataPieChart,
    required this.listDataBarChartFood,
    required this.listDataBarChartCategory,
    required this.myDataBarChart,
  });
}

class GroupDataBartChart {
  int x;
  double y1;
  double? y2 = 0;
  GroupDataBartChart({
    required this.x,
    required this.y1,
    this.y2,
  });
}

class MyDataBarChart {
  String title;
  List<double> left_titles;
  List<String> bottom_titles;
  List<String>? right_titles;
  List<double> values;

  MyDataBarChart({
    required this.title,
    required this.left_titles,
    required this.bottom_titles,
    required this.values,
    this.right_titles,
  });
  MyDataBarChart.empty()
      : title = "",
        left_titles = [],
        bottom_titles = [],
        right_titles = [],
        values = [];
}
