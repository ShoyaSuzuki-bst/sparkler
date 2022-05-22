import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:sparkler/models/user.dart' as um;

import 'package:sparkler/pages/base_page.dart';
import 'package:sparkler/pages/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sparkler',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),

      // ログインしているかどうかではじめに表示する画面を切り替える。
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
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

          if (snapshot.hasData) {
            final um.User user = um.User.getCurrentUser();
            return BasePage(currentUser: user);
          }
          return const Login();
        },
      ),
    );
  }
}
