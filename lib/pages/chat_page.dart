import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/main.dart';
import 'package:flutter_chat/pages/add_post_page.dart';
import 'package:flutter_chat/pages/login_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Providerから値を受け取る
    final user = ref.watch(userProvider);
    final AsyncValue<QuerySnapshot> asyncPostsQuery =
        ref.watch(postsQueryProvider);

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
              await Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(builder: (context) {
                return LoginPage();
              }));
            },
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: Text('ログイン情報:${user!.email}'),
          ),
          Expanded(
            // StreamProviderから受け取った値は、.when()で状態に応じて出し分け
            child: asyncPostsQuery.when(
              data: (QuerySnapshot query) {
                return ListView(
                  children: query.docs.map((document) {
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
                                : null),
                    );
                  }).toList(),
                );
              },
              // 値の取得に失敗したとき
              error: (e, statckTrace) {
                return Center(
                  child: Text(e.toString()),
                );
              },
              // 値が読込中のとき
              loading: () {
                return const Center(
                  child: Text('読込中...'),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          // 投稿画面に遷移
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              return AddPostPage();
            }),
          );
        },
      ),
    );
  }
}
