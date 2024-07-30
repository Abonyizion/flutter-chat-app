
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/Chat/ChatServices.dart';
import '../Chat/ChatBubble.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserName;
  final String receiverUserEmail;
  final String receiverUserID;
  final FocusNode? focusNode;
  const ChatPage({super.key,
    required this.receiverUserName,
    required this.receiverUserEmail,
    required this.receiverUserID,
  this.focusNode});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  
  final TextEditingController _messageController = TextEditingController();
  final ChatServices _chatServices = ChatServices();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  
  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatServices.sendMessage(
          widget.receiverUserID, _messageController.text);
      //clear text controller after sending message
      _messageController.clear();
    }
  }

    final ScrollController _scrollController = ScrollController();
    void scrollDown() {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
          duration: const Duration(microseconds: 400),
          curve: Curves.fastOutSlowIn,
      );
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverUserName),
          iconTheme: const IconThemeData(
            color: Colors.green,
          ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          Expanded(
              child: _buildMessageList(),
          ),
          const SizedBox(
            height: 10,
          ),
          _buildMessageInput(),
          const SizedBox(
            height: 8,
          ),
        ],
      )
    );
  }
  
  Widget _buildMessageList() {
    return StreamBuilder(
        stream: _chatServices.getMessages(
            widget.receiverUserID, _firebaseAuth.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text('Loading...', style: TextStyle(
                fontSize: 25
               ),
              ),
            );
          }
          return ListView(
            reverse: true,
            children: snapshot.data!.docs
                .map((document) => _buildMessageItem(document))
                .toList(),
          );
        },
    );
  }
  
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    // is current user
    bool isCurrentUser = data['senderId'] == _firebaseAuth.currentUser!.uid;
   var alignment =
       isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
   return Container(
     alignment: alignment,
     child: Column(
       crossAxisAlignment:
       isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
       children: [
         const SizedBox(
           height: 8,
         ),
       //  Text(data['senderEmail']),
       ChatBubble(message: data['message'].toString(),
         isCurrentUser: isCurrentUser,
         messageId: document.id,
         userId: data['senderID'].toString(),

       ),
       ],
     ),
   );
  }
  Widget _buildMessageInput() {
    return Row(
      children: [
        Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 6),
              child: Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  autocorrect: true,
                 autovalidateMode: AutovalidateMode.onUserInteraction,
                 // focusNode: myFocusNode,
                  cursorColor: Colors.green,
                  textAlignVertical: TextAlignVertical.center,
                  controller: _messageController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(
                      left: 8.0, bottom: 8.0, top: 8.0, right: 9.0
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green.shade200),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    ),
                    filled: true,
                    hintText: 'Enter message...',
                  ),
                  )
                ),
              ),
            ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green,
            ),
            child: IconButton(
                onPressed: sendMessage,
                icon: const Icon(
                  Icons.send,
                  color: Colors.white,
                ),
            ),
          ),
        ),
      ],
    );
  }
}
