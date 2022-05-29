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
  String _titleCounter = '0/17';
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
    await Navigator.of(context).pushReplacement(
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      counterText: _titleCounter,
                      counterStyle: TextStyle(
                        color: _titleController.text.length > 17 ? Colors.red : null,
                      ),
                      contentPadding: const EdgeInsets.only(left: 10, right: 10, top: 30),
                      border: const OutlineInputBorder(),
                      labelText: "トピックタイトル",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    onChanged: (_) {
                      setState(() {
                        _titleCounter = '${_titleController.text.length}/17';
                        _isActive = _titleController.text.length <= 17;
                      });
                    },
                  ),
                  const Padding(padding: EdgeInsets.all(15)),
                  TextField(
                    controller: _firstMessageController,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10, right: 10, top: 30),
                      border: OutlineInputBorder(),
                      labelText: "ファーストメッセージ",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: 10,
                  ),
                  ElevatedButton(
                    child: const Text('保存'),
                    onPressed: _isActive ? _create : null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
