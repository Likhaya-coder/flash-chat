import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/Widgets/rounded_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'registration_screen';

  const RegistrationScreen({super.key});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _passwordConfirm = TextEditingController();
  late bool _saving = false;

  Future signUser() async {
    try {
      if (_password.text.trim() == _passwordConfirm.text.trim()) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email.text.trim(),
          password: _password.text.trim(),
        );
        Navigator.pushNamed(context, ChatScreen.id);
        setState(() {
          _saving = false;
        });
        _email.clear();
        _password.clear();
        _passwordConfirm.clear();
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text('Passwords do not match'),
            );
          },
        );
      }
    } on FirebaseAuthException catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(e.message.toString()),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: ModalProgressHUD(
          inAsyncCall: _saving,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'animationImg',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              const SizedBox(
                height: 48.0,
              ),
              TextField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black54,
                ),
                decoration:
                    kEmailInputDecoration.copyWith(hintText: 'Enter your email'),
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                controller: _password,
                obscureText: true,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black54,
                ),
                decoration: kPasswordInputDecoration.copyWith(
                    hintText: 'Enter your password'),
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                controller: _passwordConfirm,
                obscureText: true,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black54,
                ),
                decoration: kPasswordConfirmInputDecoration.copyWith(
                    hintText: 'Confirm your password'),
              ),
              const SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                color: Colors.blueAccent,
                onPressed: () {
                  setState(() {
                    _saving = true;
                  });
                  signUser();
                },
                title: 'Register',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
