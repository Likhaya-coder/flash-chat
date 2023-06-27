import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/Widgets/rounded_button.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome_screen';

  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(_controller);

    _controller.forward();

    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _animation.value,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'animationImg',
                  child: Container(
                    height: 60.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
                AnimatedTextKit(
                  repeatForever: true,
                  animatedTexts: [
                    TypewriterAnimatedText(
                      speed: const Duration(milliseconds: 300),
                      'Flash Chat',
                      textStyle: const TextStyle(
                        color: Colors.black54,
                        fontSize: 45.0,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              color: Colors.lightBlueAccent,
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
              title: 'Log in',
            ),
            RoundedButton(
              color: Colors.blueAccent,
              onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
              title: 'Register',
            ),
          ],
        ),
      ),
    );
  }
}
