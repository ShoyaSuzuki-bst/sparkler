import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sparkler/models/topic.dart';

import 'package:sparkler/models/user.dart';
import 'package:sparkler/models/topic.dart';
import 'package:sparkler/parts/adaptive_banner.dart';

import 'chat.dart';
import 'create_topic.dart';
import 'profile.dart';

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
    refreshHandler();
  }

  void refreshHandler() async {
    final topics = await Topic.fetch();
    topics.sort((a, b) => b.createdAt.millisecondsSinceEpoch.compareTo(a.createdAt.millisecondsSinceEpoch));
    setState(() {
      _topics = topics;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ホーム'),
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
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  return UserPage(
                    currentUser: widget.currentUser,
                  );
                }),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            refreshHandler();
          },
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return Chat(
                        topic: _topics[index],
                        currentUser: widget.currentUser,
                        // fetchTopics: refreshHandler,
                      );
                    }),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Card(
                    child: Column(
                      children: <Widget> [
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: FractionalOffset.centerRight,
                              end: FractionalOffset.centerLeft,
                              colors: [
                                const Color(0x006f86d6).withOpacity(1),
                                const Color(0x0048c6ef).withOpacity(1),
                              ],
                              stops: const [
                                0.0,
                                1.0,
                              ],
                            ),
                          ),
                          width: double.infinity,
                          height: 150,
                          child: FittedBox(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              child: Text(
                                _topics[index].title,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget> [
                              Text(
                                'あと${_topics[index].createdAt.add(const Duration(days: 1)).difference(DateTime.now()).inHours}時間',
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '作成者：${_topics[index].user.name}',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
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
      bottomNavigationBar: const AdaptiveAdBanner(),
    );
  }
}
