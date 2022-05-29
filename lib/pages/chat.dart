import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:sparkler/models/message.dart';
import 'package:sparkler/models/topic.dart';
import 'package:sparkler/models/user.dart' as um;

class Chat extends StatefulWidget {
  Chat({
    Key? key,
    required this.topic,
    required this.currentUser,
  }) : super(key: key);

  final Topic topic;
  final um.User currentUser;

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final _controller = TextEditingController();
  final FirebaseFirestore store = FirebaseFirestore.instance;

  Color? messageBackColor(BuildContext context, String uid) {
    final Brightness brightness = MediaQuery.platformBrightnessOf(context);
    final Color color = brightness == Brightness.light ? Colors.yellow[100]! : Colors.cyan[900]!;
    return uid == widget.currentUser.uid ? color : null;
  }

  Widget buildTaskList(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: store
        .collection('topics')
        .doc(widget.topic.id)
        .collection('messages')
        .orderBy('createdAt')
        .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }
        final List<QueryDocumentSnapshot> messages = List.from(snapshot.data!.docs.reversed);
        return ListView(
          reverse: true,
          children: messages.map((DocumentSnapshot document) {
            final data = document.data()! as Map<String, dynamic>;
            return Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget> [
                  Row(
                    children: <Widget> [
                      Text(data['userName']),
                    ],
                  ),
                  Card(
                    color: messageBackColor(context, data['userReference'].id),
                    child: ListTile(
                      title: Text(data['message']),
                      subtitle: Text(DateFormat('MM/dd hh:mm').format(data['createdAt'].toDate())),
                    ),
                  ),
                ],
              ),
            );
          },
        ).toList());
      },
    );
  }

  void _sendButtonHandler() {
    final message = Message(
      _controller.text,
      widget.currentUser.name,
      widget.currentUser,
      widget.topic,
    );
    message.sendMessage();
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final FocusScopeNode currentScope = FocusScope.of(context);
        if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.topic.title),
          foregroundColor: MediaQuery.platformBrightnessOf(context) == Brightness.light ? Colors.grey.shade700 : null,
          backgroundColor: MediaQuery.platformBrightnessOf(context) == Brightness.light ? Colors.white : null,
          elevation: 0,
          bottom: PreferredSize(
            child: Container(
              color: Colors.grey.shade600,
              height: 0.5,
            ),
            preferredSize: const Size.fromHeight(5)
          ),
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Flexible(
                child: buildTaskList(context),
              ),
              Container(
                padding: const EdgeInsets.only(left: 30, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget> [
                    Flexible(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: '\n'.allMatches(_controller.text).length >= 4 ? 5 : null,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _sendButtonHandler();
                      },
                      icon: const Icon(Icons.send),
                      color: Theme.of(context).primaryColor,
                    )
                  ],
                ),
              ),
            ]
          ),
        ),
      ),
    );
  }
}
