import 'package:flutter/material.dart';
import 'package:myorder/caches/caches.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/views/screens/bill/bills_screen.dart';
import 'package:myorder/views/screens/managements/chef_bar/chef_bar_other_screen.dart';
import 'package:myorder/views/screens/managements/dashboard/dashboard_screen.dart';
import 'package:myorder/views/screens/quantity_foods_order/quantity_foods_order_screen.dart';
import 'package:myorder/views/screens/utilities/setting_screen.dart';
import 'package:myorder/views/screens/utilities/utils_manage_screen.dart';

class UtilsPage extends StatefulWidget {
  const UtilsPage({super.key});

  @override
  State<UtilsPage> createState() => _UtilsPageState();
}

class _UtilsPageState extends State<UtilsPage> {
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  String roleString = "";
  String employeeName = "";
  Future<void> getCurrentUser() async {
    MyCacheManager myCacheManager = MyCacheManager();

    String? dateDailySaleString =
        await myCacheManager.getFromCache(CACHE_EMPLOYEE_ROLE_KEY);
    String? name = await myCacheManager.getFromCache(CACHE_EMPLOYEE_NAME_KEY);

    int role = int.tryParse(dateDailySaleString ?? ROLE_STAFF.toString()) ?? 0;
    setState(() {
      employeeName = name ?? "Nhân viên mới";
      roleString = role == ROLE_CUSTOMER
          ? ROLE_CUSTOMER_STRING
          : role == ROLE_STAFF
              ? ROLE_STAFF_STRING
              : role == ROLE_MANAGER
                  ? ROLE_MANAGER_STRING
                  : role == ROLE_CASHIER
                      ? ROLE_CASHIER_STRING
                      : role == ROLE_OWNER
                          ? ROLE_OWNER_STRING
                          : ROLE_STAFF_STRING;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
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
                                image: AssetImage(defaultLogoImageString),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                              child: ListTile(
                            title: Text(
                              employeeName,
                              style: textStyleBlackBold,
                            ),
                            subtitle: Text(
                              roleString,
                              style: textStyleGrey14,
                            ),
                          )),
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
                          leading:
                              Text("Địa chỉ:", style: textStyleBlackRegular),
                          title: Text("2001 / Bình Mỹ / Củ Chi / TP.HCM",
                              style: textStyleBlackRegular),
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
                                        const UtilsManagePage()))
                          },
                          child: const ListTile(
                            leading: Icon(Icons.ad_units, color: iconColor),
                            title:
                                Text("Quản Lý", style: textStyleBlackRegular),
                            trailing: Icon(Icons.arrow_forward_ios_outlined,
                                color: iconColor),
                          ),
                        ),
                        deviderColor1,
                        InkWell(
                          onTap: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MyDashBoard()))
                          },
                          child: const ListTile(
                            leading: Icon(Icons.ad_units, color: iconColor),
                            title: Text("Dash Board",
                                style: textStyleBlackRegular),
                            trailing: Icon(Icons.arrow_forward_ios_outlined,
                                color: iconColor),
                          ),
                        ),
                        deviderColor1,
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
                            title: Text("Số Lượng Bán Hôm Nay",
                                style: textStyleBlackRegular),
                            trailing: Icon(Icons.arrow_forward_ios_outlined,
                                color: iconColor),
                          ),
                        ),
                        deviderColor1,
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
                            title:
                                Text("BẾP/BAR", style: textStyleBlackRegular),
                            trailing: Icon(Icons.arrow_forward_ios_outlined,
                                color: iconColor),
                          ),
                        ),
                        deviderColor1,
                        InkWell(
                          onTap: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const BillPage()))
                          },
                          child: const ListTile(
                            leading: Icon(Icons.receipt_long, color: iconColor),
                            title: Text("Hóa Đơn Đã Thanh Toán",
                                style: textStyleBlackRegular),
                            trailing: Icon(Icons.arrow_forward_ios_outlined,
                                color: iconColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
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
            marginTop10
          ],
        ),
      ),
    ));
  }
}
