import 'dart:async';

import 'package:gottask/base/base_bloc.dart';
import 'package:gottask/base/base_event.dart';
import 'package:gottask/database/habitDatabase.dart';
import 'package:gottask/database/habitTable.dart';
import 'package:gottask/events/habit/add_habit_event.dart';
import 'package:gottask/events/habit/delete_habit_event.dart';
import 'package:gottask/events/habit/update_habit_event.dart';
import 'package:gottask/models/habit.dart';



List<Habit> habitList = [];

class HabitBloc extends BaseBloc {
  final StreamController<List<Habit>> _habitStreamController =
      StreamController<List<Habit>>();
  Stream<List<Habit>> get listHabitStream => _habitStreamController.stream;

  Sink<List<Habit>> get listHabitSink => _habitStreamController.sink;

  Future<void> initHabitBloc() async {
    await HabitDatabase.instance.init();
    habitList = await HabitTable().selectAllHabit();
    _habitStreamController.sink.add(habitList);
  }

  @override
  void dispose() {
    _habitStreamController.close();
    super.dispose();
  }

  Future<void> _addEvent(Habit habit) async {
    habitList.add(habit);
    await HabitTable().insertHabit(habit);
    print('add: ${habit.toMap().toString()}');
    listHabitSink.add(habitList);
  }

  Future<void> _updateEvent(Habit habit) async {
    await HabitTable().updateHabit(habit);
    habitList = await HabitTable().selectAllHabit();
    listHabitSink.add(habitList);
  }

  Future<void> _deleteEvent(Habit habit) async {
    await HabitTable().deleteHabit(habit);
    habitList = await HabitTable().selectAllHabit();
    listHabitSink.add(habitList);
  }

  @override
  void actEvent(BaseEvent event) {
    if (event is AddHabitEvent) {
      _addEvent(event.habit);
    } else if (event is UpdateHabitEvent) {
      _updateEvent(event.habit);
    } else if (event is DeleteHabitEvent) {
      _deleteEvent(event.habit);
    }
  }
}
