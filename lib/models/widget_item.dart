import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class WidgetItem extends Equatable {
  final int id;
  final String name;
  final String topic;
  final String type;
  final String pubTopic; // Optionnal
  final String payload;
  final String jsonPath;

  // Constructor
  const WidgetItem(
      {this.id,
      @required this.name,
      @required this.topic,
      @required this.type,
      this.pubTopic,
      this.payload,
      this.jsonPath});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'topic': topic,
      'type': type,
      'pubTopic': pubTopic,
      'payload': payload,
      'jsonPath': jsonPath,
    };
  }

  Map<String, dynamic> toJson() {
    //This will be used to convert WidgetItem objects that
    //are to be stored into the datbase in a form of JSON
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['topic'] = topic;
    data['type'] = type;
    data['pubTopic'] = pubTopic;
    data['payload'] = payload;
    data['jsonPath'] = jsonPath;
    return data;
  }

  WidgetItem copyWith({
    int id,
    String name,
    String topic,
    String type,
    String pubTopic,
    String payload,
    String jsonPath,
  }) {
    return WidgetItem(
      id: id ?? this.id,
      name: name ?? this.name,
      topic: topic ?? this.topic,
      type: type ?? this.type,
      pubTopic: pubTopic ?? this.pubTopic,
      payload: payload ?? this.payload,
      jsonPath: jsonPath ?? this.jsonPath,
    );
  }

  @override
  // TODO: implement props
  List<Object> get props =>
      [id, name, topic, type, pubTopic, payload, jsonPath];
}
