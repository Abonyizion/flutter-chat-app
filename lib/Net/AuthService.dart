import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  //instance of auth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? get currentUser => _auth.currentUser;

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  //sign up
   Future<UserCredential> signUserUp(String email, password, name) async {
     try {
       UserCredential userCredential =
           await _auth.createUserWithEmailAndPassword(
               email: email,
               password: password,
           );
       _firestore.collection('users').doc(userCredential.user!.uid)
           .set({
         'uid': userCredential.user!.uid,
         'email': email,
         'name': name,
         'imageURL': 'empty',
         'bio': 'empty'
       });
       return userCredential;
     } on FirebaseAuthException catch (e) {
       throw Exception(e.code);
     }

   }

}