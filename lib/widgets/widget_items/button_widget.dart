import 'package:flutter/material.dart';

class ButtonWidget extends StatefulWidget {
  final String topic;
  final String payload;

  const ButtonWidget({
    Key key,
    this.topic,
    this.payload,
  }) : super(key: key);

  @override
  _ButtonWidgetState createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Button Widget'),
    );
  }
}
