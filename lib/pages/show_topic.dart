import 'package:flutter/material.dart';

class ShowTopic extends StatefulWidget {
  ShowTopic({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  String title;
  String content;

  @override
  State<ShowTopic> createState() => _ShowTopicState();
}

class _ShowTopicState extends State<ShowTopic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.title),
            Text(widget.content),
          ],
        ),
      ),
    );
  }
}