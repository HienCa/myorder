import 'package:flutter/material.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/views/screens/bill/bills_screen.dart';
import 'package:myorder/views/screens/managements/area_table/area_table_screen.dart';
import 'package:myorder/views/screens/managements/categories/categories_screen.dart';
import 'package:myorder/views/screens/managements/chef_bar/chef_bar_other_screen.dart';
import 'package:myorder/views/screens/managements/dashboard/dashboard_screen.dart';
import 'package:myorder/views/screens/managements/discounts/discounts_screen.dart';
import 'package:myorder/views/screens/managements/employees/employees_screen.dart';
import 'package:myorder/views/screens/managements/foods/foods_screen.dart';
import 'package:myorder/views/screens/managements/ingredients/ingredients_screen.dart';
import 'package:myorder/views/screens/managements/inventory/inventory_screen.dart';
import 'package:myorder/views/screens/managements/units/units_screen.dart';
import 'package:myorder/views/screens/managements/vats/vats_screen.dart';
import 'package:myorder/views/screens/quantity_foods_order/quantity_foods_order_screen.dart';
import 'package:myorder/views/screens/recipe/recipe_food_screen.dart';
import 'package:myorder/views/screens/utilities/setting_screen.dart';

class UtilsPage extends StatelessWidget {
  const UtilsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
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
                        const Icon(Icons.settings,
                            color: iconColorPrimary, size: 30),
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
                        title: Text("2001 / Bình Mỹ / Củ Chi / TP.HCM",
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
                        title: Text("Thiết lập máy in",
                            style: textStyleBlackRegular),
                        trailing: Icon(Icons.arrow_forward_ios_outlined,
                            color: iconColor),
                      ),
                    ],
                  ),
                ),
                marginTop10,
                Container(
                  decoration: const BoxDecoration(color: backgroundColor),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const InventoryScreen()))
                        },
                        child: const ListTile(
                          leading: Icon(Icons.ad_units, color: iconColor),
                          title:
                              Text("KHO", style: textStyleBlackRegular),
                          trailing: Icon(Icons.arrow_forward_ios_outlined,
                              color: iconColor),
                        ),
                      ),
                      InkWell(
                        onTap: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const RecipesScreen()))
                        },
                        child: const ListTile(
                          leading: Icon(Icons.ad_units, color: iconColor),
                          title:
                              Text("CÔNG THỨC", style: textStyleBlackRegular),
                          trailing: Icon(Icons.arrow_forward_ios_outlined,
                              color: iconColor),
                        ),
                      ),
                      InkWell(
                        onTap: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ManagementIngredientsPage()))
                        },
                        child: const ListTile(
                          leading: Icon(Icons.ad_units, color: iconColor),
                          title:
                              Text("NGUYÊN LIỆU", style: textStyleBlackRegular),
                          trailing: Icon(Icons.arrow_forward_ios_outlined,
                              color: iconColor),
                        ),
                      ),
                      InkWell(
                        onTap: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ManagementQuantityFoodOrderPage()))
                        },
                        child: const ListTile(
                          leading: Icon(Icons.ad_units, color: iconColor),
                          title: Text("SÓ LƯỢNG MÓN",
                              style: textStyleBlackRegular),
                          trailing: Icon(Icons.arrow_forward_ios_outlined,
                              color: iconColor),
                        ),
                      ),
                      InkWell(
                        onTap: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MyDashBoard()))
                        },
                        child: const ListTile(
                          leading: Icon(Icons.ad_units, color: iconColor),
                          title:
                              Text("DASH BOARD", style: textStyleBlackRegular),
                          trailing: Icon(Icons.arrow_forward_ios_outlined,
                              color: iconColor),
                        ),
                      ),
                      InkWell(
                        onTap: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ManagementChefBarOtherPage()))
                        },
                        child: const ListTile(
                          leading: Icon(Icons.ad_units, color: iconColor),
                          title: Text("BẾP/BAR", style: textStyleBlackRegular),
                          trailing: Icon(Icons.arrow_forward_ios_outlined,
                              color: iconColor),
                        ),
                      ),
                      InkWell(
                        onTap: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ManagementDiscountsPage()))
                        },
                        child: const ListTile(
                          leading: Icon(Icons.ad_units, color: iconColor),
                          title: Text("Quản lý giảm giá",
                              style: textStyleBlackRegular),
                          trailing: Icon(Icons.arrow_forward_ios_outlined,
                              color: iconColor),
                        ),
                      ),
                      InkWell(
                        onTap: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ManagementVatsPage()))
                        },
                        child: const ListTile(
                          leading: Icon(Icons.ad_units, color: iconColor),
                          title: Text("Quản lý vats",
                              style: textStyleBlackRegular),
                          trailing: Icon(Icons.arrow_forward_ios_outlined,
                              color: iconColor),
                        ),
                      ),
                      InkWell(
                        onTap: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ManagementCategoriesPage()))
                        },
                        child: const ListTile(
                          leading: Icon(Icons.ad_units, color: iconColor),
                          title: Text("Quản lý danh mục",
                              style: textStyleBlackRegular),
                          trailing: Icon(Icons.arrow_forward_ios_outlined,
                              color: iconColor),
                        ),
                      ),
                      InkWell(
                        onTap: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ManagementUnitsPage()))
                        },
                        child: const ListTile(
                          leading: Icon(Icons.ad_units, color: iconColor),
                          title: Text("Quản lý đơn vị",
                              style: textStyleBlackRegular),
                          trailing: Icon(Icons.arrow_forward_ios_outlined,
                              color: iconColor),
                        ),
                      ),
                      InkWell(
                        onTap: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ManagementEmployeesPage()))
                        },
                        child: const ListTile(
                          leading: Icon(Icons.people, color: iconColor),
                          title: Text("Quản lý nhân viên",
                              style: textStyleBlackRegular),
                          trailing: Icon(Icons.arrow_forward_ios_outlined,
                              color: iconColor),
                        ),
                      ),
                      InkWell(
                        onTap: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ManagementAreaTablePage()))
                        },
                        child: const ListTile(
                          leading: Icon(Icons.chair_alt, color: iconColor),
                          title: Text("Quản lý khu vực / bàn",
                              style: textStyleBlackRegular),
                          trailing: Icon(Icons.arrow_forward_ios_outlined,
                              color: iconColor),
                        ),
                      ),
                      InkWell(
                        onTap: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ManagementFoodsPage()))
                        },
                        child: const ListTile(
                          leading: Icon(Icons.menu_book, color: iconColor),
                          title: Text("Quản lý thực đơn",
                              style: textStyleBlackRegular),
                          trailing: Icon(Icons.arrow_forward_ios_outlined,
                              color: iconColor),
                        ),
                      ),
                      InkWell(
                        onTap: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const BillPage()))
                        },
                        child: const ListTile(
                          leading: Icon(Icons.receipt_long, color: iconColor),
                          title: Text("Quản lý hóa đơn",
                              style: textStyleBlackRegular),
                          trailing: Icon(Icons.arrow_forward_ios_outlined,
                              color: iconColor),
                        ),
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
                        title: Text("Phân tích Doanh Thu",
                            style: textStyleBlackRegular),
                        trailing: Icon(Icons.arrow_forward_ios_outlined,
                            color: iconColor),
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.pie_chart, color: iconColor),
                        title: Text("Thống kê Kinh Doanh",
                            style: textStyleBlackRegular),
                        trailing: Icon(Icons.arrow_forward_ios_outlined,
                            color: iconColor),
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.waterfall_chart, color: iconColor),
                        title: Text("Báo cáo Kinh Doanh",
                            style: textStyleBlackRegular),
                        trailing: Icon(Icons.arrow_forward_ios_outlined,
                            color: iconColor),
                      ),
                    ],
                  ),
                ),
                marginTop30,
                InkWell(
                  onTap: () => {authController.signOut()},
                  child: Container(
                    height: buttonHeight,
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: primaryColor),
                    child: const Center(
                        child: Text("ĐĂNG XUẤT", style: buttonStyleBlackBold)),
                  ),
                ),
                marginBottom30
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
