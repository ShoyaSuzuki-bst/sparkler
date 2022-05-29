import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:sparkler/models/user.dart';

import 'login.dart';
import 'edit_user_name.dart';

class UserPage extends StatefulWidget {
  UserPage({
    Key? key,
    required this.currentUser,
  }) : super(key: key);

  final User currentUser;

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final _storage = const FlutterSecureStorage();

  void _logout(context) async {
    widget.currentUser.logout();
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) {
        return const Login();
      }),
    );
  }

  void _editUserName() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) {
        return EditUserName(
          currentUser: widget.currentUser,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ユーザーページ'),
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
      ),
      body: ListView(
        children: <Widget> [
          ListTile(
            title: const Text('名前'),
            subtitle: Text(widget.currentUser.name),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              _editUserName();
            },
          ),
          ListTile(
            title: const Text('電話番号'),
            subtitle: Text(widget.currentUser.phoneNumber),
          ),
          TextButton(
            child: const Text('ログアウト'),
            onPressed: () async {
              widget.currentUser.logout();
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  return const Login();
                }),
              );
            },
          ),
        ],
      ),
    );
  }
}
