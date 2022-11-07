import 'package:flutter/material.dart';

class PopUpDialog extends StatelessWidget {
  final String title;
  final String content;
  final List<Widget>actions;

  PopUpDialog({Key? key, required this.title,required this.content,this.actions = const []}) : super(key: key);

  void dismissDialog() {

  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      actions: actions,
      content: Text(content),
    );
  }
}