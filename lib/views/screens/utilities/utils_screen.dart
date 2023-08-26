import 'package:flutter/material.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/views/screens/utilities/setting_screen.dart';

class UtilsPage extends StatelessWidget {
  const UtilsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      decoration: const BoxDecoration(
        color: backgroundColorGray,
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(color: backgroundColor),
            height: 90,
            child: InkWell(
              onTap: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsPage()))
              },
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    margin: const EdgeInsets.all(
                        5), // Tùy chỉnh margin để căn chỉnh
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/images/logo.jpg"),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      "Chủ nhà hàng",
                      style: textStyleBlackBold,
                    ),
                  ),
                  const Icon(Icons.settings, color: iconColorPrimary, size: 30),
                ],
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(color: backgroundColor),
            child: const Column(
              children: [
                ListTile(
                  leading: Text("Địa chỉ:", style: textStyleBlackRegular),
                  title: Text(
                      "số 05 / ấp 06 //Bình Mỹ / Củ Chi / Thành phố Hồ Chí Minh",
                      style: textStyleBlackRegular),
                ),
              ],
            ),
          ),
          marginTop10,
          Container(
            decoration: const BoxDecoration(color: backgroundColor),
            child: const Column(
              children: [
                ListTile(
                  leading: Icon(Icons.print, color: iconColor),
                  title: Text("Thiết lập máy in", style: textStyleBlackRegular),
                  trailing:
                      Icon(Icons.arrow_forward_ios_outlined, color: iconColor),
                ),
              ],
            ),
          ),
          marginTop10,
          Container(
            decoration: const BoxDecoration(color: backgroundColor),
            child: const Column(
              children: [
                ListTile(
                  leading: Icon(Icons.chair_alt, color: iconColor),
                  title: Text("Quản lý khu vực / bàn",
                      style: textStyleBlackRegular),
                  trailing:
                      Icon(Icons.arrow_forward_ios_outlined, color: iconColor),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.menu_book, color: iconColor),
                  title: Text("Quản lý thực đơn", style: textStyleBlackRegular),
                  trailing:
                      Icon(Icons.arrow_forward_ios_outlined, color: iconColor),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.receipt_long, color: iconColor),
                  title: Text("Quản lý hóa đơn", style: textStyleBlackRegular),
                  trailing:
                      Icon(Icons.arrow_forward_ios_outlined, color: iconColor),
                ),
              ],
            ),
          ),
          marginTop10,
          Container(
            decoration: const BoxDecoration(color: backgroundColor),
            child: const Column(
              children: [
                ListTile(
                  leading: Icon(Icons.bar_chart, color: iconColor),
                  title:
                      Text("Phân tích Doanh Thu", style: textStyleBlackRegular),
                  trailing:
                      Icon(Icons.arrow_forward_ios_outlined, color: iconColor),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.pie_chart, color: iconColor),
                  title:
                      Text("Thống kê Kinh Doanh", style: textStyleBlackRegular),
                  trailing:
                      Icon(Icons.arrow_forward_ios_outlined, color: iconColor),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.waterfall_chart, color: iconColor),
                  title:
                      Text("Báo cáo Kinh Doanh", style: textStyleBlackRegular),
                  trailing:
                      Icon(Icons.arrow_forward_ios_outlined, color: iconColor),
                ),
              ],
            ),
          ),
          marginTop30,
          InkWell(
            onTap: () => {authController.signOut()},
            child: Container(
              height: buttonHeight,
              width: MediaQuery.of(context).size.width * 0.9 ,
              decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: primaryColor),
              child: const Center(child: Text("ĐĂNG XUẤT", style:buttonStyleBlackBold)),
            ),
          )
        ],
      ),
    ));
  }
}
