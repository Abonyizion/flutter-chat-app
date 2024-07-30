
import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // backgroundColor: Colors.grey[100],
      appBar: AppBar(
       // title: const Text('Notifications'),
        iconTheme: const IconThemeData(
          color: Colors.green,
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('No new Notifications', style: TextStyle(fontSize: 25),),
          ],
        ),
      ),
    );
  }
}
