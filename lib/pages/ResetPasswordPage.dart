import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final emailTextController = TextEditingController();

  @override
  void dispose() {
    emailTextController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
          email: emailTextController.text.trim());
      if (!mounted) return;
      showDialog(
          context: context,
          builder: (context)  {
            return AlertDialog(
              content: const Text('password reset link sent! check your email'),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple
                    ),
                    child: const Text('OK'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            );
          }
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      showDialog(
          context: context,
          builder: (context)  {
            return AlertDialog(
              content: Text(e.message.toString()),
              actions: [
                TextButton(
                  child: const Text('OK', style: TextStyle(color: Colors.green, fontSize: 17),),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            );
          }
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.grey[300],
      appBar:  AppBar(
       // backgroundColor: Colors.grey[300],
        iconTheme: const IconThemeData(
          color: Colors.green,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(30),
              child: Center(
                child: Text('Forgot password?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, color: Colors.green),),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 30),
              child: Center(
                child: Text('Enter your email address below and we will send you a password reset link',
                  style: TextStyle(fontSize: 13),),
              ),
            ),
            const SizedBox(
              height: 15,
            ),

            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: TextField(
                textCapitalization: TextCapitalization.sentences,
                controller: emailTextController,
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear, color: Colors.grey[500],),
                      onPressed: () {
                        emailTextController.clear();
                      },
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                  contentPadding: const EdgeInsets.all(8.0),
                   // fillColor: Colors.grey.shade200,
                    filled: true,
                    labelText: 'Email',
                   // labelStyle: const TextStyle( color: Colors.grey)
                ),
              ),
            ),

            const SizedBox(
              height: 25,),

            GestureDetector(
              onTap: passwordReset,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text('Reset Password',   style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20, color:
                    Colors.white,
                    ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
