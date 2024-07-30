
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.green,
        ),
        title: const Text('About Us', style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 25,
        ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 5,
              //  color: Colors.white,
                child: Container(
                  height: 100,
                  width: 160,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      ),
                  child: const Center(
                    child: Text('AMIGO', style: TextStyle(
                         fontWeight: FontWeight.bold,
                        fontSize: 45),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text('Connecting people', style: TextStyle(
                   fontWeight: FontWeight.bold,
                  fontSize: 25),
              ),
              const SizedBox(
                height: 13,
              ),
              const Text('Version 1.1.0', style: TextStyle(
                  fontSize: 17),
              ),
              const SizedBox(
                height: 13,
              ),
              const Text('© 2024 Zion Inc.', style: TextStyle(
                  fontSize: 17),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
