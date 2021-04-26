import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../models/models.dart';
import '../../services/widget_repository.dart';
import '../blocs.dart';

class WidgetBloc extends Bloc<WidgetEvent, WidgetState> {
  final WidgetRepository widgetRepository;

  WidgetBloc(this.widgetRepository) : super(WidgetItemLoadInProgress());

  @override
  Stream<WidgetState> mapEventToState(WidgetEvent event) async* {
    if (event is WidgetItemsLoaded) {
      yield* _mapWidgetItemsLoadedToState();
    } else if (event is WidgetItemAdded) {
      yield* _mapWidgetItemAddedToState(event);
    } else if (event is WidgetItemUpdated) {
      yield* _mapWidgetItemUpdatedToState(event);
    } else if (event is WidgetItemDeleted) {
      yield* _mapWidgetItemDeletedToState(event);
    }
  }

  Stream<WidgetState> _mapWidgetItemsLoadedToState() async* {
    try {
      final widgetItems = await widgetRepository.getWidgetItems();
      yield WidgetItemLoadSuccess(widgetItems);
    } catch (e) {
      //yield WidgetItemLoadFailure(error: e);
    }
  }

  Stream<WidgetState> _mapWidgetItemAddedToState(WidgetItemAdded event) async* {
    if (state is WidgetItemLoadSuccess) {
      // Add WidgetItem to 'widget_item_view' (UI)
      final updatedWidgetItems =
          List<WidgetItem>.from((state as WidgetItemLoadSuccess).widgetItems)
            ..add(event.widgetItem);
      yield WidgetItemLoadSuccess(updatedWidgetItems);
      await widgetRepository.addWidgetItem(event.widgetItem);
    }
  }

  Stream<WidgetState> _mapWidgetItemUpdatedToState(
      WidgetItemUpdated event) async* {
    if (state is WidgetItemLoadSuccess) {
      final updatedWidgetItems =
          (state as WidgetItemLoadSuccess).widgetItems.map((widgetItem) {
        return widgetItem.id == event.widgetItem.id
            ? event.widgetItem
            : widgetItem;
      }).toList();
      yield WidgetItemLoadSuccess(updatedWidgetItems);
      await widgetRepository.updateWidgetItem(event.widgetItem);
    }
  }

  Stream<WidgetState> _mapWidgetItemDeletedToState(
      WidgetItemDeleted event) async* {
    if (state is WidgetItemLoadSuccess) {
      final updatedWidgetItems = (state as WidgetItemLoadSuccess)
          .widgetItems
          .where((widgetItem) => widgetItem.id != event.widgetItem.id)
          .toList();
      yield WidgetItemLoadSuccess(updatedWidgetItems);
      await widgetRepository.deleteWidgetItem(event.widgetItem.id);
    }
  }
}
