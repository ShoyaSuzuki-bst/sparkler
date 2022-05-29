import 'package:flutter/material.dart';

import 'package:sparkler/models/user.dart';

import 'base_page.dart';

class EditUserName extends StatefulWidget {
  EditUserName({
    Key? key,
    required this.currentUser,
  }) : super(key: key);

  final User currentUser;

  @override
  State<EditUserName> createState() => _EditUserNameState();
}

class _EditUserNameState extends State<EditUserName> {
  final TextEditingController _nameController = TextEditingController();
  bool _isValid = false;
  String _counterText = '0/15';

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _nameController.text = widget.currentUser.name;
    final length = _nameController.text.length;
    setState(() {
      _counterText = '$length/15';
    });
  }

  void _nameValidation() {
    if (_nameController.text.isEmpty || _nameController.text.length > 15) {
      setState(() {
        _isValid = false;
        _counterText = '${_nameController.text.length}/15';
      });
    }else{
      setState(() {
        _isValid = true;
        _counterText = '${_nameController.text.length}/15';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final FocusScopeNode currentScope = FocusScope.of(context);
        if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('名前変更'),
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
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget> [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(left: 10, right: 10, top: 30),
                  counterText: _counterText,
                  counterStyle: TextStyle(
                    color: _nameController.text.length > 15 ? Colors.red : null,
                  ),
                  border: const OutlineInputBorder(),
                  labelText: "名前",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                onChanged: (_) {
                  _nameValidation();
                },
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  child: const Text('保存'),
                  onPressed: _isValid ? () async {
                    setState(() {
                      _isValid = false;
                    });
                    final user = await widget.currentUser.updateDisplayName(_nameController.text);
                    await Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) {
                        return BasePage(
                          currentUser: user,
                        );
                      }),
                    );
                  } : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
