import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/vats/vats_controller.dart';
import 'package:myorder/views/screens/managements/vats/add_vat_screen.dart';
import 'package:myorder/views/screens/managements/vats/detail_vat_screen.dart';
import 'package:myorder/views/widgets/dialogs.dart';

class ManagementVatsPage extends StatefulWidget {
  const ManagementVatsPage({Key? key}) : super(key: key);
  @override
  _ManagementVatsPageState createState() => _ManagementVatsPageState();
}

class _ManagementVatsPageState extends State<ManagementVatsPage> {
  VatController vatController = Get.put(VatController());

  @override
  Widget build(BuildContext context) {
    vatController.getVats();

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
          title: const Center(child: Text("QUẢN LÝ VATS")),
          actions: [
            Container(
                margin: const EdgeInsets.only(right: 10),
                child: InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddVatPage())),
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
                        itemCount: vatController.vats.length,
                        itemBuilder: (context, index) {
                          final vat = vatController.vats[index];
                          String string;
                          return Card(
                            child: ListTile(
                              leading: const Icon(Icons.ac_unit),
                              title: Row(
                                children: [
                                  InkWell(
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => VatDetailPage(
                                                  vatId: vat.vat_id,
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
                                        vat.name,
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
                                        builder: (context) => VatDetailPage(
                                            vatId: vat.vat_id))),
                                child: RichText(
                                  text: TextSpan(
                                    text: vat.active == ACTIVE
                                        ? "Đang hoạt động"
                                        : "Ngừng hoạt động",
                                    style: vat.active == ACTIVE
                                        ? const TextStyle(color: Colors.green)
                                        : const TextStyle(
                                            color: Colors
                                                .grey), // Đặt kiểu cho văn bản
                                  ),
                                  maxLines: 5, // Giới hạn số dòng hiển thị
                                  overflow: TextOverflow
                                      .ellipsis, // Hiển thị dấu ba chấm khi văn bản quá dài
                                ),
                              ),
                              trailing: InkWell(
                                onTap: () => {
                                  string =
                                      vat.active == ACTIVE ? "ngừng hoạt động" : "hoạt động trở lại",
                                  showCustomAlertDialogConfirm(
                                    context,
                                    "TRẠNG THÁI HOẠT ĐỘNG",
                                    "Bạn có chắc chắn muốn $string đơn vị tính này?",
                                    () async {
                                      await vatController.updateToggleActive(
                                          vat.vat_id, vat.active);
                                    },
                                  )
                                },
                                child: vat.active == ACTIVE
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
