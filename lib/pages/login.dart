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

  void saveAccountData() {
    _storage.write(key: 'EMAIL', value: _email);
    _storage.write(key: 'PASSWORD', value: _password);
  }

  void _showLoadingDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      transitionDuration: Duration(milliseconds: 250), // ダイアログフェードインmsec
      barrierColor: Colors.black.withOpacity(0.5), // 画面マスクの透明度
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
        saveAccountData();
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
        saveAccountData();
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

  // String generateNonce([int length = 32]) {
  //   const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
  //   final random = Random.secure();
  //   return List.generate(length, (_) => charset[random.nextInt(charset.length)])
  //       .join();
  // }

  // String sha256ofString(String input) {
  //   final bytes = utf8.encode(input);
  //   final digest = sha256.convert(bytes);
  //   return digest.toString();
  // }

  // void _signInWithApple() async {
  //   try{
  //     _showLoadingDialog();
  //     final rawNonce = generateNonce();
  //     final nonce = sha256ofString(rawNonce);

  //     await SignInWithApple.getAppleIDCredential(
  //       scopes: [
  //         AppleIDAuthorizationScopes.email,
  //         AppleIDAuthorizationScopes.fullName,
  //       ],
  //       nonce: nonce,
  //     );
  //     User user = FirebaseAuth.instance.currentUser!;
  //     _storage.write(key: 'EMAIL', value: user.email);
  //     Navigator.pop(context);
  //     await Navigator.of(context).pushReplacement(
  //       MaterialPageRoute(builder: (context) {
  //         return BasePage(
  //           email: user.email ?? 'null',
  //           password: _password,
  //         );
  //       }),
  //     );
  //   } catch (e) {
  //     showDialog(
  //       context: context,
  //       builder: (_) {
  //         return AlertDialog(
  //           title: Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: const <Widget>[
  //               Text("エラー"),
  //             ]
  //           ),
  //           content: Text("$e"),
  //           actions: <Widget>[
  //             TextButton(
  //               child: const Text("OK"),
  //               onPressed: () => Navigator.pop(context),
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   }
  // }

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
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _email = '';
                                _password = '';
                                _isRegistration = !_isRegistration;
                              });
                            },
                            child: _isRegistration ? const Text(
                              'ログインはこちら',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                              )
                            ) : const Text(
                              '新規登録はこちら',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                              )
                            ),
                          )
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
