
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/pages/AboutPage.dart';

import '../Chat/ChatServices.dart';
import '../pages/BlockedUsersPage.dart';
import '../pages/NotificationPage.dart';
import '../pages/RatingPage.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  ThemeMode _themeMode = ThemeMode.system;
  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }
  @override
  Widget build(BuildContext context) {
   // final _themeProvider = Provider.of<ChatServices>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('SETTINGS', style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 25),),
        centerTitle: true,
      ),
      body: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: SingleChildScrollView(
            child: Column(
             // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(
                            Icons.contrast),
                        title: const Text('Theme', style: TextStyle(fontSize: 18),),
                        onTap: () {
                          showDialog(
                            barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Choose theme'),
                                  content: CupertinoSwitch(
                                    value: Provider.of<ChatServices>(context, listen: false).isDarkMode,
                                    onChanged: (value) => Provider.of<ChatServices>(context, listen: false).toggleTheme(),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Ok'),),
                                  ],
                                );
                              });
                        },
                      ),
                      ListTile(
                        leading: const Icon(
                            Icons.block),
                        title: const Text('Blocked Users', style: TextStyle(fontSize: 18),),
                        onTap: () {
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context) => BlockedUsers()),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(
                            Icons.rate_review),
                        title: const Text('Rating', style: TextStyle(fontSize: 18),),
                        onTap: () {
                            Navigator.push(context,
                              MaterialPageRoute(builder: (context) => const RatingPage()),
                            );
                        },
                      ),
                      ListTile(
                        leading: const Icon(
                            Icons.notifications),
                        title: const Text('Notifications', style: TextStyle(fontSize: 18),),
                        onTap: () {
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const NotificationPage()),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(
                            Icons.info),
                        title: const Text('About', style: TextStyle(fontSize: 18),),
                        onTap: () {
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const AboutPage()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 270,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 35),
                  child: ListTile(
                    leading: const Icon(
                        Icons.logout),
                    title: const Text('Sign Out', style: TextStyle(
                        fontSize: 18, color: Colors.red, fontWeight: FontWeight.bold), ),
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                    },
                  ),
                ),
               // const Text('Logged in as'),
              //  const Text('$user.email!'),
              ],
            ),
          ),
        ),
     // ),
    );
  }
}
