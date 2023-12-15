// ignore_for_file: non_constant_identifier_names, avoid_print, prefer_interpolation_to_compose_strings, constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/constants/app_constants.dart';
import 'package:myorder/controllers/ingredients/ingredients_controller.dart';
import 'package:myorder/controllers/recipes/recipes_controller.dart';
import 'package:myorder/controllers/units/units_controller.dart';
import 'package:myorder/models/food.dart';
import 'package:myorder/models/recipe_detail.dart';
import 'package:myorder/models/unit.dart';
import 'package:myorder/utils.dart';
import 'package:myorder/views/screens/recipe/dialogs/dialog_confirm_add_recipe_detail.dart';
import 'package:myorder/views/screens/recipe/dialogs/dialog_confirm_delete_recipe_detail.dart';
import 'package:myorder/views/screens/recipe/dialogs/dialog_confirm_update_quantity_recipe_detail;.dart';
import 'package:myorder/views/widgets/buttons/button_icon.dart';
import 'package:myorder/views/widgets/dialogs/dialog_choose_price_calculator_double.dart';
import 'package:myorder/views/widgets/dialogs/dialog_select.dart';
import 'package:myorder/views/widgets/icons/icon_close.dart';
import 'package:myorder/views/widgets/videos/rotate_phone.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Food food;
  const RecipeDetailScreen({
    Key? key,
    required this.food,
  }) : super(key: key);

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  RecipeController recipeController = Get.put(RecipeController());
  IngredientController ingredientController = Get.put(IngredientController());
  UnitController unitController = Get.put(UnitController());

  String keySearch = "";

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Utils.unSelectedAll(ingredientController.ingredients);
    ingredientController.getIngredientsOfFood(keySearch);
    recipeController.getRecipeOfFood(widget.food.food_id, keySearch);
  }

  final TextEditingController textSearchUnitController =
      TextEditingController();
  final TextEditingController textUnitIdController = TextEditingController();
  final TextEditingController textVatIdController = TextEditingController();

  bool isExistInRecipe(String ingredient_id) {
    for (RecipeDetail recipeDetail in recipeController.recipeOfFood) {
      //kiểm tra nguyên liệu đã tồn tại trong công thức chưa

      if (ingredient_id == recipeDetail.ingredient_id) {
        return true;
      }
    }
    return false;
  }

  void increaseQuantity(String ingredient_id) {
    for (RecipeDetail recipeDetail in recipeController.recipeOfFood) {
      //Tăng
      if (ingredient_id == recipeDetail.ingredient_id) {
        recipeDetail.new_quantity = double.parse(
            ((recipeDetail.new_quantity ?? 0.1) + 0.1).toStringAsFixed(1));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Utils.isLandscapeOrientation(context)
        ? Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: grayColor200,
            body: Theme(
              data: ThemeData(unselectedWidgetColor: primaryColor),
              child: SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            //GỌI MÓN - GỢI Ý
                            Expanded(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.1,
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                        left: 5,
                                      ),
                                      padding: const EdgeInsets.only(
                                        left: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: const Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            FaIcon(FontAwesomeIcons.fileInvoice,
                                                color: iconColor, size: 16),
                                            SizedBox(width: 8),
                                            Text(
                                              'DANH SÁCH CÁC NGUYÊN LIỆU',
                                              style: textStyleTabLandscapeLabel,
                                            ),
                                          ]),
                                    ),
                                  ),
                                  marginTop5,
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.1,
                                    margin: const EdgeInsets.only(
                                      left: 2,
                                      right: 2,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: kDefaultPadding,
                                      vertical: kDefaultPadding /
                                          4, // 5 top and bottom
                                    ),
                                    decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.4),
                                        borderRadius: borderRadiusTextField30,
                                        border: Border.all(
                                            width: 1,
                                            color: const Color.fromARGB(
                                                255, 233, 233, 233))),
                                    child: TextField(
                                      onChanged: (value) => {
                                        setState(() {
                                          keySearch = value;
                                          ingredientController
                                              .getIngredientsOfFood(
                                            value,
                                          );
                                        }),
                                      },
                                      style: const TextStyle(color: grayColor),
                                      decoration: const InputDecoration(
                                        isDense: true,
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        fillColor: grayColor,
                                        icon: Icon(
                                          Icons.search,
                                          color: grayColor,
                                        ),
                                        hintText: 'Tìm kiếm nguyên liệu',
                                        hintStyle: TextStyle(
                                            color: grayColor, fontSize: 14),
                                      ),
                                      cursorColor: grayColor,
                                    ),
                                  ),
                                  marginTop5,
                                  Expanded(
                                      child: Column(
                                    children: [
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.64,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: grayColor200,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Obx(() {
                                            return ResponsiveGridList(
                                              desiredItemWidth: 100,
                                              minSpacing: 10,
                                              children: List.generate(
                                                  ingredientController
                                                      .ingredientsOfFood
                                                      .length, (index) {
                                                var ingredient =
                                                    ingredientController
                                                            .ingredientsOfFood[
                                                        index];
                                                return InkWell(
                                                  onTap: () => {
                                                    setState(() {
                                                      if (isExistInRecipe(
                                                          ingredient
                                                              .ingredient_id)) {
                                                        increaseQuantity(
                                                            ingredient
                                                                .ingredient_id);
                                                        // Utils.showToast(
                                                        //     'Đã tăng số lượng của ${ingredient.name}',
                                                        //     TypeToast.INFO);
                                                      } else {
                                                        //Chưa tồn tại
                                                        if (ingredient
                                                                .isSelected ==
                                                            false) {
                                                          ingredient
                                                                  .isSelected =
                                                              true;
                                                          print(
                                                              ingredient.name);
                                                        } else {
                                                          ingredient
                                                                  .isSelected =
                                                              false;
                                                        }
                                                      }
                                                    })
                                                  },
                                                  child: Container(
                                                    width: 100,
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: backgroundColor,
                                                      borderRadius:
                                                          borderContainer8,
                                                    ),
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 10),
                                                    child: Column(
                                                      children: [
                                                        Stack(
                                                          alignment:
                                                              Alignment.center,
                                                          children: [
                                                            //IMAGE
                                                            ingredient.image !=
                                                                    ""
                                                                ? ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(5),
                                                                    child: Image
                                                                        .network(
                                                                      ingredient
                                                                              .image ??
                                                                          defaultFoodImageString,
                                                                      width: 50,
                                                                      height:
                                                                          50,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  )
                                                                : ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                5),
                                                                    child:
                                                                        defaultFoodImage),

                                                            ingredient.isSelected ==
                                                                    true
                                                                ? Positioned(
                                                                    top: 0,
                                                                    right: 0,
                                                                    child:
                                                                        Container(
                                                                      color: Colors
                                                                          .transparent,
                                                                      height:
                                                                          30,
                                                                      width: 30,
                                                                      child:
                                                                          ClipRRect(
                                                                        child:
                                                                            checkImageGreen,
                                                                      ),
                                                                    ))
                                                                : const SizedBox()
                                                          ],
                                                        ),
                                                        //NAME
                                                        Marquee(
                                                            direction:
                                                                Axis.horizontal,
                                                            textDirection:
                                                                TextDirection
                                                                    .ltr,
                                                            animationDuration:
                                                                const Duration(
                                                                    seconds: 1),
                                                            backDuration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        4000),
                                                            pauseDuration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        1000),
                                                            directionMarguee:
                                                                DirectionMarguee
                                                                    .TwoDirection,
                                                            child: RichText(
                                                                text: TextSpan(
                                                              children: [
                                                                TextSpan(
                                                                    text: ingredient
                                                                        .name,
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
                                  ))
                                ],
                              ),
                            ),
                            //RIGHT
                            Expanded(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.1,
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                        left: 5,
                                      ),
                                      padding: const EdgeInsets.only(
                                        left: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const FaIcon(
                                                FontAwesomeIcons.fileInvoice,
                                                color: iconColor,
                                                size: 16),
                                            const SizedBox(width: 8),
                                            Text(
                                              'NGUYÊN LIỆU CHẾ BIẾN MÓN: ${widget.food.name}',
                                              style: textStyleTabLandscapeLabel,
                                            ),
                                            const Spacer(),
                                            InkWell(
                                                onTap: () =>
                                                    {Utils.myPop(context)},
                                                child: const MyCloseIcon(
                                                    heightWidth: 30,
                                                    sizeIcon: 16)),
                                            const SizedBox(width: 4),
                                          ]),
                                    ),
                                  ),
                                  marginTop5,
                                  Container(
                                    margin: const EdgeInsets.only(
                                      left: 5,
                                    ),
                                    height: MediaQuery.of(context).size.height *
                                        0.1,
                                    decoration: BoxDecoration(
                                      color: backgroundColor,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: const Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 40,
                                          child: Center(
                                            child: Text(
                                              "STT",
                                              style: textStyleLabel8,
                                            ),
                                          ),
                                        ),
                                        marginRight5, // Use SizedBox to add margin
                                        Expanded(
                                          flex: 3,
                                          child: Center(
                                            child: Text(
                                              "TÊN NGUYÊN LIỆU",
                                              style: textStyleLabel8,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Center(
                                            child: Text(
                                              "SỐ LƯỢNG",
                                              style: textStyleLabel8,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Center(
                                            child: Text(
                                              "ĐƠN VỊ",
                                              style: textStyleLabel8,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  //DANH SÁCH CẦN THÊM
                                  Utils.filterSelected(ingredientController
                                              .ingredientsOfFood)
                                          .isNotEmpty
                                      ? Expanded(
                                          child: Column(
                                          children: [
                                            marginTop5,
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.64,
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                    color: grayColor200,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Obx(() {
                                                    List<dynamic> list =
                                                        Utils.filterSelected(
                                                            ingredientController
                                                                .ingredientsOfFood);
                                                    return ListView.builder(
                                                      itemCount: list.length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        var recipeDetail =
                                                            list[index];
                                                        return SingleChildScrollView(
                                                          child: Slidable(
                                                              key:
                                                                  const ValueKey(
                                                                      0),
                                                              endActionPane:
                                                                  ActionPane(
                                                                motion:
                                                                    const ScrollMotion(),
                                                                children: [
                                                                  SlidableAction(
                                                                    onPressed:
                                                                        (context) =>
                                                                            {
                                                                      setState(
                                                                          () {
                                                                        recipeDetail.isSelected =
                                                                            false;
                                                                      })
                                                                    },
                                                                    backgroundColor:
                                                                        colorCancel,
                                                                    foregroundColor:
                                                                        textWhiteColor,
                                                                    // icon: Icons
                                                                    //     .splitscreen ,

                                                                    label:
                                                                        'Bỏ chọn',
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                        .only(
                                                                  left: 5,
                                                                ),
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.1,
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  color:
                                                                      backgroundColor,
                                                                  // borderRadius:
                                                                  //     BorderRadius.circular(5),
                                                                ),
                                                                child: Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    SizedBox(
                                                                      width: 40,
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Text(
                                                                          (index + 1)
                                                                              .toString(),
                                                                          style:
                                                                              textStyleLabel8,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    marginRight5,
                                                                    Expanded(
                                                                      flex: 3,
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Text(
                                                                          recipeDetail
                                                                              .name,
                                                                          style:
                                                                              textStyleLabel8,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                        flex: 2,
                                                                        child:
                                                                            SizedBox(
                                                                          // width: 100,
                                                                          child:
                                                                              Row(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.center,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              InkWell(
                                                                                onTap: () {
                                                                                  setState(() {
                                                                                    if (recipeDetail.recipeDetail!.quantity > 0) {
                                                                                      recipeDetail.recipeDetail!.quantity = double.parse((recipeDetail.recipeDetail!.quantity - 0.1).toStringAsFixed(1));
                                                                                    } else {
                                                                                      Utils.showStylishDialog(context, 'THÔNG BÁO', 'Số lượng của mỗi nguyên liệu phải lớn hơn 0', StylishDialogType.INFO);
                                                                                    }
                                                                                  });
                                                                                },
                                                                                child: Container(
                                                                                  decoration: BoxDecoration(
                                                                                    color: iconColor,
                                                                                    borderRadius: BorderRadius.circular(5),
                                                                                  ),
                                                                                  height: 30,
                                                                                  width: 30,
                                                                                  child: const Align(
                                                                                    alignment: Alignment.center,
                                                                                    child: Icon(Icons.remove, color: Colors.white),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              const SizedBox(width: 5),
                                                                              Expanded(
                                                                                child: InkWell(
                                                                                  onTap: () async {
                                                                                    final result = await showDialog(
                                                                                      context: context,
                                                                                      builder: (BuildContext context) {
                                                                                        return MyDialogCalculator2(
                                                                                          value: recipeDetail.recipeDetail!.quantity,
                                                                                        );
                                                                                      },
                                                                                    );
                                                                                    if (result != null) {
                                                                                      setState(() {
                                                                                        recipeDetail.recipeDetail!.quantity = double.parse(result);
                                                                                      });
                                                                                    }
                                                                                  },
                                                                                  child: Center(
                                                                                    child: Text(
                                                                                      recipeDetail.recipeDetail!.quantity.toString(),
                                                                                      style: textStyleLabel8,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              const SizedBox(width: 5),
                                                                              InkWell(
                                                                                onTap: () {
                                                                                  setState(() {
                                                                                    recipeDetail.recipeDetail!.quantity = double.parse((recipeDetail.recipeDetail!.quantity + 0.1).toStringAsFixed(1));
                                                                                  });
                                                                                },
                                                                                child: Container(
                                                                                  decoration: BoxDecoration(
                                                                                    color: iconColor,
                                                                                    borderRadius: BorderRadius.circular(5),
                                                                                  ),
                                                                                  height: 30,
                                                                                  width: 30,
                                                                                  child: const Align(
                                                                                    alignment: Alignment.center,
                                                                                    child: Icon(Icons.add, color: Colors.white),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )),
                                                                    //ĐƠN VỊ
                                                                    Expanded(
                                                                        flex: 1,
                                                                        child:
                                                                            InkWell(
                                                                          onTap:
                                                                              () async {
                                                                            Unit
                                                                                result =
                                                                                await showDialog(
                                                                              context: context,
                                                                              builder: (BuildContext context) {
                                                                                return MyDialogSelect(lable: "DANH SÁCH ĐƠN VỊ", list: Utils.filterActive(unitController.units), keyNameSearch: "name");
                                                                              },
                                                                            );
                                                                            if (result.unit_id !=
                                                                                "") {
                                                                              setState(() {
                                                                                recipeDetail.recipeDetail!.unit_name = result.name;
                                                                                recipeDetail.recipeDetail!.unit_id = result.unit_id;
                                                                                recipeDetail.recipeDetail!.unit_value_conversion = result.value_conversion;
                                                                                print(recipeDetail.recipeDetail!.unit_id);
                                                                              });
                                                                            }
                                                                          },
                                                                          child:
                                                                              Center(
                                                                            child: Marquee(
                                                                                direction: Axis.horizontal,
                                                                                textDirection: TextDirection.ltr,
                                                                                animationDuration: const Duration(seconds: 1),
                                                                                backDuration: const Duration(milliseconds: 4000),
                                                                                pauseDuration: const Duration(milliseconds: 1000),
                                                                                directionMarguee: DirectionMarguee.TwoDirection,
                                                                                child: RichText(
                                                                                    text: TextSpan(
                                                                                  children: [
                                                                                    TextSpan(
                                                                                      text: recipeDetail.recipeDetail!.unit_name,
                                                                                      style: textStyleLabel8,
                                                                                    ),
                                                                                  ],
                                                                                ))),
                                                                          ),
                                                                        )),
                                                                  ],
                                                                ),
                                                              )),
                                                        );
                                                      },
                                                    );
                                                  })),
                                            )
                                          ],
                                        ))
                                      : const SizedBox(),

                                  //DANH SÁCH CẦN CẬP NHẬT - NGUYÊN LIỆU CỦA MÓN
                                  Utils.filterSelected(ingredientController
                                              .ingredientsOfFood)
                                          .isEmpty
                                      ? Expanded(
                                          child: Column(
                                          children: [
                                            marginTop5,
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.64,
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                    color: grayColor200,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Obx(() {
                                                    return ListView.builder(
                                                      itemCount:
                                                          recipeController
                                                              .recipeOfFood
                                                              .length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        var recipeDetail =
                                                            recipeController
                                                                    .recipeOfFood[
                                                                index];

                                                        return Slidable(
                                                            key: const ValueKey(
                                                                0),
                                                            endActionPane:
                                                                ActionPane(
                                                              motion:
                                                                  const ScrollMotion(),
                                                              children: [
                                                                SlidableAction(
                                                                  onPressed:
                                                                      (context) async {
                                                                    final result =
                                                                        await showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return CustomDialogDeleteRecipeDetail(
                                                                            food_id:
                                                                                widget.food.food_id,
                                                                            recipeDetail: recipeDetail);
                                                                      },
                                                                    );
                                                                    if (result ==
                                                                        'success') {
                                                                      Utils.showStylishDialog(
                                                                          context,
                                                                          'THÀNH CÔNG',
                                                                          'Loại bỏ nguyên liệu ${recipeDetail.name} thành công!',
                                                                          StylishDialogType
                                                                              .SUCCESS);
                                                                    }
                                                                  },
                                                                  backgroundColor:
                                                                      colorCancel,
                                                                  foregroundColor:
                                                                      textWhiteColor,
                                                                  // icon: Icons
                                                                  //     .splitscreen,
                                                                  label:
                                                                      'Hủy bỏ',
                                                                ),
                                                              ],
                                                            ),
                                                            child: Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .only(
                                                                left: 5,
                                                              ),
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.1,
                                                              decoration:
                                                                  const BoxDecoration(
                                                                color:
                                                                    backgroundColor,
                                                                // borderRadius:
                                                                //     BorderRadius.circular(5),
                                                              ),
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  SizedBox(
                                                                    width: 40,
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        (index +
                                                                                1)
                                                                            .toString(),
                                                                        style:
                                                                            textStyleLabel8,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  marginRight5,
                                                                  Expanded(
                                                                    flex: 3,
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        recipeDetail
                                                                            .name,
                                                                        style:
                                                                            textStyleLabel8,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                      flex: 2,
                                                                      child:
                                                                          SizedBox(
                                                                        // width: 100,
                                                                        child:
                                                                            Row(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            InkWell(
                                                                              onTap: () {
                                                                                setState(() {
                                                                                  if ((recipeDetail.new_quantity ?? 0) > 0) {
                                                                                    recipeDetail.new_quantity = double.parse(((recipeDetail.new_quantity ?? 0.1) - 0.1).toStringAsFixed(1));
                                                                                  } else {
                                                                                    Utils.showStylishDialog(context, 'THÔNG BÁO', 'Số lượng của mỗi nguyên liệu phải lớn hơn 0', StylishDialogType.INFO);
                                                                                  }
                                                                                });
                                                                              },
                                                                              child: Container(
                                                                                decoration: BoxDecoration(
                                                                                  color: iconColor,
                                                                                  borderRadius: BorderRadius.circular(5),
                                                                                ),
                                                                                height: 30,
                                                                                width: 30,
                                                                                child: const Align(
                                                                                  alignment: Alignment.center,
                                                                                  child: Icon(Icons.remove, color: Colors.white),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            const SizedBox(width: 5),
                                                                            Expanded(
                                                                              child: InkWell(
                                                                                onTap: () async {
                                                                                  final result = await showDialog(
                                                                                    context: context,
                                                                                    builder: (BuildContext context) {
                                                                                      return MyDialogCalculator2(
                                                                                        value: recipeDetail.new_quantity ?? 0,
                                                                                      );
                                                                                    },
                                                                                  );
                                                                                  if (result != null) {
                                                                                    setState(() {
                                                                                      recipeDetail.new_quantity = double.parse(result);
                                                                                    });
                                                                                  }
                                                                                },
                                                                                child: Center(
                                                                                  child: Text(
                                                                                    recipeDetail.new_quantity.toString(),
                                                                                    style: textStyleLabel8,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            const SizedBox(width: 5),
                                                                            InkWell(
                                                                              onTap: () {
                                                                                setState(() {
                                                                                  recipeDetail.new_quantity = double.parse(((recipeDetail.new_quantity ?? 0.1) + 0.1).toStringAsFixed(1));
                                                                                });
                                                                              },
                                                                              child: Container(
                                                                                decoration: BoxDecoration(
                                                                                  color: iconColor,
                                                                                  borderRadius: BorderRadius.circular(5),
                                                                                ),
                                                                                height: 30,
                                                                                width: 30,
                                                                                child: const Align(
                                                                                  alignment: Alignment.center,
                                                                                  child: Icon(Icons.add, color: Colors.white),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      )),
                                                                  //ĐƠN VỊ
                                                                  Expanded(
                                                                      flex: 1,
                                                                      child:
                                                                          InkWell(
                                                                        onTap:
                                                                            () async {
                                                                          Unit
                                                                              result =
                                                                              await showDialog(
                                                                            context:
                                                                                context,
                                                                            builder:
                                                                                (BuildContext context) {
                                                                              return MyDialogSelect(lable: "DANH SÁCH ĐƠN VỊ", list: Utils.filterActive(unitController.units), keyNameSearch: "name");
                                                                            },
                                                                          );
                                                                          if (result.unit_id !=
                                                                              "") {
                                                                            setState(() {
                                                                              recipeDetail.unit_name = result.name;
                                                                              recipeDetail.new_unit_id = result.unit_id;
                                                                              recipeDetail.unit_value_conversion = result.value_conversion;
                                                                              print(recipeDetail.unit_id);
                                                                              print(recipeDetail.new_unit_id);
                                                                            });
                                                                          }
                                                                        },
                                                                        child:
                                                                            Center(
                                                                          child: Marquee(
                                                                              direction: Axis.horizontal,
                                                                              textDirection: TextDirection.ltr,
                                                                              animationDuration: const Duration(seconds: 1),
                                                                              backDuration: const Duration(milliseconds: 4000),
                                                                              pauseDuration: const Duration(milliseconds: 1000),
                                                                              directionMarguee: DirectionMarguee.TwoDirection,
                                                                              child: RichText(
                                                                                  text: TextSpan(
                                                                                children: [
                                                                                  TextSpan(
                                                                                    text: recipeDetail.unit_name,
                                                                                    style: textStyleLabel8,
                                                                                  ),
                                                                                ],
                                                                              ))),
                                                                        ),
                                                                      )),
                                                                ],
                                                              ),
                                                            ));
                                                      },
                                                    );
                                                  })),
                                            )
                                          ],
                                        ))
                                      : const SizedBox()
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      marginTop5,
                      //THANH TÁC VỤ

                      Utils.filterSelected(
                                  ingredientController.ingredientsOfFood)
                              .isNotEmpty
                          ? Obx(() {
                              return Container(
                                padding:
                                    const EdgeInsets.only(left: 4, right: 4),
                                height: 45,
                                decoration: BoxDecoration(
                                  color: backgroundColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        //THÊM NGUYÊN LIỆU CỦA MÓN

                                        if (Utils.filterSelected(
                                                ingredientController
                                                    .ingredientsOfFood)
                                            .isNotEmpty) {
                                          final result = await showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return CustomDialogAddRecipeDetail(
                                                food_id: widget.food.food_id,
                                              );
                                            },
                                          );
                                          if (result == 'success') {
                                            Utils.showStylishDialog(
                                                context,
                                                'THÀNH CÔNG',
                                                'Thêm nguyên liệu của món ${widget.food.name} thành công!',
                                                StylishDialogType.SUCCESS);
                                            setState(() {
                                              Utils.unSelectedAll(
                                                  ingredientController
                                                      .ingredients);
                                              ingredientController
                                                  .getIngredientsOfFood(
                                                      keySearch);
                                            });
                                          }
                                        }
                                      },
                                      child: CustomButtonIcon(
                                          label: 'THÊM NGUYÊN LIỆU',
                                          height: 40,
                                          iconColor: secondColor,
                                          icon: FontAwesomeIcons.plus,
                                          backgroundColor: Utils.filterSelected(
                                                      ingredientController
                                                          .ingredientsOfFood)
                                                  .isNotEmpty
                                              ? colorSuccess
                                              : grayColor,
                                          textStyle: const TextStyle(
                                            color: secondColor,
                                            fontSize: 10,
                                          )),
                                    ),
                                  ],
                                ),
                              );
                            })
                          : Obx(() {
                              return Container(
                                padding:
                                    const EdgeInsets.only(left: 4, right: 4),
                                height: 45,
                                decoration: BoxDecoration(
                                  color: backgroundColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        //CẬP NHẬT SỐ LƯỢNG NGUYÊN LIỆU CỦA MÓN
                                        if (Utils.isAnyQuantityOrUnitChanged(
                                            recipeController.recipeOfFood)) {
                                          final result = await showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return CustomDialogUpdateQuantityRecipeDetail(
                                                food_id: widget.food.food_id,
                                              );
                                            },
                                          );
                                          if (result == 'success') {
                                            Utils.showStylishDialog(
                                                context,
                                                'THÀNH CÔNG',
                                                'Cập nhật nguyên liệu của món ${widget.food.name} thành công!',
                                                StylishDialogType.SUCCESS);
                                            setState(() {
                                              Utils.unSelectedAll(
                                                  ingredientController
                                                      .ingredients);
                                            });
                                          }
                                        }
                                      },
                                      child: CustomButtonIcon(
                                          label: 'LƯU LẠI',
                                          height: 40,
                                          iconColor: secondColor,
                                          icon: FontAwesomeIcons.check,
                                          backgroundColor:
                                              Utils.isAnyQuantityOrUnitChanged(
                                                      recipeController
                                                          .recipeOfFood)
                                                  ? colorSuccess
                                                  : grayColor,
                                          textStyle: const TextStyle(
                                            color: secondColor,
                                            fontSize: 10,
                                          )),
                                    ),
                                  ],
                                ),
                              );
                            })
                    ],
                  ),
                ),
              ),
            ),
          )
        : const RequiredRotatePhoneToLanscape();
  }
}
