import 'package:flutter/material.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/views/screens/home/chart/pie_chart_sample3.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
      child: Column(
        children: [
          //ĐƠN HÀNG HÔM NAY
          const SizedBox(
            height: 40,
            child: ListTile(
              leading: Icon(
                Icons.bookmark,
                color: iconColor,
              ),
              title: Text("ĐƠN HÀNG HÔM NAY", style: textStyleTitleGrayBold20),
            ),
          ),
          const ListTile(
            title: Text("Đã thanh toán", style: textStyleTitleGrayRegular16),
            trailing: Text("0", style: textStyleTrailingSuccessRegular16),
          ),
          const ListTile(
            title: Text("Đang phục vụ", style: textStyleTitleGrayRegular16),
            trailing: Text("0", style: textStyleTrailingPrimaryRegular16),
          ),
          Container(
            height: 10,
            decoration:
                const BoxDecoration(color: Color.fromARGB(255, 248, 246, 246)),
          ),

          //TIỀN THU TRONG NGÀY
          const SizedBox(
            height: 40,
            child: ListTile(
              leading: Icon(
                Icons.bookmark,
                color: iconColor,
              ),
              title:
                  Text("TIỀN THU TRONG NGÀY", style: textStyleTitleGrayBold20),
            ),
          ),
          const ListTile(
            title: Text("Tiền mặt", style: textStyleTitleGrayRegular16),
            trailing: Text("0", style: textStyleTrailingPrimaryRegular16),
          ),
          const ListTile(
            title: Text("Thẻ", style: textStyleTitleGrayRegular16),
            trailing: Text("0", style: textStyleTrailingPrimaryRegular16),
          ),
          const ListTile(
            title: Text("Chuyển khoản", style: textStyleTitleGrayRegular16),
            trailing: Text("0", style: textStyleTrailingPrimaryRegular16),
          ),
          const ListTile(
            title: Text("Sử dụng điểm", style: textStyleTitleGrayRegular16),
            trailing: Text("0", style: textStyleTrailingPrimaryRegular16),
          ),
          const ListTile(
            title: Text("Bán hàng", style: textStyleTitleGrayRegular16),
            trailing: Text("0", style: textStyleTrailingPrimaryRegular16),
          ),
          const ListTile(
            title: Text("Đặt cọc", style: textStyleTitleGrayRegular16),
            trailing: Text("0", style: textStyleTrailingPrimaryRegular16),
          ),
          Container(
            height: 10,
            decoration:
                const BoxDecoration(color: Color.fromARGB(255, 248, 246, 246)),
          ),

          //DOANH THU TẠM TÍNH HÔM NAY
           const SizedBox(
            height: 40,
            child: ListTile(
              leading: Icon(
                Icons.bookmark,
                color: iconColor,
              ),
              title: Text("DOANH THU TẠM TÍNH HÔM NAY",
                  style: textStyleTitleGrayBold20),
            ),
          ),
          const ListTile(
            title: Text("Đã thanh toán", style: textStyleTitleGrayRegular16),
            trailing: Text("0", style: textStyleTrailingSuccessRegular16),
          ),
          const ListTile(
            title: Text("Đang phục vụ", style: textStyleTitleGrayRegular16),
            trailing: Text("0", style: textStyleTrailingPrimaryRegular16),
          ),
          //line char
          Container(
            height: 10,
            decoration:
                const BoxDecoration(color: Color.fromARGB(255, 248, 246, 246)),
          ),

          //DOANH THU HÔM QUA
           const SizedBox(
            height: 60,
            child: ListTile(
              leading: Icon(
                Icons.bookmark,
                color: iconColor,
              ),
              title: Text("DOANH THU HÔM QUA", style: textStyleTitleGrayBold20),
              subtitle: Text("0", style: textStyleSubTitleGrayRegular16),
            ),
          ),

          //line char
          Container(
            height: 10,
            decoration:
                const BoxDecoration(color: Color.fromARGB(255, 248, 246, 246)),
          ),

          //DOANH THU TUẦN NÀY
           const SizedBox(
            height: 60,
            child: ListTile(
              leading: Icon(
                Icons.bookmark,
                color: iconColor,
              ),
              title: Text("DOANH THU TUẦN NÀY", style: textStyleTitleGrayBold20),
              subtitle: Text("0", style: textStyleSubTitleGrayRegular16),
            ),
          ),
          
          //line char
          Container(
            height: 10,
            decoration:
                const BoxDecoration(color: Color.fromARGB(255, 248, 246, 246)),
          ),

          //DOANH THU THÁNG NÀY
           const SizedBox(
            height: 60,
            child: ListTile(
              leading: Icon(
                Icons.bookmark,
                color: iconColor,
              ),
              title: Text("DOANH THU THÁNG NÀY", style: textStyleTitleGrayBold20),
              subtitle: Text("0", style: textStyleSubTitleGrayRegular16),
            ),
          ),
          
          //line char
          Container(
            height: 10,
            decoration:
                const BoxDecoration(color: Color.fromARGB(255, 248, 246, 246)),
          ),

          //DOANH THU 3 THÁNG GẦN NHẤT
           const SizedBox(
            height: 60,
            child: ListTile(
              leading: Icon(
                Icons.bookmark,
                color: iconColor,
              ),
              title: Text("DOANH THU 3 THÁNG GẦN NHẤT", style: textStyleTitleGrayBold20),
              subtitle: Text("0", style: textStyleSubTitleGrayRegular16),
            ),
          ),
          
          //line char
          Container(
            height: 10,
            decoration:
                const BoxDecoration(color: Color.fromARGB(255, 248, 246, 246)),
          ),

          //DOANH THU NĂM NAY
           const SizedBox(
            height: 60,
            child: ListTile(
              leading: Icon(
                Icons.bookmark,
                color: iconColor,
              ),
              title: Text("DOANH THU NĂM NAY", style: textStyleTitleGrayBold20),
              subtitle: Text("0", style: textStyleSubTitleGrayRegular16),
            ),
          ),
          
          //line char
          Container(
            height: 10,
            decoration:
                const BoxDecoration(color: Color.fromARGB(255, 248, 246, 246)),
          ),

           //CHỌN LỊCH BÁO CÁO DOANH THU - CHI PHÍ - LỢI NHUẬN
           const SizedBox(
            // height: 240,
            height: 640,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.bookmark,
                    color: iconColor,
                  ),
                  title: Text("DOANH THU - CHI PHÍ - LỢI NHUẬN", style: textStyleTitleGrayBold20),
                  subtitle: Text("100,000,000", style: textStyleSubTitleGrayRegular16),
                ),
                ListTile(
                 
                  title: Text("Doanh thu", style: textStyleTrailingPrimaryRegular16),
                  trailing: Text("999,000,000", style: textStyleTrailingPrimaryRegular16),
                ),
                ListTile(
                 
                  title: Text("Chi phí", style: textStyleTrailingCostRegular16),
                  trailing: Text("100,000,000", style: textStyleTrailingCostRegular16),
                ),
                ListTile(
                 
                  title: Text("Lợi nhuận", style: textStyleTrailingProfitRegular16),
                  trailing: Text("800,000,000", style: textStyleTrailingProfitRegular16),
                ),
                PieChartSample3()
              ],
            ),
          ),
          
          //line char
          Container(
            height: 10,
            decoration:
                const BoxDecoration(color: Color.fromARGB(255, 248, 246, 246)),
          ),
        ],
      ),
    ));
  }
}