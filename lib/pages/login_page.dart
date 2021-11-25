import 'package:flutter/material.dart';
import 'package:flutter_chat/pages/chat_page.dart';

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
                await Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) {
                    return ChatPage();
                  })
                );
            }),
          ],
      ),),
    );
  }
}