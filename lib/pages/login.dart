import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

import 'input_verify_code.dart';

class Login extends StatefulWidget {
  const Login({ Key? key }) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _phoneNumberValueController = TextEditingController();
  final _internationalNumber = TextEditingController(text: '+81');
  final String smsCode = '';
  String verificationId = '';
  String _errorMessage = '';

  void _submitButtonHandler(BuildContext context) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '${_internationalNumber.text}${_phoneNumberValueController.text}',
      verificationCompleted: (PhoneAuthCredential credential) {
        print('verificationCompleted called');
      },
      verificationFailed: (FirebaseAuthException e) {
        String errorMessage = '';
        if (e.code == 'invalid-phone-number'){
          errorMessage = '電話番号が正しくありません';
        } else {
          errorMessage = '正常にログインできませんでした';
        }
        setState(() {
          _errorMessage = errorMessage;
        });
      },
      codeSent: (String verificationId, int? resendToken) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) {
            return InputVerifyCode(
              verifyId: verificationId,
            );
          }),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget> [
                            Expanded(
                              flex: 2,
                              child: SizedBox(
                                width: 50,
                                child: TextFormField(
                                  controller: _internationalNumber,
                                  keyboardType: TextInputType.phone,
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                  decoration: const InputDecoration(
                                    hintText: "国際番号",
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
                              ),
                            ),
                            const Padding(padding: EdgeInsets.all(5),),
                            Expanded(
                              flex: 7,
                              child: TextFormField(
                                controller: _phoneNumberValueController,
                                keyboardType: TextInputType.phone,
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                                decoration: const InputDecoration(
                                  hintText: "電話番号",
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
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Text(
                          _errorMessage,
                          style: const TextStyle(
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            child: const Text('次へ →'),
                            onPressed: () {
                              _submitButtonHandler(context);
                            },
                          ),
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
