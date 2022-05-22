import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sparkler/models/topic.dart';

import 'package:sparkler/models/user.dart';
import 'package:sparkler/models/topic.dart';

import 'chat.dart';
import 'create_topic.dart';
import 'user_page.dart';

class BasePage extends StatefulWidget {
  BasePage({
    Key? key,
    required this.currentUser,
  }) : super(key: key);

  final User currentUser;

  @override
  _BasePageState createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  List<Topic> _topics = [];
  final firestore = FirebaseFirestore.instance;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    final topics = await Topic.fetch();
    setState(() {
      _topics = topics;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ホーム'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  return UserPage();
                }),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            final topics = await Topic.fetch();
            setState(() {
              _topics = topics;
            });
          },
          child: ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  return Chat(
                    topic: _topics[index],
                    currentUser: widget.currentUser,
                  );
                }),
              );
            },
            title: Flexible(
              child: Text(
                _topics[index].title,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return const Divider(height: 0.5);
        },
        itemCount: _topics.length,
      ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              return CreateTopic(
                fetchTopics: Topic.fetch,
                currentUser: widget.currentUser,
              );
            }),
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
