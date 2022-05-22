import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sparkler/models/topic.dart';

import 'package:sparkler/models/user.dart';
import 'package:sparkler/models/topic.dart';

import 'chat.dart';

class CreateTopic extends StatefulWidget {
  const CreateTopic({
    Key? key,
    required this.fetchTopics,
    required this.currentUser,
  }) : super(key: key);

  final Function fetchTopics;
  final User currentUser;

  @override
  State<CreateTopic> createState() => _CreateTopicState();
}

class _CreateTopicState extends State<CreateTopic> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _firstMessageController = TextEditingController();
  bool _isActive = true;
  final FirebaseFirestore store = FirebaseFirestore.instance;

  void _create() async {
    print('push 保存');
    setState(() {
      _isActive = false;
    });
    final topic = await Topic.create(
      _titleController.text,
      _firstMessageController.text,
    );
    widget.fetchTopics();
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) {
        return Chat(
          topic: topic,
          currentUser: widget.currentUser,
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
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: "トピックタイトル",
                  ),
                ),
                TextField(
                  controller: _firstMessageController,
                  decoration: const InputDecoration(
                    labelText: "ファーストメッセージ",
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
