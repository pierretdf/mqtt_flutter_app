import 'package:equatable/equatable.dart';

import '../../models/models.dart';

abstract class WidgetEvent extends Equatable {
  const WidgetEvent();

  @override
  List<Object> get props => [];
}

class WidgetItemsLoaded extends WidgetEvent {}

class WidgetItemAdded extends WidgetEvent {
  final WidgetItem widgetItem;

  const WidgetItemAdded(this.widgetItem);

  @override
  List<Object> get props => [widgetItem];

  @override
  String toString() => 'WidgetItemAdded { widgetItem: $widgetItem }';
}

class WidgetItemUpdated extends WidgetEvent {
  final WidgetItem widgetItem;

  const WidgetItemUpdated(this.widgetItem);

  @override
  List<Object> get props => [widgetItem];

  @override
  String toString() => 'WidgetItemUpdated { updatedWidgetItem: $widgetItem }';
}

class WidgetItemDeleted extends WidgetEvent {
  final WidgetItem widgetItem;

  const WidgetItemDeleted(this.widgetItem);

  @override
  List<Object> get props => [widgetItem];

  @override
  String toString() => 'WidgetItemDeleted { widgetItem: $widgetItem }';
}
