import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/pages/HomePage.dart';
import 'package:untitled1/pages/LoginPage.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // when user is logged in
          if (snapshot.hasData) {
            Navigator.maybePop(context);
            return const HomePage();
          }
          else {
            //if user is not logged in
            return const LoginPage();
          }
        },
      ),
    );
  }
}
