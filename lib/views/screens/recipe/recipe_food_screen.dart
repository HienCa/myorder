// ignore_for_file: non_constant_identifier_names, avoid_print, prefer_interpolation_to_compose_strings, constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/constants/app_constants.dart';
import 'package:myorder/controllers/foods/foods_controller.dart';
import 'package:myorder/models/price_percent.dart';
import 'package:myorder/views/screens/managements/dashboard/take_away/take_away_screen.dart';
import 'package:myorder/views/screens/recipe/recipe_food_detail_screen.dart';
import 'package:myorder/views/widgets/icons/icon_close.dart';
import 'package:responsive_grid/responsive_grid.dart';

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  FoodController foodController = Get.put(FoodController());

  String keySearch = "";
  int categoryCodeSelected = 0;
  int categoryCodeDecrease = CATEGORY_ALL;
  PricePercent pricePercentResult =
      PricePercent(value: 0, type_value: TYPE_PRICE);
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Filter Food
    categoryCodeSelected = CATEGORY_FOOD;
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    isFood = true;
    isDrink = false;
    isOther = false;

    //Lây thông tin đơn hàng
    foodController.getfoods(keySearch, DEACTIVE);

  }

  //Giảm giá
  bool isCheckedChooseTypeDiscrease = false;
  bool isCheckedGTGT = false;
  bool isCheckedDecrease = false;
  bool isSurcharge = false;

  //Tabbar
  bool isFood = true;
  bool isDrink = false;
  bool isOther = false;

  void setUpScreen(DashBoardBooking dashBoardBooking) {
    switch (dashBoardBooking) {
      case DashBoardBooking.Food:
        setState(() {
          isFood = true;
          isDrink = false;
          isOther = false;

          categoryCodeSelected = CATEGORY_FOOD;
          foodController.getfoodsToOrderCategoryCode(keySearch, CATEGORY_FOOD);
        });
      case DashBoardBooking.Drink:
        setState(() {
          isFood = false;
          isDrink = true;
          isOther = false;

          categoryCodeSelected = CATEGORY_DRINK;
          foodController.getfoodsToOrderCategoryCode(keySearch, CATEGORY_DRINK);
        });
      case DashBoardBooking.Other:
        setState(() {
          isFood = false;
          isDrink = false;
          isOther = true;

          categoryCodeSelected = CATEGORY_OTHER;
          foodController.getfoodsToOrderCategoryCode(keySearch, CATEGORY_OTHER);
        });

      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: grayColor200,
      body: Theme(
        data: ThemeData(unselectedWidgetColor: primaryColor),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  //GỌI MÓN - GỢI Ý
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SizedBox(
                              height: 40,
                              // width: MediaQuery.of(context).size.width * 0.45,
                              child: Row(children: [
                                InkWell(
                                  onTap: () {
                                    setUpScreen(DashBoardBooking.Food);
                                  },
                                  child: Column(children: [
                                    Expanded(
                                      child: SizedBox(
                                        width: 100,
                                        child: Center(
                                          child: Text(
                                            "MÓN ĂN",
                                            style: isFood
                                                ? textStyleTabLandscapeActive
                                                : textStyleTabLandscapeDeActive,
                                          ),
                                        ),
                                      ),
                                    ),
                                    isFood
                                        ? Container(
                                            height: 5,
                                            width: 80,
                                            decoration: const BoxDecoration(
                                              color: primaryColor,
                                              borderRadius: borderContainer8,
                                            ),
                                          )
                                        : const SizedBox()
                                  ]),
                                ),
                                InkWell(
                                  onTap: () {
                                    setUpScreen(DashBoardBooking.Drink);
                                  },
                                  child: Column(children: [
                                    Expanded(
                                      child: SizedBox(
                                        width: 70,
                                        child: Center(
                                          child: Text(
                                            "ĐỒ UỐNG",
                                            style: isDrink
                                                ? textStyleTabLandscapeActive
                                                : textStyleTabLandscapeDeActive,
                                          ),
                                        ),
                                      ),
                                    ),
                                    isDrink
                                        ? Container(
                                            height: 5,
                                            width: 80,
                                            decoration: const BoxDecoration(
                                              color: primaryColor,
                                              borderRadius: borderContainer8,
                                            ),
                                          )
                                        : const SizedBox()
                                  ]),
                                ),
                                InkWell(
                                  onTap: () {
                                    setUpScreen(DashBoardBooking.Other);
                                  },
                                  child: Column(children: [
                                    Expanded(
                                      child: SizedBox(
                                        width: 70,
                                        child: Center(
                                          child: Text(
                                            "KHÁC",
                                            style: isOther
                                                ? textStyleTabLandscapeActive
                                                : textStyleTabLandscapeDeActive,
                                          ),
                                        ),
                                      ),
                                    ),
                                    isOther
                                        ? Container(
                                            height: 5,
                                            width: 80,
                                            decoration: const BoxDecoration(
                                              color: primaryColor,
                                              borderRadius: borderContainer8,
                                            ),
                                          )
                                        : const SizedBox()
                                  ]),
                                ),
                                const MyCloseIcon(heightWidth: 30, sizeIcon: 16)
                              ]),
                            ),
                          ),
                        ),
                        marginTop5,
                        //DANH SÁCH MÓN
                        SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: Container(
                            margin: const EdgeInsets.only(left: 5),
                            decoration: BoxDecoration(
                              color: grayColor200,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Obx(() {
                              return ResponsiveGridList(
                                desiredItemWidth: 100,
                                minSpacing: 10,
                                children: List.generate(
                                    foodController.foods.length, (index) {
                                  var food = foodController.foods[index];

                                  return InkWell(
                                    onTap: () => {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RecipeDetailScreen(
                                                    food: food,
                                                  )))
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: const BoxDecoration(
                                        color: backgroundColor,
                                        borderRadius: borderContainer8,
                                      ),
                                      margin: const EdgeInsets.only(top: 10),
                                      child: Column(
                                        children: [
                                          //IMAGE
                                          food.image != ""
                                              ? ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  child: Image.network(
                                                    food.image ??
                                                        defaultFoodImageString,
                                                    width: 100,
                                                    height: 100,
                                                    fit: BoxFit.cover,
                                                  ),
                                                )
                                              : ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  child: defaultFoodImage),
                                          //NAME
                                          Marquee(
                                              direction: Axis.horizontal,
                                              // textDirection: TextDirection.ltr,
                                              animationDuration:
                                                  const Duration(seconds: 1),
                                              backDuration: const Duration(
                                                  milliseconds: 4000),
                                              pauseDuration: const Duration(
                                                  milliseconds: 1000),
                                              directionMarguee:
                                                  DirectionMarguee.TwoDirection,
                                              child: RichText(
                                                  text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                      text: food.name,
                                                      style:
                                                          textStyleTabLandscapeLabel),
                                                ],
                                              ))),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
