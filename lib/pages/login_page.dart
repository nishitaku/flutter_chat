import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: const Text('ログイン'),
              onPressed: () async {
                // チャット画面に繊維+ログイン画面を破棄
            }), 
          ],
      ),),
    );
  }
}