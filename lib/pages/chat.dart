import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Chat extends StatefulWidget {
  Chat({
    Key? key,
    required this.topic,
  }) : super(key: key);

  Map<String, dynamic> topic;

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final _controller = TextEditingController();

  Widget buildTaskList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
        .collection('topics')
        .doc(widget.topic['id'])
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
                      Text('匿名さん'),
                    ],
                  ),
                  Card(
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

  void _sendMessage() async {
    await FirebaseFirestore.instance
      .collection('topics')
      .doc(widget.topic['id'])
      .collection('messages')
      .add({
        'message': _controller.text,
        'createUser': FirebaseAuth.instance.currentUser!.uid,
        'createdAt': DateTime.now(),
      });
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
          title: Text(widget.topic['title']),
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Flexible(
                child: buildTaskList(),
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
                      onPressed: () async {
                        print('送信');
                        print(_controller.text);
                        _sendMessage();
                        _controller.clear();
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