import 'package:flutter/widgets.dart';

class AppKeys {
  // Home Screens
  static const homeScreen = Key('__homeScreen__');
  static const addBrokerFab = Key('__addBrokerFab__');
  static const addWidgetFab = Key('__addWidgetFab__');
  static const bottomsheet = Key('__bottomsheet__');
  static const snackbar = Key('__snackbar__');
  static Key snackbarAction(String id) => Key('__snackbar_action_${id}__');

  // Brokers
  static const brokerList = Key('__brokerList__');
  static const brokersLoading = Key('__brokersLoading__');
  static final brokerItem = (int id) => Key('BrokerItem__$id');
  static final brokerItemName = (int id) => Key('WidgetItem__${id}__Name');
  static final brokerItemAddress =
      (int id) => Key('BrokerItem__${id}__Address');

  // Widgets
  static const widgetList = Key('__widgetList__');
  static const widgetsLoading = Key('__widgetsLoading__');
  static final widgetItem = (int id) => Key('WidgetItem__$id');
  static final widgetItemNote = (int id) => Key('WidgetItem__${id}__Note'); //!

  // Tabs
  static const tabs = Key('__tabs__');
  static const brokersTab = Key('__brokersTab__');
  static const subscriptionsTab = Key('__subscriptionsTab__');
  static const messagesTab = Key('__messagesTab__');
  static const widgetsTab = Key('__widgetsTab__');

  // Subscriptions
  static const subscriptionButton = Key('__subscriptionButton__');

  // Broker Details Screen
  static const editBrokerFab = Key('__editBrokerFab__');
  static const deleteBrokerButton = Key('__deleteBrokerButton__');
  static const brokerDetailsScreen = Key('__brokerDetailsScreen__');
  static const detailsBrokerItemName = Key('DetailsBroker__Name');
  static const detailsBrokerItemAddress = Key('DetailsBroker__Address');
  static const detailsBrokerItemPort = Key('DetailsBroker__Port');
  static const detailsBrokerItemIdentifier = Key('DetailsBroker__Identifier');
  static const detailsBrokerItemUsername = Key('DetailsBroker__Username');
  static const detailsBrokerItemPassword = Key('DetailsBroker__Password');
  static const detailsBrokerItemPrivateKeyPassword =
      Key('DetailsBroker__PrivateKeyPassword');
  // TODO Add all others broker field attributes for details screen

  // Widget Details Screen
  static const editWidgetFab = Key('__editWidgetFab__');
  static const deleteWidgetButton = Key('__deleteWidgetFab__');
  static const widgetDetailsScreen = Key('__widgetDetailsScreen__');
  static const detailsWidgetItemName = Key('DetailsWidget__Name');
  static const detailsWidgetItemType = Key('DetailsWidget__Type');
  // TODO Add all others widget field attributes for details screen

  // Add Broker Screen
  static const addBrokerScreen = Key('__addBrokerScreen__');
  static const saveNewBroker = Key('__saveNewBroker__');
  static const brokerNameField = Key('__brokerNameField__');
  static const brokerAddressField = Key('__brokerAddressField__');
  static const brokerPortField = Key('__brokerPortField__');
  static const brokerIdentifierField = Key('__brokerIdentifierField__');
  static const brokerAuthenticationField = Key('__brokerAuthenticationField__');
  static const brokerUsernameField = Key('__brokerUsernameField__');
  static const brokerPasswordField = Key('__brokerPasswordField__');
  static const brokerSecureField = Key('__brokerSecureField__');
  // TODO Add all others broker field attributes

  // Add Widget Screen
  static const addWidgetScreen = Key('__addWidgetScreen__');
  static const saveNewWidget = Key('__saveNewWidget__');
  static const widgetNameField = Key('__widgetNameField__');
  static const widgetTypeField = Key('__widgetTypeField__');
  // TODO Add all others widget field attributes

  // Edit Broker Screen
  static const editBrokerScreen = Key('__editBrokerScreen__');
  static const saveBrokerFab = Key('__saveBrokerFab__');

  // Edit Widget Screen
  static const editWidgetScreen = Key('__editWidgetScreen__');
  static const saveWidgetFab = Key('__saveWidgetFab__');

  // Added Keys
  static const brokersEmptyContainer = Key('__brokersEmptyContainer__');
  static const emptyWidgetsContainer = Key('__emptyWidgetsContainer__');
  static const emptyDetailsContainer = Key('__emptyDetailsContainer__');
}
