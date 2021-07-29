import 'package:flutter/material.dart';

class WaitMessage extends StatelessWidget {
  final String message;

  const WaitMessage({Key key, @required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }
}
