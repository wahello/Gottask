import 'package:gottask/base/base_event.dart';
import 'package:gottask/models/today_task.dart';

class DeleteTodayTaskEvent extends BaseEvent {
  TodayTask todayTask;
  DeleteTodayTaskEvent({this.todayTask});
}
