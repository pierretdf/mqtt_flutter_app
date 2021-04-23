import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Broker extends Equatable {
  final int id;
  final String name;
  final String address;
  final int port;
  final String username; // Optionnal
  final String password; // Optionnal
  final String identifier;
  final bool secure;
  final int qos;
  final String certificatePath; // Optionnal
  final String privateKeyPath; // Optionnal
  final String privateKeyPassword; // Optionnal
  final String clientAuthorityPath; // Optionnal
  final String state;

  Broker({
    this.id,
    @required this.name,
    @required this.address,
    @required this.port,
    this.username,
    this.password,
    this.identifier,
    @required this.secure,
    this.qos,
    this.certificatePath,
    this.privateKeyPath,
    this.privateKeyPassword,
    this.clientAuthorityPath,
    this.state = 'disconnected',
  });

  @override
  List<Object> get props {
    return [
      id,
      name,
      address,
      port,
      username,
      password,
      identifier,
      secure,
      qos,
      certificatePath,
      privateKeyPath,
      privateKeyPassword,
      clientAuthorityPath,
      state,
    ];
  }

  factory Broker.fromJson(Map<String, dynamic> json) {
    //This will be used to convert JSON objects that
    //are coming from querying the database and converting
    //it into a Broker object
    if (json == null) return null;
    return Broker(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      port: json['port'],
      username: json['username'],
      password: json['password'],
      identifier: json['identifier'],
      secure: json['secure'],
      qos: json['qos'],
      certificatePath: json['certificatePath'],
      privateKeyPath: json['privateKeyPath'],
      privateKeyPassword: json['privateKeyPassword'],
      clientAuthorityPath: json['clientAuthorityPath'],
      state: json['state'],
    );
  }

  Map<String, dynamic> toJson() {
    //This will be used to convert Broker objects that
    //are to be stored into the datbase in a form of JSON
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['address'] = this.address;
    data['port'] = this.port;
    data['username'] = this.username;
    data['password'] = this.password;
    data['identifier'] = this.identifier;
    data['secure'] = this.secure ? 1 : 0;
    data['qos'] = this.qos;
    data['certificatePath'] = this.certificatePath;
    data['privateKeyPath'] = this.privateKeyPath;
    data['privateKeyPassword'] = this.privateKeyPassword;
    data['clientAuthorityPath'] = this.clientAuthorityPath;
    data['state'] = this.state;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'port': port,
      'username': username,
      'password': password,
      'identifier': identifier,
      'secure': secure ? 1 : 0,
      'qos': qos,
      'certificatePath': certificatePath,
      'privateKeyPath': privateKeyPath,
      'privateKeyPassword': privateKeyPassword,
      'clientAuthorityPath': clientAuthorityPath,
      'state': state,
    };
  }

  @override
  String toString() =>
      'Broker(id: $id, name: $name, address: $address, port: $port,username: $username,password: $password,identifier: $identifier,secure: $secure,qos: $qos,certificatePath: $certificatePath,privateKeyPath: $privateKeyPath, privateKeyPassword: $privateKeyPassword, clientAuthorityPath: $clientAuthorityPath, state: $state)';

  Broker copyWith({
    int id,
    String name,
    String address,
    int port,
    String username,
    String password,
    String identifier,
    bool secure,
    int qos,
    String certificatePath,
    String privateKeyPath,
    String privateKeyPassword,
    String clientAuthorityPath,
    String state,
  }) {
    return Broker(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      port: port ?? this.port,
      username: username ?? this.username,
      password: password ?? this.password,
      identifier: identifier ?? this.identifier,
      secure: secure ?? this.secure,
      qos: qos ?? this.qos,
      certificatePath: certificatePath ?? this.certificatePath,
      privateKeyPath: privateKeyPath ?? this.privateKeyPath,
      privateKeyPassword: privateKeyPassword ?? this.privateKeyPassword,
      clientAuthorityPath: clientAuthorityPath ?? this.clientAuthorityPath,
      state: state ?? this.state,
    );
  }
}
