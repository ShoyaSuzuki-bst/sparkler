import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShowTopic extends StatefulWidget {
  ShowTopic({
    Key? key,
    required this.topic,
  }) : super(key: key);

  Map<String, dynamic> topic;

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
            icon: const Icon(Icons.person),
            onPressed: () async {

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
          ],
        ),
      ),
    );
  }
}