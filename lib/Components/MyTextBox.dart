import 'package:flutter/material.dart';

class MyTextBox extends StatelessWidget {
  final String text;
  final String sectionName;
  final void Function()? onPressed;
  const MyTextBox({super.key, required this.text,
    required this.sectionName,
  required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
       decoration: BoxDecoration(
         borderRadius: BorderRadius.circular(10)
       ),
        padding: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
        margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(sectionName, style: const TextStyle(
                  fontSize: 18,),),
                IconButton(
                    onPressed: onPressed,
                    icon: const Icon(Icons.settings))
              ],
            ),
            Text(text, style: const TextStyle(
              fontSize: 22, fontWeight: (FontWeight.bold),),)
          ],
        ),
    );
  }
}
