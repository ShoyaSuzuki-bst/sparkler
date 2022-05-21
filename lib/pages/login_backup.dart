import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

// sign in with appleで仕様するもの
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';
// import 'package:crypto/crypto.dart';
// import 'package:flutter_signin_button/flutter_signin_button.dart';
// import 'dart:io';
// import 'dart:convert';
// import 'dart:math';

import 'package:sparkler/pages/base_page.dart';

class Login extends StatefulWidget {
  const Login({ Key? key }) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _storage = const FlutterSecureStorage();
  String _email = '';
  String _password = '';
  bool _isRegistration = true;
  void _showLoadingDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 250),
      barrierColor: Colors.black.withOpacity(0.5),
      pageBuilder: (BuildContext context, Animation animation,
          Animation secondaryAnimation) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    );
  }

  void _signInWithEmail() async {
    try {
      _showLoadingDialog();
      final User? user = (await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      )).user;
      if (user != null) {
        Navigator.pop(context);
        await Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) {
            return BasePage(
              currentUser: user,
            );
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
    } catch (e) {
      Navigator.pop(context);
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
            content: Text("$e"),
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

  void _registrationWithEmail() async {
    try {
      _showLoadingDialog();
      final User? user = (await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      )).user;
      if (user != null) {
        await user.updateDisplayName('ひよこ${user.uid}');
        Navigator.pop(context);
        await Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) {
            return BasePage(
              currentUser: user,
            );
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
    } catch (e) {
      Navigator.pop(context);
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
            content: Text("$e"),
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget> [
                    const Text(
                      'ようこそ',
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    SizedBox(
                      width: 300,
                      child: Column(
                        children: <Widget> [
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: "メールアドレス",
                              labelStyle: TextStyle(
                                fontSize: 20,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(),
                              ),
                            ),
                            onChanged: (String v) {
                              setState(() {
                                _email = v;
                              });
                            },
                          ),
                          TextFormField(
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: "パスワード",
                              labelStyle: TextStyle(
                                fontSize: 20,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(),
                              ),
                            ),
                            onChanged: (String v) {
                              setState(() {
                                _password = v;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          _isRegistration ? ElevatedButton(
                            child: const Text('新規登録'),
                            onPressed: () {
                              _registrationWithEmail();
                            },
                          ) : ElevatedButton(
                            child: const Text('ログイン'),
                            onPressed: () {
                              _signInWithEmail();
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ]
                ),
              ),
              // サードパーティのログイン機能がある場合はsign in with appleが必須であるが、メールアドレスによるログインのみであり必須ではないためコメントアウト
              // もし審査が通らないようであればコメントアウトを解除
              // Container(
              //   margin: const EdgeInsets.all(20.0),
              //   child: Column(
              //     mainAxisSize: MainAxisSize.min,
              //     children: <Widget>[
              //       if (Platform.isIOS) SignInButton(
              //         Buttons.AppleDark,
              //         text: 'Appleでログイン',
              //         onPressed: _signInWithApple,
              //       ),
              //     ]
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
