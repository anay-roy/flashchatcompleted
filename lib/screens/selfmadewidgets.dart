import 'package:flutter/material.dart';

class Button extends StatelessWidget {

  Button({this.onpressed, this.color, this.text, this.tag});
  final Function onpressed;
  final Color color;
  final String tag;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        child: Hero(
          tag: tag,
          child: MaterialButton(
            onPressed: onpressed,
            minWidth: 200.0,
            height: 42.0,
            child: Text(text, style: TextStyle(color: Colors.white) ,),
          ),
        ),
      ),
    );
  }
}
