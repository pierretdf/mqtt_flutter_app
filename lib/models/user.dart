import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class User extends Equatable {
  final String name;
  final String id;

  const User({this.id, @required this.name});

  @override
  List<Object> get props => [id, name];
}
