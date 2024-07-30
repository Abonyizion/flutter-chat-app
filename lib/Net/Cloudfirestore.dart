
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';

Future<void> userSetup (String name, email, password) async {

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  FirebaseAuth auth = FirebaseAuth.instance;
  String? uid = auth.currentUser?.uid.toString();
  users.add({
    'uid': uid,
    'email': email,
    'name': name,
    'password': password,
    'imageURL': 'empty',
    'bio': 'empty'
  });
  return;
}



