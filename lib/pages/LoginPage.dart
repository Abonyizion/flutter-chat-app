import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Net/Cloudfirestore.dart';
import 'RegisterPage.dart';
import 'ResetPasswordPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();


  @override
  void dispose() {
    emailTextController.dispose();
    passwordTextController.dispose();
    super.dispose();
  }

  bool passwordVisible = false;
  // method to sign user in with email and password
  void signUserIn() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(color: Colors.green,),
        );
      },
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailTextController.text.trim(),
          password: passwordTextController.text.trim());
     if (!mounted) return;
      Navigator.pushReplacementNamed(context, 'HomePag');
    //  userSetup(nameTextController.text, emailTextController.text, passwordTextController.text);
      if (!mounted) return;
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      showErrorMessage(e.code);
    }
  }
  // showing error message to user
  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.red,
          title: Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // backgroundColor: Colors.grey[100],
        body: Center(
        child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 25.0),
                          child: Text('Login',  style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 40, color:
                          Colors.green
                           ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: TextField(
                        textCapitalization: TextCapitalization.sentences,
                        controller: emailTextController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(8.0),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green.shade200),
                            ),
                           prefixIcon: const Icon(
                            Icons.mail),
                           // fillColor: Colors.grey.shade300,
                            filled: true,
                            labelText: 'Email',

                           // labelStyle: const TextStyle( color: Colors.black45)
                       ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: TextField(
                          obscureText: passwordVisible ? false : true,
                          controller: passwordTextController,
                          decoration: InputDecoration(
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            contentPadding: const EdgeInsets.all(8.0),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.green.shade200),
                              ),
                              prefixIcon: const Icon(
                              Icons.lock),
                              suffixIcon: IconButton(
                                icon:  Icon(passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    passwordVisible = !passwordVisible;
                                  });
                                },
                              ),
                            //  fillColor: Colors.grey.shade300,
                              filled: true,
                              labelText: 'Password',
                             // labelStyle: const TextStyle( color: Colors.black45)
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(context,
                              MaterialPageRoute(builder: (context) => const ResetPasswordPage()),
                              );
                            },
                          child: const Padding(
                            padding: EdgeInsets.only(right: 15.0),
                            child: Text('Forgot Password?',  style: TextStyle(
                             fontWeight: FontWeight.bold, fontSize: 15, color:
                             Colors.green
                            ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                        GestureDetector(
                          onTap: signUserIn,
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
                                child: Text('Login',   style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20, color:
                                Colors.white,
                                 ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    const SizedBox(
                      height: 30,
                    ),


                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('New Here?', style: TextStyle(
                          fontSize: 15,
                        ),),
                        TextButton(
                          onPressed: () {
                            Navigator.push(context,
                              MaterialPageRoute(builder: (context) => const RegisterPage()),
                            );
                          },
                          child: const Text('Register', style: TextStyle(
                            fontSize: 20, color: Colors.green,
                           ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Card(
                          elevation: 5,
                          child: IconButton(
                            onPressed: () {},
                            icon: const FaIcon(FontAwesomeIcons.google, color: Colors.red,),
                          ),
                        ),
                        Card(
                          elevation: 5,
                          child: IconButton(
                            onPressed: () {},
                            icon: const FaIcon(FontAwesomeIcons.facebook, color: Colors.blue,),
                          ),
                        ),
                        Card(
                          elevation: 5,
                          child: IconButton(
                            onPressed: () {},
                            icon: const FaIcon(FontAwesomeIcons.apple, color: Colors.black,),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
            ),
          ),
        ),
    );
  }
}
