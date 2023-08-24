import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String senderName;
  final String senderprofilePhoto;
  final String receierId;
  final String receierName;
  final String receierprofilePhoto;
  final String message;
  final Timestamp timestamp;

  Message(
      {required this.senderId,
      required this.senderName,
      required this.senderprofilePhoto,
      required this.receierId,
      required this.receierName,
      required this.receierprofilePhoto,
      required this.message,
      required this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderName': senderName,
      'senderprofilePhoto': senderprofilePhoto,
      'receierId': receierId,
      'receierName': receierName,
      'receierprofilePhoto': receierprofilePhoto,
      'message': message,
      'timestamp': timestamp,
    };
  }
}
