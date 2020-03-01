import 'package:flutter/material.dart';
import 'package:gottask/base/base_event.dart';
import 'package:gottask/models/do_del_done_habit.dart';

class UpdateDoDelDoneHabitEvent extends BaseEvent {
  final DoDelDoneHabit doDelDoneHabit;
  UpdateDoDelDoneHabitEvent({@required this.doDelDoneHabit});
}
