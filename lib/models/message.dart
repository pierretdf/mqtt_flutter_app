import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Message extends Equatable {
  final int id;
  final String topic;
  final String payload;
  final int qos;
  final bool retainValue;

  const Message(
      {@required this.id,
      @required this.topic,
      @required this.payload,
      this.qos = 1,
      this.retainValue = false});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      topic: json['topic'],
      payload: json['payload'],
      qos: json['qos'],
      retainValue: json['retainValue'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['topic'] = topic;
    data['payload'] = payload;
    data['qos'] = qos;
    data['retainValue'] = retainValue ? 1 : 0;
    return data;
  }

  Message copyWith({
    int id,
    String topic,
    String payload,
    int qos,
    bool retainValue,
  }) {
    return Message(
      id: id ?? this.id,
      topic: topic ?? this.topic,
      payload: payload ?? this.payload,
      qos: qos ?? this.qos,
      retainValue: retainValue ?? this.retainValue,
    );
  }

  @override
  List<Object> get props => [
        id,
        topic,
        payload,
        qos,
        retainValue,
      ];
}
