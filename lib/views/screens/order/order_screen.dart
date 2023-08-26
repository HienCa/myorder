import 'package:flutter/material.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/views/screens/order/options_screen.dart';
import 'package:myorder/views/screens/order/search_box.dart';
import 'package:myorder/views/widgets/order_cart.dart';

class OrderPage extends StatelessWidget {
  const OrderPage ({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: <Widget>[
          SearchBox(onChanged: (value) {}),
          const OptionList(),
          Expanded(
            child: Stack(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 70),
                  decoration: const BoxDecoration(
                    color: kBackgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                ),
                ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) => OrderCard(
                    // itemIndex: index,
                    // product: products[index],
                    // press: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => DetailsScreen(
                      //       product: products[index],
                      //     ),
                      //   ),
                      // );
                    // },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
