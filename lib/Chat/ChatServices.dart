import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/Model/message.dart';
import 'package:untitled1/ThemeData/LightMode.dart';
import '../ThemeData/DarkMode.dart';

class ChatServices extends ChangeNotifier{
  //instances of auth and firestore
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //send message
Future<void> sendMessage(String receiverId, String message) async {
  final String currentUserId = _firebaseAuth.currentUser!.uid;
  final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
  final Timestamp timestamp = Timestamp.now();
  //create a new message
  Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      receiverId: receiverId,
      message: message,
      timestamp: timestamp
  );
  List<String> ids = [currentUserId, receiverId];
  ids.sort();
  String chatRoomId = ids.join(
    "_");
  //add new message to database
  await _firestore
  .collection('chat_room')
  .doc(chatRoomId)
  .collection('messages')
  .add(newMessage.toMap());
}
//receive message
Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
  List<String> ids = [userId, otherUserId];
  ids.sort();
  String chatRoomId = ids.join("_");

  return _firestore
      .collection('chat_room')
      .doc(chatRoomId)
      .collection('messages')
      .orderBy('timestamp', descending: true)
      .snapshots();
  }

  //get allUsers except the current user and blocked users
  Stream<List<Map<String, dynamic>>> getUsersStreamExceptBlocked() {
    final currentUser = _firebaseAuth.currentUser;

    return _firestore
        .collection('Users')
        .doc(currentUser!.uid)
        .collection('BlockedUsers')
        .snapshots()
        .asyncMap((snapshot) async {
          //get blocked users
      final blockedUserIds = snapshot.docs.map((doc) => doc.id).toList();
      //getting all users
      final usersSnapshot = await _firestore.collection('Users').get();
      //return as stream list
      return usersSnapshot.docs
          .where((doc) =>
      doc.data()['email'] != currentUser.email &&
      !blockedUserIds.contains(doc.id))
          .map((doc) => doc.data())
          .toList();
    });
  }

//Report user
  Future<void> reportUser (String messageId, String userId) async {
  final currentUser = _firebaseAuth.currentUser;
  final report = {
    'reportedBy': currentUser!.uid,
    'messageId': messageId,
    'messageOwnerId': userId,
    'timestamp': FieldValue.serverTimestamp(),
  };
  await _firestore.collection('Reports').add(report);
  }
  //Block user
  Future<void> blockUser(String userId) async {
    final currentUser = _firebaseAuth.currentUser;
    await _firestore
    .collection('users')
    .doc(currentUser!.uid)
    .collection('BlockedUsers')
    .doc(userId)
    .set({});
    notifyListeners();
  }

  //Unblock user
  Future<void> unblockUser(String blockedUserId) async {
    final currentUser = _firebaseAuth.currentUser;
    await _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('BlockedUsers')
        .doc(blockedUserId)
        .delete();
    notifyListeners();
  }

  //get blocked user stream
  Stream<List<Map<String, dynamic>>> getBlockedUsersStream(String userId) {
  return _firestore
      .collection('Users')
      .doc(userId)
      .collection('BlockedUsers')
      .snapshots()
      .asyncMap((snapshot) async {
        final blockedUserIds = snapshot.docs.map((doc) => doc.id).toList();

        final userDocs = await Future.wait(
          blockedUserIds
          .map((id) => _firestore.collection('users').doc(id).get()),
        );
        return userDocs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  } );

  }



  // method to toggle between light mode and dark mode
   ThemeData _themeData = lightMode;
   ThemeData get themeData => _themeData;
   bool get isDarkMode => _themeData == darkMode;

   set themeData(ThemeData themeData) {
     _themeData = themeData;
     notifyListeners();
   }
   void toggleTheme() {
     if (_themeData == lightMode) {
       themeData = darkMode;
     } else {
       themeData = lightMode;
     }
   }

}