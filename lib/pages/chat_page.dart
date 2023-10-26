import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/pages/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  static const String routeName = "/chatPage";
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController messageTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, WelcomePage.routeName);
              },
              icon: const Icon(Icons.exit_to_app))
        ],
        leading: const Icon(Icons.forum),
        centerTitle: true,
        title: const Text('Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // messages
            MessageStream(),

            // textfield
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: TextField(
                    controller: messageTextController,
                    style: const TextStyle(color: Colors.black),
                    decoration: kMessageTextFieldDecoration,
                  )),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        final sender = FirebaseAuth.instance.currentUser?.email;
                        final time =
                            DateFormat('kk:mm:ss').format(DateTime.now());
                        final message = messageTextController.text;
                        FirebaseFirestore.instance.collection('messages').add(
                          {
                            'text': message,
                            'sender': sender,
                            'time': time,
                          },
                        );
                        messageTextController.clear();
                      });
                    },
                    child: const Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getMessage();
  }

  void getMessage() async {
    var messages =
        await FirebaseFirestore.instance.collection('messages').get();
    print(messages.docs);
  }
}

class MessageStream extends StatelessWidget {
  const MessageStream({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('messages')
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          final messages = snapshot.data!.docs;
          List<MessageBubble> messageBubbles = messages.map((message) {
            final messageText = message['text'];
            final messageSender = message['sender'];
            final isMe =
                FirebaseAuth.instance.currentUser!.email == messageSender;
            return MessageBubble(
                sender: messageSender, text: messageText, isMe: isMe);
          }).toList();

          return Expanded(
            child: ListView(
              reverse: true,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              children: messageBubbles,
            ),
          );
        });
  }
}

// bubble ui chat
class MessageBubble extends StatelessWidget {
  final String sender;
  final String text;
  final bool isMe;
  const MessageBubble(
      {Key? key, required this.sender, required this.text, required this.isMe})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: const TextStyle(color: Colors.black54, fontSize: 12.0),
          ),
          const SizedBox(
            height: 5,
          ),
          Material(
            borderRadius: BorderRadius.only(
                topLeft:
                    isMe ? const Radius.circular(30) : const Radius.circular(0),
                topRight:
                    isMe ? const Radius.circular(0) : const Radius.circular(30),
                bottomLeft: const Radius.circular(30),
                bottomRight: const Radius.circular(30)),
            elevation: 5.0,
            color: isMe ? Colors.lightBlue : Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                text,
                style: TextStyle(
                    color: isMe ? Colors.white : Colors.black54,
                    fontSize: 15.0),
              ),
            ),
          )
        ],
      ),
    );
  }
}
