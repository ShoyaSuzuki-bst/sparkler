import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserPage extends StatelessWidget {
  UserPage({
    Key? key,
    required this.currentUser,
  }) : super(key: key);

  final User currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(currentUser.displayName ?? ''),
            Text(currentUser.email ?? ''),
          ],
        ),
      ),
    );
  }
}