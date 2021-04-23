import 'package:flutter/widgets.dart';

class ArchSampleKeys {
  // Home Screens
  static const homeScreen = Key('__homeScreen__');
  static const addBrokerFab = Key('__addBrokerFab__');
  static const snackbar = Key('__snackbar__');
  static Key snackbarAction(String id) => Key('__snackbar_action_${id}__');

  // Brokers
  static const brokerList = Key('__brokerList__');
  static const brokersLoading = Key('__brokersLoading__');
  static final brokerItem = (int id) => Key('BrokerItem__$id');
  static final brokerItemCheckbox =
      (int id) => Key('BrokerItem__${id}__Checkbox');
  static final brokerItemTask = (int id) => Key('WidgetItem__${id}__Task');
  static final brokerItemNote = (int id) => Key('BrokerItem__${id}__Note');

  // Widgets
  static const widgetList = Key('__widgetList__');
  static const widgetsLoading = Key('__widgetsLoading__');
  static final widgetItem = (int id) => Key('WidgetItem__$id');
  static final widgetItemCheckbox =
      (int id) => Key('WidgetItem__${id}__Checkbox');
  static final widgetItemTask = (int id) => Key('WidgetItem__${id}__Task');
  static final widgetItemNote = (int id) => Key('WidgetItem__${id}__Note');

  // Tabs
  static const tabs = Key('__tabs__');
  static const brokersTab = Key('__brokersTab__');
  static const subscriptionsTab = Key('__subscriptionsTab__');
  static const messagesTab = Key('__messagesTab__');
  static const widgetsTab = Key('__widgetsTab__');

  // Extra Actions
  static const extraActionsButton = Key('__extraActionsButton__');
  static const toggleAll = Key('__markAllDone__');
  static const clearCompleted = Key('__clearCompleted__');

  // Filters
  static const filterButton = Key('__filterButton__');
  static const allFilter = Key('__allFilter__');
  static const activeFilter = Key('__activeFilter__');
  static const completedFilter = Key('__completedFilter__');

  // Stats
  static const statsCounter = Key('__statsCounter__');
  static const statsLoading = Key('__statsLoading__');
  static const statsNumActive = Key('__statsActiveItems__');
  static const statsNumCompleted = Key('__statsCompletedItems__');

  // Details Screen
  static const editTodoFab = Key('__editTodoFab__');
  static const deleteTodoButton = Key('__deleteTodoFab__');
  static const todoDetailsScreen = Key('__todoDetailsScreen__');
  static final detailsTodoItemCheckbox = Key('DetailsTodo__Checkbox');
  static final detailsTodoItemTask = Key('DetailsTodo__Task');
  static final detailsTodoItemNote = Key('DetailsTodo__Note');

  // Add Screen
  static const addTodoScreen = Key('__addTodoScreen__');
  static const saveNewTodo = Key('__saveNewTodo__');
  static const taskField = Key('__taskField__');
  static const noteField = Key('__noteField__');

  // Edit Screen
  static const editTodoScreen = Key('__editTodoScreen__');
  static const saveTodoFab = Key('__saveTodoFab__');

  // Added Keys
  static final extraActionsPopupMenuButton =
      const Key('__extraActionsPopupMenuButton__');
  static final extraActionsEmptyContainer =
      const Key('__extraActionsEmptyContainer__');
  static final filteredTodosEmptyContainer =
      const Key('__filteredTodosEmptyContainer__');
  static final statsLoadInProgressIndicator =
      const Key('__statsLoadingIndicator__');
  static final emptyStatsContainer = const Key('__emptyStatsContainer__');
  static final emptyDetailsContainer = const Key('__emptyDetailsContainer__');
  static final detailsScreenCheckBox = const Key('__detailsScreenCheckBox__');
}
