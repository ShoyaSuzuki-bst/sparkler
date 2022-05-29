import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:sparkler/models/user.dart' as um;

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
  bool _isActive = false;

  void _nameValidation() {
    if (_valueController.text.isEmpty || _valueController.text.length > 6) {
      setState(() {
        _isActive = false;
      });
    }else{
      setState(() {
        _isActive = true;
      });
    }
  }

  void _submitButtonHandler() async {
    setState(() {
      _isActive = false;
    });
    AuthCredential _credential = PhoneAuthProvider.credential(
      verificationId: widget.verifyId,
      smsCode: _valueController.text
    );
    final userCredential = await FirebaseAuth.instance.signInWithCredential(_credential);
    final user = userCredential.user!;
    if (!(await um.User.exists(user.uid))) {
      final createTimestamp = Timestamp.fromDate(DateTime.now());
      await user.updateDisplayName("匿名さん${createTimestamp.seconds}");
      um.User.create(user.uid, user.displayName!, user.phoneNumber!);
    }
    final UserModel = um.User.transModelFromAuth(user);
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) {
        return BasePage(
          currentUser: UserModel,
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
        appBar: AppBar(
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
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextFormField(
                  controller: _valueController,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                  decoration: InputDecoration(
                    counterText: '${_valueController.text.length}/6',
                    counterStyle: TextStyle(
                      color: _valueController.text.length > 6 ? Colors.red : null,
                    ),
                    labelText: "確認コード",
                    labelStyle: const TextStyle(
                      fontSize: 20,
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                  ),
                  onChanged: (_) {
                    _nameValidation();
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    child: const Text('確認'),
                    onPressed: _isActive ? _submitButtonHandler : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
