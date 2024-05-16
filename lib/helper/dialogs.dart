import 'package:flutter/material.dart';

class Dialogs {
  static void showSnackbar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: Colors.teal.withOpacity(0.7),
      behavior: SnackBarBehavior.floating,

    ));
  }

  static void showProgressBar(BuildContext context) {
    showDialog(context: context, builder: (_)=>const Center(child: CircularProgressIndicator(
      color: Colors.teal,
    )));
  }
}
