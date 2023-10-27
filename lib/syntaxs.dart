// var orderCollection =
//               await firestore.collection("orders").doc(order_id).get();
//           var orderData = orderCollection.data();

//           double totalAmountOrigin = 0;
//           if (orderCollection.exists && orderData is Map<String, dynamic>) {
//             double totalAmountCurrent = orderCollection['total_amount'] ?? 0;
//             await firestore.collection("orders").doc(order_id).update({
//               "total_amount": totalAmount + totalAmountCurrent,
//             });
//           }