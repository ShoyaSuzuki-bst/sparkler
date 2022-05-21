import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:sparkler/models/user.dart' as UserModel;

import 'base_page.dart';

class InputVerifyCode extends StatefulWidget {
  const InputVerifyCode({
    Key? key,
    required this.verifyId,
  }) : super(key: key);

  final String verifyId;

  @override
  State<InputVerifyCode> createState() => _InputVerifyCodeState();
}

class _InputVerifyCodeState extends State<InputVerifyCode> {
  final _valueController = TextEditingController();
  final store = FirebaseFirestore.instance;

  void _submitButtonHandler() async {
    AuthCredential _credential = PhoneAuthProvider.credential(
      verificationId: widget.verifyId,
      smsCode: _valueController.text
    );
    final userCredential = await FirebaseAuth.instance.signInWithCredential(_credential);
    final user = userCredential.user!;
    if (!(await UserModel.User.exists(user.uid))) {
      final createTimestamp = Timestamp.fromDate(DateTime.now());
      await user.updateDisplayName("匿名さん${createTimestamp.seconds}");
      UserModel.User.create(user.uid, user.displayName!, user.phoneNumber!);
    }
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) {
        return BasePage(
          currentUser: user,
        );
      }),
    );
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
              Column(
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
                          controller: _valueController,
                          keyboardType: TextInputType.phone,
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                          decoration: const InputDecoration(
                            labelText: "確認コード",
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
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            child: const Text('確認'),
                            onPressed: () {
                              _submitButtonHandler();
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ]
              ),
            ],
          ),
        ),
      ),
    );
  }
}
