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
  List<Map<String, dynamic>> _topics = [];
  final firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> _fetchTopics() async {
    final snapshot = await firestore.collection('topics').get();
    final List<Map<String, dynamic>> docs = snapshot.docs.map(
      (doc) => doc.data(),
    ).toList();
    return docs;
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
                  return ShowTopic(topic: _topics[index]);
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