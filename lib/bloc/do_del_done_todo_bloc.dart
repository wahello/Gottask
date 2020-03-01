import 'dart:async';

import 'package:gottask/base/base_bloc.dart';
import 'package:gottask/base/base_event.dart';
import 'package:gottask/database/doDelDoneTodoDatabase.dart';
import 'package:gottask/database/doDelDoneTodoTable.dart';
import 'package:gottask/events/do_del_done/update_dodeldone_todo_event.dart';
import 'package:gottask/models/do_del_done_task.dart';

DoDelDoneTodo habit;

class DoDelDoneTodoBloc extends BaseBloc {
  final StreamController<DoDelDoneTodo> _doDelDoneTodoStreamController =
      StreamController<DoDelDoneTodo>();

  Stream<DoDelDoneTodo> get doDelDoneTodoStream =>
      _doDelDoneTodoStreamController.stream;

  Sink<DoDelDoneTodo> get doDelDoneTodoSink =>
      _doDelDoneTodoStreamController.sink;

  @override
  void dispose() {
    _doDelDoneTodoStreamController.close();
    super.dispose();
  }

  Future<void> initDoDelDoneTodoBloc() async {
    await DoDelDoneTodoDatabase.instance.init();
    habit = await DoDelDoneTodoTable().selectDoDelDoneTodo();
    _doDelDoneTodoStreamController.sink.add(habit);
  }

  Future<void> _updateEvent(DoDelDoneTodo doDelDoneTodo) async {
    await DoDelDoneTodoTable().updateDoDelDoneTodo(doDelDoneTodo);
    habit = doDelDoneTodo;
    _doDelDoneTodoStreamController.sink.add(habit);
  }

  @override
  void actEvent(BaseEvent event) {
    if (event is UpdateDoDelDoneTodoEvent) {
      _updateEvent(event.doDelDoneTodo);
    }
  }
}
