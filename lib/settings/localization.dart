import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FlutterBlocLocalizations {
  static FlutterBlocLocalizations of(BuildContext context) {
    return Localizations.of<FlutterBlocLocalizations>(
      context,
      FlutterBlocLocalizations,
    );
  }

  // MQTT
  // Broker
  String get broker => "Broker";
  String get brokers => "Brokers";
  String get addBroker => "Add Broker";
  String get editBroker => "Edit Broker";
  String get brokerDetails => "Broker details";

  String get newBrokerAddress => "What's the broker address ?";
  String get newBrokerName => "What's the broker name ?";
  String get newBrokerIdentifier => "What's your identifier ?";
  String get emptyBrokerError => "Please enter some text !";
  String get brokerDeleted => 'Broker deleted';

  // Widget
  String get widgets => 'Widgets';
  String get addWidget => 'Add Widget';
  String get editWidget => "Edit Widget";
  String get emptyWidgetError => "Please enter some text !";
  String get newWidgetName => "What's the widget name ?";
  String get newWidgetType => "What's the widget type ?";
  String get widgetDeleted => 'Widget deleted';

  // Subscriptions
  String get subscriptions => "Subscriptions";
  String get newTopic => "Enter a new topic";
  String get emptyTopicTitleError => "Please enter a topic title !";

  // Messages
  String get messages => "Messages";

  // Home Screen
  String get appTitle => "MQTT Manager";

  // Tabs

  // Details Screen

  // Add Screen

  // Edit Screen

  // SnackBar
  String get undo => 'Undo';
  String get saveChanges => 'Save Changes';

  // TODO add every text in this file ! How to translate ?? Using Intl pub ??
}

class FlutterBlocLocalizationsDelegate
    extends LocalizationsDelegate<FlutterBlocLocalizations> {
  @override
  Future<FlutterBlocLocalizations> load(Locale locale) =>
      Future(() => FlutterBlocLocalizations());

  @override
  bool shouldReload(FlutterBlocLocalizationsDelegate old) => false;

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode.toLowerCase().contains('en');
}
