import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/pages/add_post_page.dart';
import 'package:flutter_chat/pages/login_page.dart';

class ChatPage extends StatelessWidget {
  ChatPage(this.user);
  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('チャット'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () async {
              // ログアウト処理
              await FirebaseAuth.instance.signOut();
              // ログイン画面に遷移+チャット画面を破棄
              await Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) {
                  return LoginPage();
                })
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: Text('ログイン情報:${user.email}'),
          ),
          Expanded(
            // FutureBuilder
            // 非同期処理の結果を元にWidgetを作れる
            child: FutureBuilder<QuerySnapshot>(
              // 投稿メッセージ一覧を取得(非同期処理)
              // 投稿日時でソート
              future: FirebaseFirestore.instance
                .collection('posts')
                .orderBy('date')
                .get(),
              builder: (context, snapshot) {
                // データが取得できた場合
                if(snapshot.hasData) {
                  final List<DocumentSnapshot> documents = snapshot.data!.docs;
                  //　取得して投稿メッセージ一覧を元にリスト表示
                  return ListView(
                    children: documents.map((document) {
                      return Card(
                        child: ListTile(
                          title: Text(document['text']),
                          subtitle: Text(document['email']),
                          // 自分の投稿メッセージの場合は削除ボタンを表示
                          trailing: document['email'] == user.email
                            ? IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                // 投稿メッセージのドキュメントを削除
                                await FirebaseFirestore.instance
                                  .collection('posts')
                                  .doc(document.id)
                                  .delete();
                              },
                            )
                          : null
                        ),
                      );
                    }).toList(),
                  );
                }
                // データが読込中の場合
                return const Center(
                  child: Text('読込中...'),
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          // 投稿画面に遷移
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              return AddPostPage(user);
            }),
          );
        },
      ),
    );
  }
}