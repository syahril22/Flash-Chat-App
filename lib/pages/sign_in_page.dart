import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/pages/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SignIpPage extends StatefulWidget {
  static const String routeName = "/signIpPage";
  const SignIpPage({super.key});

  @override
  State<SignIpPage> createState() => _SignIpPageState();
}

class _SignIpPageState extends State<SignIpPage> {
  // variabel to handle data signup user
  late String email;
  late String password;
  bool showSpinner = false;
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: SizedBox(
                      height: 200.0,
                      child: Image.network(
                          'https://user-images.githubusercontent.com/75456232/229485313-be244e82-15f8-43e5-834e-9f0ca32ab40f.png')),
                ),
              ),
              const SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.black),
                textAlign: TextAlign.center,
                onChanged: (newValue) {
                  email = newValue;
                },
                decoration: InputDecoration(
                    hintText: 'Enter your email..',
                    hintStyle: const TextStyle(color: Colors.grey),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.blueAccent, width: 1.0),
                        borderRadius: BorderRadius.circular(32.0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.blueAccent, width: 2.0),
                        borderRadius: BorderRadius.circular(32.0))),
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                style: const TextStyle(color: Colors.black),
                textAlign: TextAlign.center,
                onChanged: (newValue) {
                  password = newValue;
                },
                decoration: InputDecoration(
                    hintText: 'Enter your password..',
                    hintStyle: const TextStyle(color: Colors.grey),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.blueAccent, width: 1.0),
                        borderRadius: BorderRadius.circular(32.0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.blueAccent, width: 2.0),
                        borderRadius: BorderRadius.circular(32.0))),
              ),
              const SizedBox(
                height: 24.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Material(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(30),
                  elevation: 5.0,
                  child: MaterialButton(
                    onPressed: () async {
                      setState(() {
                        showSpinner = true;
                      });

                      try {
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: email, password: password);
                        Navigator.pushNamedAndRemoveUntil(
                            context, ChatPage.routeName, (route) => false);
                        print('Success');
                      } catch (e) {
                        print(e);
                      }

                      setState(() {
                        showSpinner = false;
                      });
                    },
                    minWidth: 200.0,
                    height: 42.0,
                    child: const Text(
                      'Sign In',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
