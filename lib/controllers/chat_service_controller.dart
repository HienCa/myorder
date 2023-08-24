import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:myorder/models/message.dart';

import '../../../constants.dart';

class ChatService extends ChangeNotifier {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  //send mesage
  Future<void> sendMessage(String receierId, String message) async {
    // get current user info
    final String currentUserId = authController.user.uid;
    DocumentSnapshot userDoc =
        await firestore.collection('users').doc(authController.user.uid).get();
    final userData = userDoc.data()! as dynamic;
    String currentUserName = userData?['name'];
    String senderprofilePhoto = userData?['profilePhoto'];

    //get target user info
    DocumentSnapshot targetuserDoc =
        await firestore.collection('users').doc(receierId).get();
    final targetuserData = targetuserDoc.data()! as dynamic;
    String receierName = targetuserData?['name'];
    String receierprofilePhoto = targetuserData?['profilePhoto'];

    final Timestamp timestamp = Timestamp.now();
    //create a new message
    Message newMessage = Message(
        senderId: currentUserId,
        senderName: currentUserName,
        senderprofilePhoto: senderprofilePhoto,
        receierId: receierId,
        receierName: receierName,
        receierprofilePhoto: receierprofilePhoto,
        message: message,
        timestamp: timestamp);

    // construct chat room id from current user id and receier id from
    List<String> ids = [currentUserId, receierId];
    ids.sort();
    String chatRoomId = ids.join('_');
    //add new message to db
    await firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
  }

  //get message

  Stream<QuerySnapshot> getMessage(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join('_');

    return firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
