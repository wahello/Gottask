import 'dart:async';

import 'package:gottask/base/base_bloc.dart';
import 'package:gottask/base/base_event.dart';
import 'package:gottask/database/doDelDoneHabitDatabase.dart';
import 'package:gottask/database/doDelDoneHabitTable.dart';
import 'package:gottask/events/do_del_done/update_dodeldone_habit_event.dart';
import 'package:gottask/models/do_del_done_habit.dart';


DoDelDoneHabit habit;

class DoDelDoneHabitBloc extends BaseBloc {
  final StreamController<DoDelDoneHabit> _doDelDoneHabitStreamController =
      StreamController<DoDelDoneHabit>();

  Stream<DoDelDoneHabit> get doDelDoneHabitStream =>
      _doDelDoneHabitStreamController.stream;

  Sink<DoDelDoneHabit> get doDelDoneHabitSink => _doDelDoneHabitStreamController.sink;

  @override
  void dispose() {
    _doDelDoneHabitStreamController.close();
    super.dispose();
  }

  Future<void> initDoDelDoneHabitBloc() async {
    await DoDelDoneHabitDatabase.instance.init();
    habit = await DoDelDoneHabitTable().selectDoDelDoneHabit();
    _doDelDoneHabitStreamController.sink.add(habit);
  }

  Future<void> _updateEvent(DoDelDoneHabit doDelDoneHabit) async {
    await DoDelDoneHabitTable().updateDoDelDoneHabit(doDelDoneHabit);
    habit = doDelDoneHabit;
    _doDelDoneHabitStreamController.sink.add(habit);
  }

  @override
  void actEvent(BaseEvent event) {
    if (event is UpdateDoDelDoneHabitEvent) {
      _updateEvent(event.doDelDoneHabit);
    }
  }
}
