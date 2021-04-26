import 'package:equatable/equatable.dart';

import '../../models/models.dart';

abstract class WidgetState extends Equatable {
  const WidgetState();

  @override
  List<Object> get props => [];
}

class WidgetItemLoadInProgress extends WidgetState {}

class WidgetItemLoadSuccess extends WidgetState {
  final List<WidgetItem> widgetItems;
  //const WidgetItemLoadSuccess({this.widgetItems});

  const WidgetItemLoadSuccess([this.widgetItems = const []]);

  @override
  List<Object> get props => [widgetItems];
}

class WidgetItemLoadFailure extends WidgetState {
  final Error error;
  const WidgetItemLoadFailure({this.error});
}
