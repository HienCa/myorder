import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/foods/foods_controller.dart';
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
  Widget build(BuildContext context) {
    foodController.getfoods();

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
                            child: ListTile(
                              leading: InkWell(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FoodDetailPage(
                                              foodId: food.food_id,
                                              name: '',
                                              price: food.price,
                                              active: food.active,
                                              vat_id: food.vat_id,
                                              category_id: food.category_id,
                                              unit_id: food.unit_id,
                                            ))),
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
                              title: Row(
                                children: [
                                  InkWell(
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                FoodDetailPage(
                                                  foodId: food.food_id,
                                                  name: '',
                                                  price: food.price,
                                                  active: food.active,
                                                  vat_id: food.vat_id,
                                                  category_id: food.category_id,
                                                  unit_id: food.unit_id,
                                                ))),
                                    child: Marquee(
                                      direction: Axis.horizontal,
                                      textDirection: TextDirection.ltr,
                                      animationDuration:
                                          const Duration(seconds: 1),
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
                                ],
                              ),
                              subtitle: InkWell(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FoodDetailPage(
                                              foodId: food.food_id,
                                              name: '',
                                              price: food.price,
                                              active: food.active,
                                              vat_id: food.vat_id,
                                              category_id: food.category_id,
                                              unit_id: food.unit_id,
                                            ))),
                                child: RichText(
                                  text: TextSpan(
                                    text: "${food.price}",
                                    style: const TextStyle(
                                        color: Colors
                                            .black), // Đặt kiểu cho văn bản
                                  ),
                                  maxLines: 5, // Giới hạn số dòng hiển thị
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
