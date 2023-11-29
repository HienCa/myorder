// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/ingredients/ingredients_controller.dart';
import 'package:myorder/utils.dart';
import 'package:myorder/views/screens/managements/ingredients/add_update_ingredient_screen.dart';
import 'package:myorder/views/widgets/dialogs.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

class ManagementIngredientsPage extends StatefulWidget {
  const ManagementIngredientsPage({Key? key}) : super(key: key);
  @override
  _ManagementIngredientsPageState createState() =>
      _ManagementIngredientsPageState();
}

class _ManagementIngredientsPageState extends State<ManagementIngredientsPage> {
  IngredientController ingredientController = Get.put(IngredientController());

  @override
  void initState() {
    super.initState();
    // ingredientController.getIngredients("");
  }

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
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
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
              "QUẢN LÝ NGUYÊN LIỆU",
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 50,
                  width: 400,
                  margin: const EdgeInsets.all(kDefaultPadding),
                  padding: const EdgeInsets.symmetric(
                    horizontal: kDefaultPadding,
                    vertical: kDefaultPadding / 4, // 5 top and bottom
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.4),
                      borderRadius: borderRadiusTextField30,
                      border: Border.all(width: 1, color: borderColorPrimary)),
                  child: TextField(
                    onChanged: (value) {
                      ingredientController.getIngredients(value);
                    },
                    style: const TextStyle(color: borderColorPrimary),
                    decoration: const InputDecoration(
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      fillColor: borderColorPrimary,
                      icon: Icon(
                        Icons.search,
                        color: iconColorPrimary,
                      ),
                      hintText: 'Tìm kiếm nguyên liệu',
                      hintStyle: TextStyle(color: borderColorPrimary),
                    ),
                    cursorColor: borderColorPrimary,
                  ),
                ),
                marginTop10,
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: Obx(() {
                    return ListView.builder(
                        itemCount: ingredientController.ingredients.length,
                        itemBuilder: (context, index) {
                          final food = ingredientController.ingredients[index];
                          String string;
                          return InkWell(
                            onTap: () async {
                              final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AddUpdateIngredientPage(
                                              ingredient: ingredientController
                                                  .ingredients[index])));
                              if (result == 'update') {
                                Utils.showStylishDialog(
                                    context,
                                    'THÀNH CÔNG!',
                                    'Cập nhật thông tin nguyên liệu thành công!',
                                    StylishDialogType.SUCCESS);
                              }
                            },
                            child: Card(
                              color: food.active == 1
                                  ? backgroundColor
                                  : const Color.fromARGB(255, 213, 211, 211),
                              child: ListTile(
                                leading: food.image != ""
                                    ? CircleAvatar(
                                        radius: 25,
                                        backgroundColor: Colors.black,
                                        backgroundImage:
                                            NetworkImage(food.image!),
                                      )
                                    : CircleAvatar(
                                        child: Image.asset(
                                          defaultFoodImageString,
                                          width: 100,
                                          height: 100,
                                        ),
                                      ),
                                title: Marquee(
                                  direction: Axis.horizontal,
                                  textDirection: TextDirection.ltr,
                                  animationDuration: const Duration(seconds: 1),
                                  backDuration:
                                      const Duration(milliseconds: 4000),
                                  pauseDuration:
                                      const Duration(milliseconds: 1000),
                                  directionMarguee:
                                      DirectionMarguee.TwoDirection,
                                  child: Text(
                                    food.name,
                                    style: textStyleNameBlackRegular,
                                  ),
                                ),
                                trailing: InkWell(
                                  onTap: () => {
                                    string = food.active == ACTIVE
                                        ? "khóa"
                                        : "bỏ khóa",
                                    showCustomAlertDialogConfirm(
                                      context,
                                      "TRẠNG THÁI HOẠT ĐỘNG",
                                      "Bạn có chắc chắn muốn $string nguyên liệu này?",
                                      colorWarning,
                                      () async {
                                        await ingredientController
                                            .updateToggleActive(
                                                food.ingredient_id,
                                                food.active);
                                      },
                                    )
                                  },
                                  child: food.active == ACTIVE
                                      ? const Icon(
                                          Icons.key,
                                          size: 25,
                                          color: activeColor,
                                        )
                                      : const Icon(
                                          Icons.key_off,
                                          size: 25,
                                          color: deActiveColor,
                                        ),
                                ),
                              ),
                            ),
                          );
                        });
                  }),
                ),
                InkWell(
                  onTap: () async {
                    final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const AddUpdateIngredientPage()));
                    if (result == 'add') {
                      Utils.showStylishDialog(
                          context,
                          'THÀNH CÔNG!',
                          'Thêm nguyên liệu mới thành công!',
                          StylishDialogType.SUCCESS);
                    }
                  },
                  child: Container(
                    height: 50,
                    margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        "+ THÊM NGUYÊN LIỆU",
                        style: textStyleWhiteBold20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
