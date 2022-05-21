import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'login.dart';

class UserPage extends StatelessWidget {
  final User currentUser = FirebaseAuth.instance.currentUser!;
    final _storage = const FlutterSecureStorage();

  void _logout(context) async {
    await FirebaseAuth.instance.signOut();
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) {
        return const Login();
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(currentUser.displayName ?? ''),
            Text(currentUser.phoneNumber ?? ''),
            Padding(
              padding: const EdgeInsets.only(top: 100),
              child: TextButton(
                onPressed: () {
                  _logout(context);
                },
                child: const Text(
                  'ログアウト'
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
