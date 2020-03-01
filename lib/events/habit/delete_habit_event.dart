import 'package:gottask/base/base_event.dart';
import 'package:gottask/models/habit.dart';

class DeleteHabitEvent extends BaseEvent {
  final Habit habit;
  DeleteHabitEvent({this.habit});
}
