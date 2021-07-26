import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Topic extends Equatable {
  final int id;
  final int brokerId;
  final String title;

  const Topic({this.id, @required this.brokerId, @required this.title});

  factory Topic.fromJson(Map<String, dynamic> json) {
    // This will be used to convert JSON objects that are coming from
    // querying the database and converting it into a Topic object
    return Topic(
      id: json['id'],
      brokerId: json['brokerId'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    //This will be used to convert Topic objects that
    //are to be stored into the datbase in a form of JSON
    final data = <String, dynamic>{};
    data['id'] = id;
    data['brokerId'] = brokerId;
    data['title'] = title;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'brokerId': brokerId,
      'title': title,
    };
  }

  Topic copyWith({
    int id,
    int brokerId,
    String title,
  }) {
    return Topic(
      id: id ?? this.id,
      brokerId: brokerId ?? this.brokerId,
      title: title ?? this.title,
    );
  }

  @override
  List<Object> get props => [id, brokerId, title];
}
