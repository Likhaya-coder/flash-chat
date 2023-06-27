import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/Widgets/rounded_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';

  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  late bool _saving = false;

  final slider = SleekCircularSlider(
      appearance: CircularSliderAppearance(
        spinnerMode: true,
      ));

  Future loginUser() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email.text.trim(),
        password: _password.text.trim(),
      );
      Navigator.pushNamed(context, ChatScreen.id);
      setState(() {
        _saving = false;
      });
      _email.clear();
      _password.clear();
    } on FirebaseAuthException catch (e) {
      setState(() {
        _saving = false;
      });
      showDialog(context: context, builder: (context) {
        return AlertDialog(
          content: Text(e.message.toString()),
        );
      });
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
                decoration: kEmailInputDecoration.copyWith(hintText: 'Enter your email'),
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
                decoration: kPasswordInputDecoration.copyWith(hintText: 'Enter your password'),
              ),
              const SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                color: Colors.lightBlueAccent,
                onPressed: () {
                  setState(() {
                    _saving = true;
                  });
                  loginUser();
                },
                title: 'Log in',
              ),
            ],
          ),
        ),
      ),
    );
  }
}