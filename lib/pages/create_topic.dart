import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'show_topic.dart';

class CreateTopic extends StatefulWidget {
  const CreateTopic({ Key? key }) : super(key: key);

  @override
  State<CreateTopic> createState() => _CreateTopicState();
}

class _CreateTopicState extends State<CreateTopic> {
  String _title = '';
  String _content = '';

  void _create() async {
    await FirebaseFirestore.instance
        .collection('topics')
        .add({
          'title': _title,
          'content': _content,
          'createUser': '後で実装して',
          'createdAt': DateTime.now(),
        });
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) {
        return ShowTopic(
          title: _title,
          content: _content,
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
                  onPressed: _create,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}