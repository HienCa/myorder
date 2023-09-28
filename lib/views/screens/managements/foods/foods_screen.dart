import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/foods/foods_controller.dart';
import 'package:myorder/utils.dart';
import 'package:myorder/views/screens/managements/foods/add_food_screen.dart';
import 'package:myorder/views/screens/managements/foods/detail_food_screen.dart';
import 'package:myorder/views/widgets/dialogs.dart';

class ManagementFoodsPage extends StatefulWidget {
  const ManagementFoodsPage({Key? key}) : super(key: key);
  @override
  _ManagementFoodsPageState createState() => _ManagementFoodsPageState();
}

class _ManagementFoodsPageState extends State<ManagementFoodsPage> {
  FoodController foodController = Get.put(FoodController());
  @override
  void initState() {
    super.initState();
    foodController.getfoods("");
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
      home: Scaffold(
        appBar: AppBar(
          leading: InkWell(
              onTap: () => {Navigator.pop(context)},
              child: const Icon(Icons.arrow_back_ios)),
          title: const Center(child: Text("QUẢN LÝ MÓN")),
          actions: [
            Container(
                margin: const EdgeInsets.only(right: 10),
                child: InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddFoodPage())),
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(Icons.add_circle_outline),
                    )))
          ],
          backgroundColor: primaryColor,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
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
                      foodController.getfoods(value);
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
                      hintText: 'Tìm kiếm món ăn ...',
                      hintStyle: TextStyle(color: borderColorPrimary),
                    ),
                    cursorColor: borderColorPrimary,
                  ),
                ),
                marginTop10,
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.87,
                  child: Obx(() {
                    return ListView.builder(
                        itemCount: foodController.foods.length,
                        itemBuilder: (context, index) {
                          final food = foodController.foods[index];
                          String string;
                          return Card(
                            color: food.active == 1
                                ? backgroundColor
                                : const Color.fromARGB(255, 213, 211, 211),
                            child: ListTile(
                              leading: InkWell(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FoodDetailPage(
                                            food:
                                                foodController.foods[index]))),
                                child: food.image != ""
                                    ? CircleAvatar(
                                        radius: 25,
                                        backgroundColor: Colors.black,
                                        backgroundImage:
                                            NetworkImage(food.image!),
                                      )
                                    : CircleAvatar(
                                        child: Image.asset(
                                          'assets/images/user-default.png',
                                          width: 100,
                                          height: 100,
                                        ),
                                      ),
                              ),
                              title: InkWell(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FoodDetailPage(
                                              food: food,
                                            ))),
                                child: Marquee(
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
                              ),
                              subtitle: InkWell(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FoodDetailPage(
                                              food: food,
                                            ))),
                                child: RichText(
                                  text: food.price_with_temporary! != 0
                                      ? (Utils.isDateTimeInRange(
                                              food.temporary_price_from_date!,
                                              food.temporary_price_to_date!)
                                          ? (food.price_with_temporary! > 0
                                              ? TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: Utils
                                                          .formatCurrency(food
                                                                  .price +
                                                              (food.price_with_temporary ??
                                                                  0)),
                                                      style: const TextStyle(
                                                        color: colorPrice,
                                                      ),
                                                    ),
                                                    const WidgetSpan(
                                                      child: Icon(
                                                        Icons
                                                            .arrow_drop_up, // Thay thế bằng biểu tượng bạn muốn sử dụng
                                                        size:
                                                            24.0, // Điều chỉnh kích thước biểu tượng
                                                        color:
                                                            colorPriceIncrease, // Điều chỉnh màu sắc của biểu tượng
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: Utils
                                                          .formatCurrency(food
                                                                  .price +
                                                              (food.price_with_temporary ??
                                                                  0)),
                                                      style: const TextStyle(
                                                        color: colorPrice,
                                                      ),
                                                    ),
                                                    const WidgetSpan(
                                                      child: Icon(
                                                        Icons
                                                            .arrow_drop_down, // Thay thế bằng biểu tượng bạn muốn sử dụng
                                                        size:
                                                            24.0, // Điều chỉnh kích thước biểu tượng
                                                        color:
                                                            colorPriceDecrease, // Điều chỉnh màu sắc của biểu tượng
                                                      ),
                                                    ),
                                                  ],
                                                ))
                                          : TextSpan(
                                              text: Utils.formatCurrency(
                                                  food.price),
                                              style: const TextStyle(
                                                color: colorPrice,
                                              ),
                                            ))
                                      : TextSpan(
                                          text:
                                              Utils.formatCurrency(food.price),
                                          style: const TextStyle(
                                            color: colorPrice,
                                          ),
                                        ),
                                  maxLines: 5,
                                  overflow: TextOverflow
                                      .ellipsis, // Hiển thị dấu ba chấm khi văn bản quá dài
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
                                    "Bạn có chắc chắn muốn $string món này?",
                                    () async {
                                      await foodController.updateToggleActive(
                                          food.food_id, food.active);
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
                          );
                        });
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
