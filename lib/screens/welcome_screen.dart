import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/constants.dart';
import 'selfmadewidgets.dart';
class WelcomeScreen extends StatefulWidget {

  static String home = 'homescreen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{

  AnimationController controller;
  Animation animation;
  Animation color;
  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    animation = CurvedAnimation(parent: controller, curve: Curves.ease);
    color = ColorTween(begin: Colors.black, end: Colors.white).animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: animation.value * 70,
                  ),
                ),
                TypewriterAnimatedTextKit(
                  speed: Duration(milliseconds: 500),
                  repeatForever: true,
                  text: ['Flash Chat'],
                  textStyle: kTypewrittertextstyle,
                ),
              ],
            ),
            SizedBox(
              height: 28.0,
            ),
            Button(
              onpressed: (){
                Navigator.pushNamed(context, LoginScreen.login);
              },
              color: Colors.lightBlueAccent,
              tag: 'loginbutton',
              text: 'Log in',
            ),
            Button(
              onpressed: (){
                Navigator.pushNamed(context, RegistrationScreen.register);
              },
              color: Colors.blueAccent,
              tag: 'registerbutton',
              text: 'Register',
            )
          ],
        ),
      ),
    );
  }
}

