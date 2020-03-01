import 'package:gottask/base/base_event.dart';
import 'package:gottask/models/today_task.dart';

class EditTodayTaskEvent extends BaseEvent {
  final TodayTask newTodayTask;
  EditTodayTaskEvent({this.newTodayTask});
}
