
import 'dart:ui';
 // import 'package:badges/badges.dart' as badges;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'package:provider/provider.dart';

// import '../Chat/ChatServices.dart';
import '../pages/ChatPage.dart';
import '../pages/NotificationPage.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final searchTextController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CHATS', style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 25),),
       // backgroundColor: Colors.grey[300],
       // centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: IconButton(
                onPressed: () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const NotificationPage()),
                  );
                },
                icon: const Icon(Icons.notifications_none_outlined),
              iconSize: 30.0,
            ),
          ),
        ],
      ),
        body: _buildUserList(),
    /*  floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        foregroundColor: Colors.black,
        hoverColor: Colors.cyan,
        onPressed: () {  },
        child: const Icon(Icons.add, color: Colors.white),

      ),*/
    );
  }

  // build a list of users except for the current logged in user
  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot> (
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('error');
      }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Text('Loading...', style: TextStyle(
              fontSize: 25
             ),
            ),
          );
        }
        return ListView(
          children: snapshot.data!.docs.map<Widget> ((doc) => _buildUserListItem(doc))
        .toList(),
        );
      },
    );
  }

  //build individual list item
  Widget _buildUserListItem (DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    // display all users except current user
    if (_auth.currentUser!.email != data['email']) {
      return Card(
        elevation: 0,
            child: ListTile(
              title: Text(data["email"].toString(),
                style: const TextStyle(fontSize: 18),),
              // subtitle: Text(data['email'], style: const TextStyle(fontSize: 12),),
              leading: Container(
                height: 45,
                width: 45,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey,
                ),
                alignment: Alignment.center,
                child: Icon(Icons.person, color: Colors.grey[600],),
              ),
              onTap: () {
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) =>
                      ChatPage(
                        receiverUserName: data['name'],
                        receiverUserEmail: data['email'],
                        receiverUserID: data['uid'],
                      ),
                  ),
                );
              },
         ),
      );
    } else {
      return Container();
    }
  }
}
