import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flash_chat/pages/chat_page.dart';
import 'package:flash_chat/pages/sign_in_page.dart';
import 'package:flash_chat/pages/sign_up_page.dart';
import 'package:flash_chat/pages/welcome_page.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: FirebaseAuth.instance.currentUser != null
          ? ChatPage.routeName
          : WelcomePage.routeName,
      routes: {
        WelcomePage.routeName: (context) => const WelcomePage(),
        SignUpPage.routeName: (context) => const SignUpPage(),
        ChatPage.routeName: (context) => const ChatPage(),
        SignIpPage.routeName: (context) => const SignIpPage(),
      },
    );
  }
}
