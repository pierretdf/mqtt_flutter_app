import 'dart:async';
import 'package:bloc/bloc.dart';
import '../../models/models.dart';
import '../blocs.dart';

class TabBloc extends Bloc<TabEvent, AppTab> {
  TabBloc() : super(AppTab.brokers);

  @override
  Stream<AppTab> mapEventToState(TabEvent event) async* {
    if (event is TabUpdated) {
      yield event.tab;
    }
  }
}
