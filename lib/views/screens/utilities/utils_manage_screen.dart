import 'package:flutter/material.dart';
import 'package:myorder/caches/caches.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/views/screens/managements/area_table/area_table_screen.dart';
import 'package:myorder/views/screens/managements/categories/categories_screen.dart';
import 'package:myorder/views/screens/managements/discounts/discounts_screen.dart';
import 'package:myorder/views/screens/managements/employees/employees_screen.dart';
import 'package:myorder/views/screens/managements/foods/foods_screen.dart';
import 'package:myorder/views/screens/managements/ingredients/ingredients_screen.dart';
import 'package:myorder/views/screens/managements/daily_sales/daily_sales_screen.dart';
import 'package:myorder/views/screens/managements/warehouse/warehouse_screen.dart';
import 'package:myorder/views/screens/managements/suppliers/suppliers_screen.dart';
import 'package:myorder/views/screens/managements/units/units_screen.dart';
import 'package:myorder/views/screens/managements/vats/vats_screen.dart';
import 'package:myorder/views/screens/recipe/recipe_food_screen.dart';

class UtilsManagePage extends StatefulWidget {
  const UtilsManagePage({super.key});

  @override
  State<UtilsManagePage> createState() => _UtilsManagePageState();
}

class _UtilsManagePageState extends State<UtilsManagePage> {
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
    return Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: secondColor,
            ),
          ),
          title: const Center(
              child: Text(
            "QUẢN LÝ",
            style: TextStyle(color: secondColor),
          )),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.add_circle_outline,
                  color: transparentColor,
                ),
              ),
            ),
          ],
          backgroundColor: primaryColor,
        ),
        body: SingleChildScrollView(
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
                    marginTop20,
                    Container(
                        margin: const EdgeInsets.all(0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            marginRight20,
                            Expanded(
                              child: Tooltip(
                                message: "Thiết lập số lượng bán hằng ngày",
                                child: InkWell(
                                  onTap: () => {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ManagementDailySalesScreen()))
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        color: backgroundColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
                                    height: 180,
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          dailysalesImageString,
                                          width: 150,
                                          height: 150,
                                          fit: BoxFit.cover,
                                        ),
                                        const Text("DAILY SALES",
                                            style: textStyleLabel16)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            marginRight20,
                            Expanded(
                              child: Tooltip(
                                message: "Quản lý khu nhân viên",
                                child: InkWell(
                                  onTap: () => {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ManagementEmployeesPage()))
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        color: backgroundColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
                                    height: 180,
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          staffImageString,
                                          width: 150,
                                          height: 150,
                                          fit: BoxFit.cover,
                                        ),
                                        const Text("NHÂN VIÊN",
                                            style: textStyleLabel16)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            marginRight20,
                          ],
                        )),
                    marginTop20,
                    Container(
                        margin: const EdgeInsets.all(0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            marginRight20,
                            Expanded(
                              child: Tooltip(
                                message: "Quản lý món",
                                child: InkWell(
                                  onTap: () => {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ManagementFoodsPage()))
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        color: backgroundColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
                                    height: 180,
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          menuImageString,
                                          width: 150,
                                          height: 150,
                                          fit: BoxFit.cover,
                                        ),
                                        const Text("THỰC ĐƠN",
                                            style: textStyleLabel16)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            marginRight20,
                            Expanded(
                              child: Tooltip(
                                message: "Quản Lý Khu Vực",
                                child: InkWell(
                                  onTap: () => {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ManagementAreaTablePage()))
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        color: backgroundColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
                                    height: 180,
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          tableImageString,
                                          width: 150,
                                          height: 150,
                                          fit: BoxFit.cover,
                                        ),
                                        const Text("KHU VỰC / BÀN",
                                            style: textStyleLabel16)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            marginRight20,
                          ],
                        )),
                    marginTop20,
                    Container(
                        margin: const EdgeInsets.all(0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            marginRight20,
                            Expanded(
                              child: Tooltip(
                                message: "Quản lý kho",
                                child: InkWell(
                                  onTap: () => {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const WarehouseScreen()))
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        color: backgroundColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
                                    height: 180,
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          warehouseImageString,
                                          width: 150,
                                          height: 150,
                                          fit: BoxFit.cover,
                                        ),
                                        const Text("KHO",
                                            style: textStyleLabel16)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            marginRight20,
                            Expanded(
                              child: Tooltip(
                                message: "Quản lý nguyên liệu",
                                child: InkWell(
                                  onTap: () => {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ManagementIngredientsPage()))
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        color: backgroundColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
                                    height: 180,
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          ingredient2ImageString,
                                          width: 150,
                                          height: 150,
                                          fit: BoxFit.cover,
                                        ),
                                        const Text("NGUYÊN LIỆU",
                                            style: textStyleLabel16)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            marginRight20,
                          ],
                        )),
                    marginTop20,
                    Container(
                        margin: const EdgeInsets.all(0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            marginRight20,
                            Expanded(
                              child: Tooltip(
                                message: "Quản lý nhà cung cấp",
                                child: InkWell(
                                  onTap: () => {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ManagementSupplierPage()))
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        color: backgroundColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
                                    height: 180,
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          supplierImageString,
                                          width: 150,
                                          height: 150,
                                          fit: BoxFit.cover,
                                        ),
                                        const Text("NHÀ CUNG CẤP",
                                            style: textStyleLabel16)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            marginRight20,
                            Expanded(
                              child: Tooltip(
                                message: "Quản lý công thức",
                                child: InkWell(
                                  onTap: () => {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const RecipesScreen()))
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        color: backgroundColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
                                    height: 180,
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          recipe1ImageString,
                                          width: 150,
                                          height: 150,
                                          fit: BoxFit.cover,
                                        ),
                                        const Text("CÔNG THỨC MÓN",
                                            style: textStyleLabel16)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            marginRight20,
                          ],
                        )),
                    marginTop20,
                    Container(
                        margin: const EdgeInsets.all(0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            marginRight20,
                            Expanded(
                              child: Tooltip(
                                message: "Quản lý danh mục",
                                child: InkWell(
                                  onTap: () => {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ManagementCategoriesPage()))
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        color: backgroundColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
                                    height: 180,
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          categoryImageString,
                                          width: 150,
                                          height: 150,
                                          fit: BoxFit.cover,
                                        ),
                                        const Text("DANH MỤC",
                                            style: textStyleLabel16)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            marginRight20,
                            Expanded(
                              child: Tooltip(
                                message: "Quản lý đơn vị",
                                child: InkWell(
                                  onTap: () => {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ManagementUnitsPage()))
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        color: backgroundColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
                                    height: 180,
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          unitImageString,
                                          width: 150,
                                          height: 150,
                                          fit: BoxFit.cover,
                                        ),
                                        const Text("ĐƠN VỊ",
                                            style: textStyleLabel16)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            marginRight20,
                          ],
                        )),
                    marginTop20,
                    Container(
                        margin: const EdgeInsets.all(0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            marginRight20,
                            Expanded(
                              child: Tooltip(
                                message: "Quản lý giảm giá",
                                child: InkWell(
                                  onTap: () => {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ManagementDiscountsPage()))
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        color: backgroundColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
                                    height: 180,
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          discountImageString,
                                          width: 150,
                                          height: 150,
                                          fit: BoxFit.cover,
                                        ),
                                        const Text("GIẢM GIÁ",
                                            style: textStyleLabel16)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            marginRight20,
                            Expanded(
                              child: Tooltip(
                                message: "Quản lý VAT",
                                child: InkWell(
                                  onTap: () => {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ManagementVatsPage()))
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        color: backgroundColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
                                    height: 180,
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          vatImageString,
                                          width: 150,
                                          height: 150,
                                          fit: BoxFit.cover,
                                        ),
                                        const Text("VAT",
                                            style: textStyleLabel16)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            marginRight20,
                          ],
                        )),
                    marginTop20,
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
