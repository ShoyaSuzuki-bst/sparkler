import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:sparkler/pages/base_page.dart';
import 'package:sparkler/pages/login.dart';

class Entry extends StatefulWidget {
  const Entry({ Key? key }) : super(key: key);

  @override
  State<Entry> createState() => _EntryState();
}

class _EntryState extends State<Entry> {  

  // 自動ログイン機能を実装する上で削除するときに仕様する。
  // 仕様通りであれば実装する必要はないが、テストとして削除したいときにコメントアウトを解除する。
  // @override
  // void initState() {
  //   super.initState();
  //   const _storage = FlutterSecureStorage();
  //   Future(() async {
  //     await _storage.delete(key: 'EMAIL');
  //     await _storage.delete(key: 'PASSWORD');
  //   });
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkAccountAndSwitchPage();
  }

  void _checkAccountAndSwitchPage() async {
    const storage = FlutterSecureStorage();
    final String? email = await storage.read(key: 'EMAIL');
    final String? password = await storage.read(key: 'PASSWORD');
    if (email != null && password != null) {
      final User? user = (await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      )).user;
      if (user != null) {
        await Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) {
            return BasePage(currentUser: user);
          }),
        );
      }else{
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Text("エラー"),
                ]
              ),
              content: const Text("ユーザーを取得できませんでした。"),
              actions: <Widget>[
                TextButton(
                  child: const Text("OK"),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            );
          },
        );
      }
    }
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) {
        return const Login();
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Loading...')
          ],
        ),
      ),
    );
  }
}