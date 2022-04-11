import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:sparkler/pages/home.dart';
import 'package:sparkler/pages/user_page.dart';

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
  int _index = 0;
  String _title = 'スパークラー';
  List _titleList = [];

  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    setState(() {
      _titleList = [
        'ホーム',
        'マイページ'
      ];
      _title = 'ホーム';
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_title),
        ),
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: (int index) {
            setState(() {
              _index = index;
              _title = _titleList[index];
            });
          },
          children: [
            const Home(),
            UserPage(
              currentUser: widget.currentUser,
            ),
          ]
        ),
        bottomNavigationBar: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget> [
            BottomNavigationBar(
              onTap: (int index) { // define animation
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 10),
                  curve: Curves.ease
                );
              },
              currentIndex: _index,
              items: const [
                BottomNavigationBarItem( // call each bottom item
                  icon: Icon(Icons.home),
                  label: 'ホーム',
                ),
                BottomNavigationBarItem( // call each bottom item
                  icon: Icon(Icons.person),
                  label: 'マイページ',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}