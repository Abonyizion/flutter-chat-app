
import 'package:five_pointed_star/five_pointed_star.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pannable_rating_bar/flutter_pannable_rating_bar.dart';

class RatingPage extends StatefulWidget {
  const RatingPage({super.key});

  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {

  double myCount = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rate Us', style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 25),),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.green,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: Card(
            child: Container(
              height: 250,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
               // color: Colors.green,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                     Text(myCount.toString(), style: const TextStyle(
                        fontSize: 35, fontWeight: FontWeight.bold),),
                    const SizedBox(
                      height: 8,
                    ),
                    const Text('Rate us 5 Star!', style: TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold),),
                    const Text('How was your App Experience?',
                      style: TextStyle(fontSize: 17),),
                    const SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 55),
                      child: PannableRatingBar(
                        rate: myCount,
                        items: List.generate(5, (index) =>
                          const RatingWidget(
                          selectedColor: Colors.green,
                        unSelectedColor: Colors.grey,
                            child: Icon(
                              Icons.star,
                              size: 25,
                            ),
                      ),
                      ),
                        onChanged: (double value) {
                          setState(() {
                            myCount = value;
                          });
                        },
                    ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                            
                    TextButton(
                        onPressed: () {
                          showDialog(
                            barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Thank you for Rating Us'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Ok', style: TextStyle(fontSize: 17),),),
                                  ],
                                );
                              }
                              );
                        },
                        child: const Text('Submit', style: TextStyle(fontSize: 20),),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

