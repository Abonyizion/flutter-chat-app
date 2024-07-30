
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/Net/AuthService.dart';

import '../Chat/ChatServices.dart';


class BlockedUsers extends StatelessWidget {
  BlockedUsers({super.key});

  final ChatServices chatService = ChatServices();
  final AuthService authService = AuthService();

  void _showUnblockBox(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unblock User'),
        content: const Text('Are you sure you want to Unblock this user?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              chatService.unblockUser(userId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    elevation: 5,
                    backgroundColor: Colors.green,
                    content: Text("User Unblocked",
                      style: TextStyle(fontWeight: FontWeight.bold),),
                  )
              );
            },
            child: const Text('Unblock'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String userId = authService.getCurrentUser()!.uid;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blocked Users', style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 25),),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.green,
        ),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: chatService.getBlockedUsersStream(userId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error Loading'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(),
            );
          }
          final blockedUsers = snapshot.data ?? [];

          if (blockedUsers.isEmpty) {
            return const Center(child:
            Padding(
              padding: EdgeInsets.only(left: 18),
              child: Text('No blocked users, long press on a users chat bubble to block a users'
              ,style: TextStyle(fontSize: 20),),
            ),
            );
          }
          return ListView.builder(
              itemCount: blockedUsers.length,
            itemBuilder: (context, index) {
                final user = blockedUsers[index];
                return ListTile(
                  title: Text(user["email"].toString(),
                    style: const TextStyle(fontSize: 18),),
                  onTap: () => _showUnblockBox(context, user['uid']),

                );
            },
          );
        },
      )
    );
  }
}
