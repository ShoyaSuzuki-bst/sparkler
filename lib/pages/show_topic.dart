import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sparkler/pages/base_page.dart';

import 'chat.dart';

class ShowTopic extends StatefulWidget {
  ShowTopic({
    Key? key,
    required this.topic,
    required this.fetchTopics,
  }) : super(key: key);

  Map<String, dynamic> topic;
  final fetchTopics;

  @override
  State<ShowTopic> createState() => _ShowTopicState();
}

class _ShowTopicState extends State<ShowTopic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await FirebaseFirestore.instance.collection('topics').doc(widget.topic['id']).delete();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.topic['title']),
            Text(widget.topic['content']),
            ElevatedButton(
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return Chat(
                      topic: widget.topic,
                    );
                  }),
                );
              },
              child: const Text('チャットへ移動する'),
            )
          ],
        ),
      ),
    );
  }
}