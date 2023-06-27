import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';

  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _message = TextEditingController();

  Future sendMessages() async {
    await FirebaseFirestore.instance.collection('messages').add({
      'sender': FirebaseAuth.instance.currentUser?.email,
      'messages': _message.text.trim(),
    });
  }

  Future getMessages() async {
    await for (var snapshot
        in FirebaseFirestore.instance.collection('messages').snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pop();
            },
          ),
        ],
        title: const Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _message,
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      sendMessages();
                      _message.clear();
                    },
                    child: const Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  final currentLoggedUser = FirebaseAuth.instance.currentUser?.email;

  MessageStream({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('messages').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final dataMessages = snapshot.data?.docs.reversed;
        List<MessageBubble> messageBubble = [];
        for (var dataMessage in dataMessages!) {
          final messageSender = dataMessage['sender'];
          final messageText = dataMessage['messages'];
          final messageTextWidget = MessageBubble(
            sender: messageSender,
            message: messageText,
            isMe: messageSender == currentLoggedUser,
          );

          messageBubble.add(messageTextWidget);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            children: messageBubble,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    required this.sender,
    required this.isMe,
  });

  final String message;
  final String sender;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: const TextStyle(
              fontSize: 12.0,
              color: Colors.grey,
            ),
          ),
          Material(
            elevation: 5.0,
            borderRadius: isMe ? const BorderRadius.only(topLeft: Radius.circular(30.0), bottomLeft: Radius.circular(30.0), bottomRight: Radius.circular(30.0), topRight: Radius.circular(0)) : const BorderRadius.only(topLeft: Radius.circular(0), bottomLeft: Radius.circular(30.0), bottomRight: Radius.circular(30.0), topRight: Radius.circular(30.0)),
            color: isMe == true ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                message,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black54,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
