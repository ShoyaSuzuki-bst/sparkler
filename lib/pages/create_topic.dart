import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'show_topic.dart';

class CreateTopic extends StatefulWidget {
  const CreateTopic({
    Key? key,
    required this.fetchTopics,
  }) : super(key: key);

  final fetchTopics;

  @override
  State<CreateTopic> createState() => _CreateTopicState();
}

class _CreateTopicState extends State<CreateTopic> {
  String _title = '';
  String _content = '';
  bool _isActive = true;

  void _create() async {
    setState(() {
      _isActive = false;
    });
    final topicRef = await FirebaseFirestore.instance
        .collection('topics')
        .add({
          'title': _title,
          'content': _content,
          'createUser': FirebaseAuth.instance.currentUser!.uid,
          'createdAt': DateTime.now(),
        });
    final snapshot = await topicRef.get();
    final topicId = snapshot.id;
    var topic = snapshot.data()!;
    topic['id'] = topicId;
    widget.fetchTopics();
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) {
        return ShowTopic(
          topic: topic,
          fetchTopics: widget.fetchTopics,
        );
      }),
    );
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
          title: const Text('トピック作成'),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              children: [
                TextField(
                  onChanged: (String v) {
                    setState(() {
                      _title = v;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: "トピックタイトル",
                  ),
                ),
                TextField(
                  onChanged: (String v) {
                    setState(() {
                      _content = v;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: "内容",
                  ),
                ),
                ElevatedButton(
                  child: const Text('保存'),
                  onPressed: _isActive ?_create : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}