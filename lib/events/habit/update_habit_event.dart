import 'package:gottask/base/base_event.dart';
import 'package:gottask/models/habit.dart';

class UpdateHabitEvent extends BaseEvent {
  Habit habit;
  UpdateHabitEvent({
    this.habit,
  });
}
