// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Correct import for Firestore
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/models/ingredient.dart';
import 'package:myorder/models/recipe_detail.dart';
import 'package:myorder/models/vat.dart';
import 'package:myorder/models/vat.dart' as model;
import 'package:myorder/utils.dart';

class RecipeController extends GetxController {
  getVatById(String vat_id) async {
    try {
      DocumentSnapshot Vat =
          await firestore.collection('vats').doc(vat_id).get();
      if (Vat.exists) {
        final userData = Vat.data();
        if (userData != null && userData is Map<String, dynamic>) {
          String vat_id = userData['vat_id'] ?? '';
          String name = userData['name'] ?? '';
          int vat_percent = userData['vat_percent'] ?? 0;

          int active = userData['active'] ?? 1;
          return model.Vat(
              vat_id: vat_id,
              name: name,
              active: active,
              vat_percent: vat_percent);
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return Vat(vat_id: vat_id, name: "", active: 1, vat_percent: 0);
    }
  }

  final Rx<List<RecipeDetail>> _recipeOfFood = Rx<List<RecipeDetail>>([]);
  List<RecipeDetail> get recipeOfFood => _recipeOfFood.value;
  getRecipeOfFood(
    String food_id,
    String keySearch,
  ) async {
    if (keySearch.isEmpty) {
      _recipeOfFood.bindStream(
        firestore
            .collection('foods')
            .doc(food_id)
            .collection('recipes')
            .snapshots()
            .asyncMap(
          (QuerySnapshot query) async {
            List<RecipeDetail> retValue = [];
            for (var element in query.docs) {
              RecipeDetail recipeDetail = RecipeDetail.fromSnap(element);
              recipeDetail.new_quantity = recipeDetail.quantity;
              retValue.add(recipeDetail);
            }
            return retValue;
          },
        ),
      );
    } else {
      _recipeOfFood.bindStream(firestore
          .collection('foods')
          .doc(food_id)
          .collection('recipes')
          .snapshots()
          .asyncMap((QuerySnapshot query) async {
        List<RecipeDetail> retVal = [];
        for (var elem in query.docs) {
          String name = elem['name'].toLowerCase();
          String search = keySearch.toLowerCase().trim();
          if (name.contains(search)) {
            RecipeDetail recipeDetail = RecipeDetail.fromSnap(elem);
            recipeDetail.new_quantity = recipeDetail.quantity;

            retVal.add(recipeDetail);
          }
        }
        return retVal;
      }));
    }
  }

  Future<void> createRecipe(
      String food_id, List<Ingredient> ingredients) async {
    try {
      if (ingredients.isNotEmpty) {
        for (Ingredient ingredient in ingredients) {
          if (ingredient.isSelected == true) {
            String id = Utils.generateUUID();
            CollectionReference usersCollection = FirebaseFirestore.instance
                .collection('foods') 
                .doc(food_id)
                .collection("recipes"); 
            RecipeDetail recipeDetail = ingredient.recipeDetail!;
            recipeDetail.recipe_detail_id = id;
            await usersCollection.doc(id).set(recipeDetail.toJson());
          }
        }
      } else {
        Get.snackbar(
          'Error!',
          'Thêm thất bại!',
          backgroundColor: backgroundFailureColor,
          colorText: Colors.white,
        );
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Error!',
        e.message ?? 'Có lỗi xãy ra.',
      );
    } catch (e) {
      Get.snackbar(
        'Error!',
        e.toString(),
      );
    }
  }

  //CẬP NHẬT SỐ LƯỢNG NGUYÊN LIỆU MÓN
  updateRecipeDetail(String food_id, List<RecipeDetail> recipeDetails) async {
    try {
      if (food_id.isNotEmpty) {
        for (RecipeDetail recipeDetail in recipeDetails) {
          if (recipeDetail.quantity != recipeDetail.new_quantity) {
            await firestore
                .collection('foods')
                .doc(food_id)
                .collection("recipes")
                .doc(recipeDetail.recipe_detail_id)
                .update({
              "quantity": recipeDetail.new_quantity,
            });
          }
        }
      }

      update();
    } catch (e) {
      Get.snackbar(
        'Cập nhật thất bại!',
        e.toString(),
        backgroundColor: backgroundFailureColor,
        colorText: Colors.white,
      );
    }
  }

  //XÓA NGUYÊN LIỆU MÓN
  deleteRecipeDetail(String food_id, RecipeDetail recipeDetail) async {
    try {
      if (food_id.isNotEmpty && recipeDetail.recipe_detail_id.isNotEmpty) {
        await firestore
            .collection('foods')
            .doc(food_id)
            .collection("recipes")
            .doc(recipeDetail.recipe_detail_id)
            .delete();
      }

      update();
    } catch (e) {
      Get.snackbar(
        'Cập nhật thất bại!',
        e.toString(),
        backgroundColor: backgroundFailureColor,
        colorText: Colors.white,
      );
    }
  }

  //KHO
  /*
  THIẾT LẬP SỐ LƯỢNG CẦN PHỤC VỤ TRONG NGÀY
  TIẾN HÀNH NHẬP KHO THEO SỐ LƯỢNG MÓN DỰA THEO CÔNG THỨC (THAM KHẢO)

  
  VD MÌ CÀY
  Cách nấu Mì cay kim chi thập cẩm
  GÓI MỲ 1gói/vắt
  THỊT BÒ 20gram
  Tôm 2con
  Nấm kim châm 20g
  Kim chi 20g
  Mực 3khoanh
  Cá viên 2 viên cắt đôi
  Xúc xích Đức 2 lát cắt xéo 1/2 cây
  Ớt cấp độ 1 thìa cho 1 cấp độ
  Nước dùng 500ml
  Cải tím 20g
  Ngò gai tùy khẩu vị
  Húng quế tùy khẩu vị

Cách thực hiện:
Bước 1: Cho các nguyên liệu bao gồm Mì Ramen, Tôm, Mực, Cá Viên, Xúc Xích Đức, Ớt chia cấp độ (1 cấp bằng 1 thìa cà phê) vào thố mì cay size 8, rồi cho tầm 500 ml lít nước dùng vào và đun sôi tầm 4 phút.
Bước 2: Đun sôi các nguyên liệu tới tầm 3,35 phút thì bạn cho kim chi, thịt bò, sắp nấm kim châm, rau cải tím, ngò lên trên bề mặt
Bước 3: Mang ra cho khách hàng thưởng thức khi còn sôi sục (Có thể ăn kèm với rau húng quế)

Cách nấu Mì cay kim chi hải sản
Mì Ramen (1 vắt)
Tôm (2 con)
Mực (3 khoanh)
Cá viên (2 viên)
Nấm kim châm (20gr)
Ớt cấp độ (mỗi thìa một cấp độ)
Nước dùng (500ml)
Rau cải tím (20g)
Rau húng quế, ngò gai (đủ dùng)

Cách thực hiện:
Bước 1: Cho nguyên liệu gồm Mì Ramen, Tôm, Mực, Cá Viên, Ớt cấp độ tùy cấp vào thố mì cay size 8 cùng nước dùng, đun sôi khoảng 4 phút.
Bước 2: Đợi các nguyên liệu đun sôi sau tầm 3,5 phút, sắp xếp các loại rau, nấm kim châm, ngò gai lên bề mặt nồi mì để sôi 30 giây, đậy nắp lại.
Bước 3: Tắt bếp và mang ra cho khách dùng 

Cách nấu Mì cay kim chi bò

Mì Ramen: (1 vắt)
Bò: (30gr)
Xúc xích Đức: (3 lát cắt xéo)
Cá viên: (2 viên)
Nấm kim châm: (20g)
Ớt cấp độ: (Mỗi thìa một cấp độ)
Kim chi: (20gr)
Nước dùng: (500ml)
Rau cải tím: (20gr)
Rau húng quế, ngò gai: (đủ dùng)

Cách thực hiện:
Bước 1: Cho Mì Ramen, Xúc Xích, Cá Viên, Ớt cấp độ tùy cấp vào thố mì cay size 8 cùng với nước dùng tầm 500ml rồi đun sôi trong vòng khoảng 4 phút.
Bước 2: Sau khi các nguyên liệu trước đã sôi tầm 3,5 phút thì bạn cho thịt bò vào, rồi lần lượt sắp các loại rau lên bề mặt, đậy nắp chờ sôi thêm 30 giây rồi tắt bếp.
Bước 3: Mang thố mì cay ra cho khách hàng thưởng thức (Có thể ăn kèm với rau húng quế)
   */
}
