import 'package:flutter/material.dart';

class IndicatorWidget extends StatefulWidget {
  final String topic;
  final String payload;

  const IndicatorWidget({
    Key key,
    this.topic,
    this.payload,
  }) : super(key: key);

  @override
  _IndicatorWidgetState createState() => _IndicatorWidgetState();
}

class _IndicatorWidgetState extends State<IndicatorWidget> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Indicator Widget'),
    );
  }
}
