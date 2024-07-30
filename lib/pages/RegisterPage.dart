
 // import 'dart:js_interop';

 //  import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'LoginPage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final nameTextController = TextEditingController();
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final firebaseUser = FirebaseAuth.instance.currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? get currentUser => _auth.currentUser;

  @override
  void dispose() {
    nameTextController.dispose();
    emailTextController.dispose();
    passwordTextController.dispose();
    confirmPasswordTextController.dispose();
    super.dispose();
  }
  //boolean to keep track of password visibility
  bool passwordVisible = false;

  void _creatNewUserInFirestore(String email, name)  {
    final User? user = currentUser;
    final CollectionReference<Map<String, dynamic>> userRef =
    _firestore.collection('users');
    userRef.doc(user?.uid).set({
      'uid': user?.uid,
      'email': email,
      'name': name,
      'imageURL': 'empty',
      'bio': 'empty'
    });
  }

  Future<void> createUserWithEmailAndPassword() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(color: Colors.green,),
        );
      },
    );
    try {
      if (passwordTextController.text == confirmPasswordTextController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailTextController.text,
          password: passwordTextController.text,
        );
        _creatNewUserInFirestore(emailTextController.text, nameTextController.text);

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              elevation: 5,
              backgroundColor: Colors.red,
              content: Text("wrong password combination",
                style: TextStyle(fontWeight: FontWeight.bold),),
            )
        );
      }
      if (!mounted) return;
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
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
                      child: Text('Register',  style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 40, color:
                      Colors.green
                      ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 14,
                ),
                Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: TextField(
                    textCapitalization: TextCapitalization.sentences,
                    controller: nameTextController,
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      contentPadding: const EdgeInsets.all(8.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green.shade200),
                      ),
                      prefixIcon: const Icon(
                          Icons.person),
                      // fillColor: Colors.grey.shade300,
                      filled: true,
                      labelText: 'Profile Name',
                      // labelStyle: const TextStyle( color: Colors.black45)
                    ),
                  ),
                ),
                const SizedBox(
                  height: 14,
                ),
                Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: TextField(
                    //textCapitalization: TextCapitalization.sentences,
                    controller: emailTextController,
                    decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      contentPadding: const EdgeInsets.all(8.0),
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
                  height: 13,
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
                         // fillColor: Colors.grey.shade300,
                          filled: true,
                          labelText: 'Password',
                        //  labelStyle: const TextStyle( color: Colors.black45)
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                Center(
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: TextField(
                      obscureText: passwordVisible ? false : true,
                      controller: confirmPasswordTextController,
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
                         // fillColor: Colors.grey.shade300,
                          filled: true,
                          labelText: ' Confirm Password',
                         // labelStyle: const TextStyle( color: Colors.black45)
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                GestureDetector(
                  onTap: createUserWithEmailAndPassword,
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
                        child: Text('Register',   style: TextStyle(
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
                    const Text('Already a Member?', style: TextStyle(
                      fontSize: 15
                    ),),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                        );
                      },
                      child: const Text('Login', style: TextStyle(
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