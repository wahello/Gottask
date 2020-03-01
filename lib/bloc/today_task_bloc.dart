import 'dart:async';
import 'dart:io';

import 'package:gottask/base/base_bloc.dart';
import 'package:gottask/base/base_event.dart';
import 'package:gottask/database/todayTaskDatabase.dart';
import 'package:gottask/database/todayTaskTable.dart';
import 'package:gottask/events/today_task/add_today_task_event.dart';
import 'package:gottask/events/today_task/checked_today_task_event.dart';
import 'package:gottask/events/today_task/delete_today_task_event.dart';
import 'package:gottask/events/today_task/edit_today_task_event.dart';
import 'package:gottask/models/today_task.dart';

List<TodayTask> todayTaskList = [];

class TodayTaskBloc extends BaseBloc {
  final StreamController<List<TodayTask>> _listTodayTaskStreamController =
      StreamController<List<TodayTask>>();

  Stream<List<TodayTask>> get listTodayTaskStream =>
      _listTodayTaskStreamController.stream;

  Sink<List<TodayTask>> get listTodayTaskSink =>
      _listTodayTaskStreamController.sink;

  Future<void> initTodayBloc() async {
    await TodayTaskDatabase.instance.init();
    todayTaskList = await TodayTaskTable().selectAllTodo();
    _listTodayTaskStreamController.sink.add(todayTaskList);
  }

  Future<void> _addEvent(TodayTask todayTask) async {
    await TodayTaskTable().insertTodo(todayTask);
    todayTaskList = await TodayTaskTable().selectAllTodo();
    _listTodayTaskStreamController.sink.add(todayTaskList);
  }

  Future<void> _deleteEvent(TodayTask todayTask) async {
    List<String> imageLinks =
        todayTask.images.substring(1, todayTask.images.length - 1).split(', ');
    if (imageLinks[0] != '') {
      imageLinks.forEach((path) {
        var dir = File(path);
        dir.deleteSync(recursive: true);
      });
    }
    if (todayTask.audioPath != '') {
      var audioFile = File(todayTask.audioPath);
      audioFile.deleteSync(recursive: true);
    }
    await TodayTaskTable().deleteTodo(todayTask.id);
    todayTaskList = await TodayTaskTable().selectAllTodo();
    _listTodayTaskStreamController.sink.add(todayTaskList);
  }

  Future<void> _checkedEvent(TodayTask todayTask) async {
    TodayTask newTodayTask = TodayTask(
      id: todayTask.id,
      content: todayTask.content,
      images: todayTask.images,
      isDone: !todayTask.isDone,
      color: todayTask.color,
      audioPath: todayTask.audioPath,
      catagories: todayTask.catagories,
    );
    await TodayTaskTable().updateTodo(newTodayTask);
    todayTaskList = await TodayTaskTable().selectAllTodo();
    _listTodayTaskStreamController.sink.add(todayTaskList);
  }

  Future<void> _editEvent(TodayTask newTodayTask) async {
    await TodayTaskTable().updateTodo(newTodayTask);
    todayTaskList = await TodayTaskTable().selectAllTodo();
    _listTodayTaskStreamController.sink.add(todayTaskList);
  }

  @override
  void actEvent(BaseEvent event) {
    if (event is AddTodayTaskEvent) {
      _addEvent(event.todayTask);
    } else if (event is DeleteTodayTaskEvent) {
      _deleteEvent(event.todayTask);
    } else if (event is CheckedTodayTaskEvent) {
      _checkedEvent(event.todayTask);
    } else if (event is EditTodayTaskEvent) {
      _editEvent(event.newTodayTask);
    }
  }

  @override
  void dispose() {
    _listTodayTaskStreamController.close();
    super.dispose();
  }
}
