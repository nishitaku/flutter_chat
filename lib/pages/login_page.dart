import 'package:flutter/material.dart';
import 'package:flutter_chat/main.dart';
import 'package:flutter_chat/pages/chat_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ConsumerWidgetでProviderから値を受け渡す
class LoginPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Providerから値を受け取る
    final infoText = ref.watch(infoTextProvider);
    final email = ref.watch(emailProvider);
    final password = ref.watch(passwordProvider);

    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'メールアドレス'),
                onChanged: (String value) {
                  // Providerから値を更新
                  ref.read(emailProvider.notifier).state = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'パスワード'),
                obscureText: true,
                onChanged: (String value) {
                  // Providerから値を更新
                  ref.read(passwordProvider.notifier).state = value;
                },
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: Text(infoText),
              ),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  child: const Text('ユーザー登録'),
                  onPressed: () async {
                    try {
                      final FirebaseAuth auth = FirebaseAuth.instance;
                      final result = await auth.createUserWithEmailAndPassword(
                        email: email,
                        password: password,
                      );
                      // ユーザー情報を更新
                      ref.read(userProvider.notifier).state = result.user!;

                      // ユーザー登録に成功した場合、チャット画面に遷移+ログイン画面を破棄
                      await Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) {
                          return ChatPage();
                        }),
                      );
                    } catch (e) {
                      // ユーザー登録に失敗した場合
                      ref.read(infoTextProvider.notifier).state = "登録に失敗しました:${e.toString()}";
                    }
                  },
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                child: OutlinedButton(
                  child: const Text('ログイン'),
                  onPressed: () async {
                    try {
                      final FirebaseAuth auth = FirebaseAuth.instance;
                      final result = await auth.signInWithEmailAndPassword(
                        email: email,
                        password: password,
                      );
                      // ログインに成功した場合、チャット画面に遷移+ログイン画面を破棄
                      await Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) {
                          return ChatPage();
                        }),
                      );
                    } catch (e) {
                      // ユーザー登録に失敗した場合
                      ref.read(infoTextProvider.notifier).state = "ログインに失敗しました:${e.toString()}";
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
