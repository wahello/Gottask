import 'package:gottask/base/base_event.dart';
import 'package:gottask/models/habit.dart';

class AddHabitEvent extends BaseEvent {
  Habit habit;
  AddHabitEvent({
    this.habit,
  });
}
