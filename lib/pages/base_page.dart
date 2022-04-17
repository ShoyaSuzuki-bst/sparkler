import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'create_topic.dart';
import 'user_page.dart';
import 'show_topic.dart';

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
  List _topics = [];
  final firestore = FirebaseFirestore.instance;

  Future<List> _fetchTopics() async {
    print('_fetchTopics start');
    final snapshot = await firestore.collection('topics').get();
    for(var topic in snapshot.docs){
      print(topic['title']);
    }
    return snapshot.docs;
  }

@override
void didChangeDependencies() async {
  super.didChangeDependencies();
  final topics = await _fetchTopics();
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
            print('refresh start');
            final topics = await _fetchTopics();
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
                  return ShowTopic(title: _topics[index]['title'], content: _topics[index]['content']);
                }),
              );
            },
            title: Flexible(
              child: Text(
                _topics[index]['title'],
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
                fetchTopics: _fetchTopics,
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