import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Global {
  static late Size mq;

  static void init(BuildContext context) {
    mq = MediaQuery.of(context).size;
  }


  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> scaffoldMessage(
      BuildContext context, String text) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );

  }
  static Widget customLoader({
    Color color = Colors.deepPurple,
    double size = 30.0,
    double strokeWidth = 3.0,
  }) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(color),
        strokeWidth: strokeWidth,
      ),
    );
  }

}