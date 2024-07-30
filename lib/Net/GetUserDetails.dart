import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetUserName extends StatelessWidget {
  final String documentId;
  const GetUserName({super.key, required this.documentId});

  @override
  Widget build(BuildContext context) {
    // getting the collection reference
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(documentId).get(),
        builder: ( (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Text('Full Name: ${data['name']}');
          }
          return const Text('Loading...');
        }
        ),
    );
  }
}
