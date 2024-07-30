
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

import '../Components/MyTextBox.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  final user = FirebaseAuth.instance.currentUser!;

  final nameTextController = TextEditingController();
  final phoneTextController = TextEditingController();
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  @override
  void dispose() {
    nameTextController.dispose();
    phoneTextController.dispose();
    super.dispose();
  }

  File? _image;
  final picker = ImagePicker();

  Future<void> getImage(ImageSource img,) async {
    final pickedFile = await picker.pickImage(source: img);
    XFile? xfilePick = pickedFile;


    setState(
          () {
        if (xfilePick != null) {
          _image = File(pickedFile!.path);
        } else {
          ScaffoldMessenger.of(context).showSnackBar( // is this context <<<
              const SnackBar(content: Text('No image selected')));
        }
      },
    );
  }

  Future<void> upLoadImageToFirebase(String name, email, password, phoneNumber) async {
    var imageName = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();
    var storageRef = FirebaseStorage.instanceFor(
        bucket: "gs://chatapp-1ac8f.appspot.com").ref().child(
        'images/$imageName.jpg');
    var uploadTask = storageRef.putFile(_image!);
    var downloadUrl = await (await uploadTask).ref.getDownloadURL();
    //add the imageURL to the UID in firestore
    final firestoreRef = FirebaseFirestore.instance.collection('users')
        .doc(user.uid);
    Map<String, dynamic> updates = {
      'imageURL': downloadUrl,
    };
    firestoreRef.update(updates).then((value) {
     return ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(
           elevation: 5,
           backgroundColor: Colors.green,
           content: Text("Image Uploaded",
             style: TextStyle(fontWeight: FontWeight.bold),),
         )
     );
    } );
  }




  //show popup dialog
  void myAlert() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            title: const Text('Please choose media to select from:'),
            content: SizedBox(
              height: 100,
              width: double.infinity,
              child: Column(
                children: [
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      getImage(ImageSource.gallery);
                      Navigator.of(context).pop();
                    },
                    //  style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                    child: const Row(
                      children: [
                        Icon(Icons.image),
                        Text('Gallery'),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  ElevatedButton(
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      getImage(ImageSource.camera);
                      Navigator.of(context).pop();
                    },
                    // style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                    child: const Row(
                      children: [
                        Icon(Icons.camera),
                        Text('Camera'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Edit $field'),
          content: TextFormField(
            cursorColor: Colors.green,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Enter new $field',
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
               onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('Same'),
              onPressed: () => Navigator.of(context).pop(newValue),
            ),

          ],
        ),

    );

  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Profile', style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 25),),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      myAlert();
                    },
                    child: const Text('Upload Photo'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  //if image not null show the image
                  //if image null show text
                  _image != null
                      ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(150),
                      child: Image.file(
                        //to show image, you type like this.
                        File(_image!.path),
                        fit: BoxFit.cover,
                        // width: MediaQuery.of(context).size.width,
                        width: 280,
                        height: 280,
                      ),
                    ),
                  )
                      : const Text("No Image Selected"),
                  const SizedBox(
                    height: 15,),
                  MyTextBox(
                    text: user.email!,
                    sectionName: 'Email',
                    onPressed: () => editField('Email'),
                  ),const Divider(
                    height: 2,
                  ),
                  MyTextBox(
                    text: 'name',
                    sectionName: 'Full Name',
                    onPressed: () => editField('Name'),
                  ),
                  const Divider(
                    height: 2,
                  ),
                  MyTextBox(
                    text: 'bio',
                    sectionName: 'bio',
                    onPressed: () => editField('bio'),
                  ),
                  const Divider(
                    height: 2,
                  ),
                  const SizedBox(
                    height: 30,),
                  Container(
                    height: 40,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Confirmation'),
                                content: const Text("are you sure you want to submit details?"),

                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Cancel', style: TextStyle(fontSize: 17),),),
                                  TextButton(
                                    onPressed: () {
                                      upLoadImageToFirebase(nameTextController.text,
                                          phoneTextController.text,
                                          emailTextController.text, passwordTextController.text);
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Yes', style: TextStyle(fontSize: 17),),),
                                ],
                              );
                            }
                        );
                      } ,
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),),
                          backgroundColor: Colors.green),
                      child: const Text(
                        "Save Details", style: TextStyle(
                          fontSize: 16),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

