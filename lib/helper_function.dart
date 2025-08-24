import 'package:flutter/material.dart';

class HelperFunction {
  HelperFunction._();

  /// used to navigate from one page to another
  /// onPressed : () => HelperFunction.navigate(context,LoginPage()),
  static void navigate(context, page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }
}
