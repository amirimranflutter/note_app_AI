import 'package:flutter/cupertino.dart';

class Global {
  static late Size mq;

  static void init(BuildContext context) {
    mq = MediaQuery.of(context).size;
  }
}