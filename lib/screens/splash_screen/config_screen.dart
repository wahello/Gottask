import 'package:flutter/material.dart';
import 'package:gottask/bloc/current_pokemon_bloc.dart';
import 'package:gottask/bloc/do_del_done_habit_bloc.dart';
import 'package:gottask/bloc/do_del_done_todo_bloc.dart';
import 'package:gottask/bloc/habit_bloc.dart';
import 'package:gottask/bloc/pokemon_bloc.dart';
import 'package:gottask/bloc/star_bloc.dart';
import 'package:gottask/bloc/today_task_bloc.dart';
import 'package:gottask/screens/home_screen.dart';
import 'package:provider/provider.dart';

class ConfigScreen extends StatefulWidget {
  @override
  _ConfigScreenState createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<TodayTaskBloc>.value(
          value: TodayTaskBloc(),
        ),
        Provider<HabitBloc>.value(
          value: HabitBloc(),
        ),
        Provider<DoDelDoneHabitBloc>.value(
          value: DoDelDoneHabitBloc(),
        ),
        Provider<DoDelDoneTodoBloc>.value(
          value: DoDelDoneTodoBloc(),
        ),
        Provider<PokemonStateBloc>.value(
          value: PokemonStateBloc(),
        ),
        Provider<StarBloc>.value(
          value: StarBloc(),
        ),
        Provider<CurrentPokemonBloc>.value(
          value: CurrentPokemonBloc(),
        ),
      ],
      child: HomeScreen(),
    );
  }
}
