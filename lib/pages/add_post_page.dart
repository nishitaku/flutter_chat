import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddPostPage extends StatefulWidget {
  // 引数からユーザー情報を受け取る
  AddPostPage(this.user);
  // ユーザー情報
  final User user;

  @override
  _AddPostPageState createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  // 入力した投稿メッセージ
  String messageText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('チャット投稿'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // 投稿メッセージ入力
              TextFormField(
                decoration: const InputDecoration(labelText: '投稿メッセージ'),
                //　複数行のテキスト入力
                keyboardType: TextInputType.multiline,
                // 最大3行
                maxLines: 3,
                onChanged: (String value) {
                  setState(() {
                    messageText = value;
                  });
                },
              ),
              const SizedBox(height: 8,),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  child: const Text('投稿'),
                  onPressed: () async {
                    // 現在の日時
                    final date = DateTime.now().toLocal().toIso8601String();
                    // AddPostPageのデータを参照
                    final email = widget.user.email;
                    // 投稿メッセージ用ドキュメント作成
                    await FirebaseFirestore.instance.collection('posts').doc().set({
                      'text': messageText,
                      'email': email,
                      'date': date
                    });
                    // 1つ前の画面に戻る
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}