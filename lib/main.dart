import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ユーザー情報の受け渡しを行うためのProvider
final userProvider = StateProvider((ref) => FirebaseAuth.instance.currentUser);

// エラー情報の受け渡しを行うためのProvider
final infoTextProvider = StateProvider.autoDispose((ref) => '');

// メールアドレスの受け渡しを行うためのProvider
final emailProvider = StateProvider.autoDispose((ref) => '');


// パスワードの受け渡しを行うためのProvider
final passwordProvider = StateProvider.autoDispose((ref) => '');


// メッセージの受け渡しを行うためのProvider
final messageTextProvider = StateProvider.autoDispose((ref) => '');


// StreamProviderを使うことでStreamも扱える
final postsQueryProvider = StreamProvider.autoDispose((ref) {
  return FirebaseFirestore.instance
      .collection('posts')
      .orderBy('date')
      .snapshots();
});

void main() async {
  // Firebase初期化
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    // RiverPodでデータを受け渡しできる状態にする
    ProviderScope(child: ChatApp()),
  );
}

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}
