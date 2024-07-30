import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'AuthGate.dart';
import 'Chat/ChatServices.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options:
  const FirebaseOptions(
    apiKey: "AIzaSyACUa9DfxSX1w2wL6njiGuAYNjzMtlqo8k",
    appId: "1:482726301642:android:84b1e2b41870bc96fc0933",
    messagingSenderId: '482726301642',
    projectId: "chatapp-1ac8f",
    storageBucket: "chatapp-1ac8f.appspot.com"
    ),
  );
  runApp(
    ChangeNotifierProvider(
        create: (context) => ChatServices(),
    child: const MyApp(),)
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: Provider.of<ChatServices>(context).themeData,
      home: const AuthGate(),
    );
  }
}
