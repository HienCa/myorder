import 'package:flutter/material.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/views/screens/order/orderdetail/order_detail_screen.dart';
import 'package:myorder/views/screens/payment/payment_screen.dart';

class OrderCard extends StatelessWidget {
  //  const OrderCard({
  //   Key key,
  //   this.itemIndex,
  //   this.order,
  //   this.press,
  // }) : super(key: key);

  // final int itemIndex;
  // final Order order;
  // final Function press;

  @override
  Widget build(BuildContext context) {
    // It  will provide us total height and width of our screen
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: tableservingColor,
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
        vertical: kDefaultPadding / 2,
      ),
      // color: Colors.blueAccent,
      height: 160,
      child: InkWell(
        onTap: () => {},
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            // Those are our background
            Container(
              height: 136,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                color: kBlueColor,
                boxShadow: const [kDefaultShadow],
              ),
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
            ),
            // our order image
            Positioned(
              bottom: 0,
              left: -20,
              child: Hero(
                tag: 1,
                child: InkWell(
                  onTap: () => {
                    // Navigator.push(
                    // context,
                    // MaterialPageRoute(
                    //     builder: (context) => const OrderdetailPage()))
                  },
                  child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(22),
                          topRight: Radius.circular(22),
                        ),
                      ),
                      padding:
                          const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                      height: 160,
                      // image is square but we add extra 20 + 20 padding thats why width is 200
                      width: 200,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            22), // Thay đổi giá trị của borderRadius tùy theo nhu cầu
                        child: Image.asset(
                          "assets/images/table5.jpg",
                          fit: BoxFit.cover,
                        ),
                      )),
                ),
              ),
            ),
            // order title and price
            Positioned(
              top: 0,
              right: 0,
              child: SizedBox(
                height: 100,
                // our image take 200 width, thats why we set out total width - 200
                width: size.width - 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10, 
                      ),
                      decoration: const BoxDecoration(
                        color: kBlueColor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(22),
                        ),
                      ),
                      child: const Text(
                        "10:00",
                        style: textStyleWhiteBold20,
                      ),
                    ),
                    
                  ],
                ),
              ),
            ),
            Positioned(
              top: 22,
              right: 10,
              child: SizedBox(
                height: 136,
                // our image take 200 width, thats why we set out total width - 200
                width: size.width - 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: kDefaultPadding * 2, // 30 padding
                        vertical: kDefaultPadding / 4, // 5 top and bottom
                      ),
                      decoration: const BoxDecoration(
                        color: kBlueColor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(22),
                        ),
                      ),
                      child: const Text(
                        "500,000",
                        style: textStyleWhiteBold20,
                      ),
                    ),
                    const Spacer(),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: kDefaultPadding),
                      child: Text(
                        "Bàn A4",
                        style: textStylePrimaryBold,
                      ),
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: kDefaultPadding),
                      child: Text(
                        "A5, A6",
                        style: textStyleSecondBold,
                      ),
                    ),
                    // it use the available space
                    const Spacer(),
                    Container(
                      width: size.width - 200,
                      padding: const EdgeInsets.only(right: 10, bottom: 10),
                      // padding: const EdgeInsets.symmetric(
                      //   horizontal: kDefaultPadding * 2, // 30 padding
                      //   vertical: kDefaultPadding / 4, // 5 top and bottom
                      // ),
                      decoration: const BoxDecoration(
                        color: backgroundColor,
                        borderRadius:
                            BorderRadius.only(bottomRight: Radius.circular(20)),
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              height: 30,
                              width: 30,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                color: kBlueColor,
                              ),
                              child: InkWell(
                                  onTap: () => {},
                                  child: const Icon(Icons.more_horiz)),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              height: 30,
                              width: 30,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                color: kBlueColor,
                              ),
                              child: InkWell(
                                  onTap: () => {},
                                  child:
                                      const Icon(Icons.card_giftcard_outlined)),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              height: 30,
                              width: 30,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                color: kBlueColor,
                              ),
                              child: InkWell(
                                  onTap: () => {Navigator.push(context, MaterialPageRoute(builder: (context) => const PaymentPage()))},
                                  child:
                                      const Icon(Icons.receipt_long_outlined)),
                            ),
                          ]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
