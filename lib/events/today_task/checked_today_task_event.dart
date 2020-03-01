

import 'package:gottask/base/base_event.dart';
import 'package:gottask/models/today_task.dart';

class CheckedTodayTaskEvent extends BaseEvent {
  final TodayTask todayTask;
  final bool value;

  CheckedTodayTaskEvent({this.todayTask, this.value});
}
