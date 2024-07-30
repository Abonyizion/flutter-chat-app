
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled1/Chat/ChatServices.dart';
// import 'ChatServices.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  final String messageId;
  final String userId;
 // final String chatRoomId;

   ChatBubble({super.key,
    required this.message,
    required this.isCurrentUser,
     required this.messageId,
     required this.userId,
  //   required this.chatRoomId,

  });
  //instances of auth and firestore
  final user = FirebaseAuth.instance.currentUser!;
 // final ChatServices _chatServices = ChatServices();

  //delete message from
  Future<void> deleteMessages(String chatRoomId, String messageId) async {
    final messageRef = FirebaseFirestore.instance
        .collection('chat_room')
        .doc(chatRoomId)
        .collection('messages')
        .doc(messageId);
       await messageRef.delete();
  }

//showing bottom sheet for currentUser when message is long pressed
  void _showBottomSheetCurrentUser(BuildContext context) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), topLeft: Radius.circular(20),
          ),
        ),
        builder: (context) {
          return ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                leading: const Icon(Icons.copy),
                title: const Text("Copy Message"),
                onTap: () async {
                  await Clipboard.setData(
                      ClipboardData(
                          text: message)
                  )
                      .then((value) {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (context) {
                        Future.delayed(const Duration(seconds: 1), () {
                          Navigator.of(context).pop(true);
                        });
                        return const AlertDialog(
                          backgroundColor: Colors.green,
                          title: Center(
                            child: Text(
                              ("Text Copied"),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      },
                    );
                  }
                  );
                },
              ),

              ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text("Delete Message"),
                  onTap:  () {
                    Navigator.pop(context);
                 showDialog(
                   context: context,
                   builder: (context) => AlertDialog(
                     title: const Text('Delete Message'),
                     content: const Text('Are you sure you want to delete message?'),
                     actions: [
                       TextButton(
                           onPressed: () => Navigator.pop(context),
                           child: const Text('Cancel'),
                       ),
                       TextButton(
                         onPressed: () => deleteMessages,

                         child: const Text('Delete'),
                       ),
                     ],
                   ),
                 );
                  }
              ),
              ListTile(
                  leading: const Icon(Icons.cancel),
                  title: const Text("Cancel"),
                  onTap:  () {
                    Navigator.pop(context);
                  }
              ),
            ],
          );
        }
    );
  }
//showing bottom sheet for other user when message is long pressed
  void _showBottomSheet(BuildContext context, String messageId, String userId) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), topLeft: Radius.circular(20),
          ),
        ),
        builder: (context) {
          return ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                leading: const Icon(Icons.copy),
                title: const Text("Copy Message"),
                onTap: () async {
                  await Clipboard.setData(
                      ClipboardData(
                          text: message)
                  )
                      .then((value) {
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          builder: (context) {
                            Future.delayed(const Duration(seconds: 1), () {
                              Navigator.of(context).pop(true);
                            });
                            return const AlertDialog(
                              backgroundColor: Colors.green,
                              title: Center(
                                child: Text(
                                  ("Text Copied"),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          },
                        );
                    }
                  );
                },
              ),

             ListTile(
               leading: const Icon(Icons.delete),
               title: const Text("Delete Message"),
               onTap:  () {/*
                 showDialog(
                   context: context,
                   builder: (context) => AlertDialog(
                     title: const Text('Delete Message'),
                     content: const Text('Are you sure you want to delete message?'),
                     actions: [
                       TextButton(
                           onPressed: () => Navigator.pop(context),
                           child: const Text('Cancel'),
                       ),
                       TextButton(
                         onPressed: () {
                           deleteMessages;
                           Navigator.pop(context);
                           ScaffoldMessenger.of(context).showSnackBar(
                               const SnackBar(content: Text('Message Reported')));
                         },
                         child: const Text('Delete'),
                       ),
                     ],
                   ),
                 );*/
               }
             ),
              ListTile(
                  leading: const Icon(Icons.report),
                  title: const Text("Report User"),
                  onTap:  () {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Report Message!!'),
                        content: const Text('Are you sure you want to report this Message?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              ChatServices().reportUser(messageId, userId);
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Message Reported')));
                              },
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );
                  }
              ),
              ListTile(
                  leading: const Icon(Icons.block),
                  title: const Text("Block User"),
                  onTap:  () {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Block User!!'),
                        content: const Text('Are you sure you want to block this User?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              ChatServices().blockUser(userId);
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('User Blocked')));
                            },
                            child: const Text('Block'),
                          ),
                        ],
                      ),
                    );
                  }
              ),
              ListTile(
                  leading: const Icon(Icons.cancel),
                  title: const Text("Cancel"),
                  onTap:  () {
                    Navigator.pop(context);
                  }
              ),
            ],
          );
        }
        );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: isCurrentUser ? const EdgeInsets.only(
          left: 60, right: 15)
          : const EdgeInsets.only(right: 60, left: 15),
      child: InkWell(
        onLongPress: () {
          if(!isCurrentUser) {
            _showBottomSheet(context, messageId, userId);
          }
          if(isCurrentUser) {
            _showBottomSheetCurrentUser(context);
          }
        },

        child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: isCurrentUser ? const BorderRadius.only(topLeft: Radius.circular(18),
                bottomRight: Radius.circular(18), bottomLeft: Radius.circular(18),)
                  : const BorderRadius.only(topRight: Radius.circular(18),
                bottomRight: Radius.circular(18), bottomLeft: Radius.circular(18),),
              color: isCurrentUser ? Colors.green : Colors.grey.shade700,
            ),
            child: Text(message,
              style: const TextStyle(color: Colors.white),)
        ),
      ),
    );
  }
}
