import 'package:flutter/material.dart';
import 'package:gottask/base/base_event.dart';
import 'package:gottask/models/today_task.dart';

class AddTodayTaskEvent extends BaseEvent {
  final TodayTask todayTask;
  AddTodayTaskEvent({
    @required this.todayTask,
  });
}
