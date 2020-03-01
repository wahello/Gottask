import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:gottask/bloc/all_pokemon_bloc.dart';
import 'package:gottask/bloc/current_pokemon_bloc.dart';
import 'package:gottask/bloc/do_del_done_habit_bloc.dart';
import 'package:gottask/bloc/do_del_done_todo_bloc.dart';
import 'package:gottask/bloc/habit_bloc.dart';
import 'package:gottask/bloc/handside_bloc.dart';
import 'package:gottask/bloc/pokemon_bloc.dart';
import 'package:gottask/bloc/star_bloc.dart';
import 'package:gottask/bloc/today_task_bloc.dart';
import 'package:gottask/components/habit_tile.dart';
import 'package:gottask/components/today_task_tile.dart';
import 'package:gottask/models/habit.dart';
import 'package:gottask/models/pokemon_state.dart';
import 'package:gottask/models/today_task.dart';
import 'package:gottask/screens/habit_screen/add_habit_screen.dart';
import 'package:gottask/screens/pokemon_screen/all_pokemon_screen.dart';
import 'package:gottask/screens/pokemon_screen/pokemon_info_screen.dart';
import 'package:gottask/screens/todo_screen/add_today_task_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../constant.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  bool _isInit = false;

  TodayTaskBloc _todayTaskBloc;
  HabitBloc _habitBloc;
  DoDelDoneHabitBloc _doDelDoneHabitBloc;
  DoDelDoneTodoBloc _doDelDoneTodoBloc;
  PokemonStateBloc _pokemonStateBloc;
  StarBloc _starBloc;
  CurrentPokemonBloc _currentPokemonBloc;

  void _modalBottomSheetMenu() {
    showModalBottomSheet(
        context: context, builder: (ctx) => AddTodayTaskScreen(ctx: context));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _todayTaskBloc = Provider.of<TodayTaskBloc>(context);
    _habitBloc = Provider.of<HabitBloc>(context);
    _doDelDoneHabitBloc = Provider.of<DoDelDoneHabitBloc>(context);
    _doDelDoneTodoBloc = Provider.of<DoDelDoneTodoBloc>(context);
    _pokemonStateBloc = Provider.of<PokemonStateBloc>(context);
    _starBloc = Provider.of<StarBloc>(context);
    _currentPokemonBloc = Provider.of<CurrentPokemonBloc>(context);

    if (_isInit == false) {
      _todayTaskBloc.initTodayBloc();
      _habitBloc.initHabitBloc();
      _doDelDoneHabitBloc.initDoDelDoneHabitBloc();
      _doDelDoneTodoBloc.initDoDelDoneTodoBloc();
      _pokemonStateBloc.initPokemonStateBloc();
      _starBloc.initStarBloc();
      _currentPokemonBloc.initCurrentPokemonBloc();
      _isInit = true;
    }
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            stops: const [0.25, 0.463, 0.2, 0.7, 0.9],
            colors: [
              TodoColors.scaffoldWhite,
              TodoColors.scaffoldWhite,
              TodoColors.scaffoldWhite,
              TodoColors.scaffoldWhite,
              Color(0xFFFEDCBA),
            ],
          ),
        ),
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          backgroundColor: Colors.transparent,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 15,
                      top: 15,
                    ),
                    child: _buildHeader(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 5,
                    ),
                    child: Material(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      elevation: 7,
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: _buildPetCollection(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                    ),
                    child: _buildHabitTitle(),
                  ),
                  buildHabit(),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                    ),
                    child: _buildTodaysTaskHeader(),
                  ),
                ],
              ),
              _buildTodayTask(),
            ],
          ),
        ),
      ),
    );
  }

  Consumer<HabitBloc> buildHabit() => Consumer<HabitBloc>(
        builder: (context, bloc, child) => StreamBuilder<List<Habit>>(
          initialData: [],
          stream: bloc.listHabitStream,
          builder: (context, snapshot) {
            if (snapshot.hasData == false) {
              return SizedBox(
                height: kListViewHeight + 2,
                width: double.infinity,
                child: const Center(
                  child: Text(
                    'Empty task',
                    style: TextStyle(fontFamily: 'Alata', fontSize: 16),
                  ),
                ),
              );
            }
            if (snapshot.data.isEmpty) {
              {
                return SizedBox(
                  height: kListViewHeight + 2,
                  width: double.infinity,
                  child: const Center(
                    child: Text(
                      'Empty task',
                      style: TextStyle(fontFamily: 'Alata', fontSize: 16),
                    ),
                  ),
                );
              }
            }
            return Padding(
              padding: const EdgeInsets.only(left: 10),
              child: SizedBox(
                height: kListViewHeight + 2,
                width: double.infinity,
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: snapshot.data.length + 1,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    if (index == snapshot.data.length) {
                      return Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AddHabitScreen(
                                  ctx: context,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 15),
                            height: kListViewHeight,
                            width: kListViewHeight,
                            child: DottedBorder(
                              radius: const Radius.circular(30),
                              borderType: BorderType.RRect,
                              dashPattern: const [20, 5, 20, 5],
                              color: Colors.grey,
                              child: Center(
                                child: Icon(
                                  Icons.add,
                                  color: Colors.grey,
                                  size: 40,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    return Center(
                      child: HabitTile(
                        habit: snapshot.data[index],
                        key: UniqueKey(),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      );

  Widget _buildPetCollection() {
    return Consumer<PokemonStateBloc>(
      builder: (context, bloc, child) => Container(
        height: 80,
        width: MediaQuery.of(context).size.width - 20,
        padding: const EdgeInsets.all(5),
        child: Consumer<PokemonStateBloc>(
          builder: (context, bloc, child) => StreamBuilder<List<PokemonState>>(
            stream: bloc.listPokemonStateStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Text('Waiting ...'),
                );
              }
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                addRepaintBoundaries: true,
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onLongPress: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MultiProvider(
                            providers: [
                              Provider<AllPokemonBloc>.value(
                                value: AllPokemonBloc(),
                              ),
                              Provider<HandsideBloc>.value(
                                value: HandsideBloc(),
                              ),
                            ],
                            child: AllPokemonScreen(
                              ctx: context,
                              currentPokemon: index,
                            ),
                          ),
                        ),
                      );
                    },
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PokemonInfoScreen(
                            ctx: context,
                            imageTag: pokemonImages[index],
                            index: index,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 56,
                      height: 72,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.deepPurple,
                          width: 1,
                        ),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: index < pokemonImages.length - 1
                          ? const EdgeInsets.only(right: 8)
                          : EdgeInsets.zero,
                      padding: const EdgeInsets.all(5),
                      child: Center(
                        child: Stack(
                          children: <Widget>[
                            Image.asset(
                              pokemonImages[index],
                              height: 70,
                              width: 70,
                              color: colorStateOfPokemon(
                                snapshot.data[index].state,
                              ),
                              colorBlendMode: colorBlendStateOfPokemon(
                                snapshot.data[index].state,
                              ),
                            ),
                            if (snapshot.data[index].state == 0)
                              Align(
                                alignment: FractionalOffset.center,
                                child: Icon(
                                  AntDesign.question,
                                  color: Colors.white,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Color colorStateOfPokemon(int state) {
    if (state == 0) {
      return Colors.black45;
    } else {
      return null;
    }
  }

  BlendMode colorBlendStateOfPokemon(int state) {
    if (state == 0) {
      return BlendMode.modulate;
    } else {
      return null;
    }
  }

  Widget _buildTodayTask() => Expanded(
        child: Consumer<TodayTaskBloc>(
          builder: (context, bloc, child) => StreamBuilder<List<TodayTask>>(
            initialData: const [],
            stream: bloc.listTodayTaskStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: Text(
                    'Empty to-do',
                    style: TextStyle(
                      fontFamily: 'Alata',
                      fontSize: 16,
                    ),
                  ),
                );
              }
              if (snapshot.data.isEmpty) {
                return const Center(
                  child: Text(
                    'Empty to-do',
                    style: TextStyle(
                      fontFamily: 'Alata',
                      fontSize: 16,
                    ),
                  ),
                );
              }

              return ListView.builder(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) => TodayTaskTile(
                  ctx: context,
                  task: snapshot.data[index],
                  index: index,
                  key: UniqueKey(),
                ),
              );
            },
          ),
        ),
      );

  Padding _buildTodaysTaskHeader() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text(
              'To-do list',
              style: TextStyle(fontFamily: 'Alata', fontSize: 20),
            ),
            Container(
              width: 25,
              height: 25,
              margin: const EdgeInsets.only(right: 20),
              child: RawMaterialButton(
                fillColor: TodoColors.deepPurple,
                shape: const CircleBorder(),
                elevation: 2,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                onPressed: _modalBottomSheetMenu,
              ),
            ),
          ],
        ),
      );

  Widget _buildHabitTitle() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Task list',
              style: TextStyle(fontFamily: 'Alata', fontSize: 20),
            ),
            const SizedBox(width: 10),
            Container(
              width: 25,
              height: 25,
              margin: const EdgeInsets.only(right: 20),
              child: RawMaterialButton(
                fillColor: TodoColors.deepPurple,
                shape: const CircleBorder(),
                elevation: 2,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddHabitScreen(
                        ctx: context,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );

  Widget _buildHeader() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Row(
              children: <Widget>[
                StreamBuilder<int>(
                  stream: _currentPokemonBloc.currentPokemonStream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Container();
                    if (snapshot.data != -1) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MultiProvider(
                                providers: [
                                  Provider<AllPokemonBloc>.value(
                                    value: AllPokemonBloc(),
                                  ),
                                  Provider<HandsideBloc>.value(
                                    value: HandsideBloc(),
                                  ),
                                ],
                                child: AllPokemonScreen(
                                  ctx: context,
                                  currentPokemon: snapshot.data,
                                ),
                              ),
                            ),
                          );
                        },
                        child: Material(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white,
                          elevation: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              pokemonImages[snapshot.data],
                              height: 30,
                            ),
                          ),
                        ),
                      );
                    } else {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MultiProvider(
                                providers: [
                                  Provider<AllPokemonBloc>.value(
                                    value: AllPokemonBloc(),
                                  ),
                                  Provider<HandsideBloc>.value(
                                    value: HandsideBloc(),
                                  ),
                                ],
                                child: AllPokemonScreen(
                                  ctx: context,
                                  currentPokemon: 0,
                                ),
                              ),
                            ),
                          );
                        },
                        child: Material(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white,
                          elevation: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              MaterialCommunityIcons.pokeball,
                              size: 30,
                              color: Colors.black45,
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
                StreamBuilder<int>(
                  initialData: 0,
                  stream: _starBloc.pointStream,
                  builder: (context, snapshot) => Text(
                    '  ${snapshot.data} ',
                    style: TextStyle(
                      fontFamily: 'Alata',
                      fontSize: 16,
                    ),
                  ),
                ),
                Image.asset(
                  'assets/png/star.png',
                  height: 13,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                getTimeNow(),
                style: TextStyle(
                  fontFamily: 'Alata',
                  fontSize: 25,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF061058),
                ),
              ),
              Text(
                '${DateFormat.yMMMEd().format(DateTime.now())}',
                style: TextStyle(
                  fontFamily: 'Alata',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
            ],
          ),
        ],
      );

  String getTimeNow() {
    DateTime _now = DateTime.now();
    if (_now.hour <= 12) {
      return 'Good morning,';
    } else if (_now.hour <= 17) {
      return 'Good afternoon,';
    } else {
      return 'Good evening,';
    }
  }
}
