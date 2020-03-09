import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter_incall/flutter_incall.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:gottask/bloc/do_del_done_habit_bloc.dart';
import 'package:gottask/bloc/habit_bloc.dart';
import 'package:gottask/bloc/star_bloc.dart';
import 'package:gottask/components/countdown_clock.dart';
import 'package:gottask/constant.dart';
import 'package:gottask/events/do_del_done/update_dodeldone_habit_event.dart';
import 'package:gottask/events/habit/delete_habit_event.dart';
import 'package:gottask/events/habit/update_habit_event.dart';
import 'package:gottask/events/star/add_star_event.dart';
import 'package:gottask/models/do_del_done_habit.dart';
import 'package:gottask/models/habit.dart';
import 'package:icons_helper/icons_helper.dart';
import 'package:provider/provider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:vibration/vibration.dart';

class HabitScreen extends StatefulWidget {
  final Habit habit;
  final BuildContext ctx;
  HabitScreen({this.habit, @required this.ctx});
  @override
  _HabitScreenState createState() => _HabitScreenState();
}

class _HabitScreenState extends State<HabitScreen> {
  List<String> _achievelists;
  Duration _timer;
  int _percent;
  int _iconIndex;
  int _maxTimer;
  bool _isInit = false;
  List<bool> _isDoneAchieve = [];
  List<bool> _catagoryItems = List.generate(9, (index) => false);

  CountdownClock countdownClock;
  TimerState _timerState = TimerState.PAUSE;

  HabitBloc _habitBloc;
  DoDelDoneHabitBloc _doDelDoneHabitBloc;
  StarBloc _starBloc;
  TextEditingController _achieveTextController = TextEditingController();

  FocusNode myFocusNode;
  IncallManager _incallManager = IncallManager();
  bool isProcess = true;
  AudioCache audioCache = AudioCache();
  AudioPlayer audioPlayer = AudioPlayer();

  InterstitialAd myInterstitial;

  InterstitialAd _interstitialAds() {
    return InterstitialAd(
      adUnitId: interstitialId,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("InterstitialAd event is $event");
        if (event == MobileAdEvent.closed) {
          Navigator.pop(context);
        }
      },
    );
  }

  _onBackPress() async {
    //Back and update data
    List<String> durTimer = widget.habit.timer.split(':');
    List<String> durTimerSecond = durTimer[2].split('.');
    if (_timerState == TimerState.PLAY)
      setState(() {
        _timerState = TimerState.PAUSE;
        countdownClock.onPause = true;
        countdownClock.isPlay = false;
      });
    var _oldTimer = Duration(
      hours: int.parse(durTimer[0]),
      minutes: int.parse(durTimer[1]),
      seconds: int.parse(durTimerSecond[0]),
    );
    Duration _completeTimer = _oldTimer - _timer;
    _habitBloc.event.add(
      UpdateHabitEvent(
        habit: Habit(
          achieve: _achievelists.toString(),
          color: widget.habit.color,
          catagories: _catagoryItems.toString(),
          completeTimer: _completeTimer.toString(),
          habitName: widget.habit.habitName,
          id: widget.habit.id,
          icon: _iconIndex,
          timer: widget.habit.timer,
          isDoneAchieve: _isDoneAchieve.toString(),
          percent: _percent,
        ),
      ),
    );
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        myInterstitial
          ..load()
          ..show();
      }
    } on SocketException catch (_) {
      Navigator.pop(context);
    }
  }

  IconData _getTimerState() {
    if (_timerState == TimerState.PAUSE)
      return Icons.play_arrow;
    else
      return Icons.pause;
  }

  Widget _widgetInCircle() {
    if (_timerState == TimerState.DONE) {
      return Text(
        'Done!',
        style: TextStyle(
          fontFamily: 'Alata',
          fontSize: 30,
          color: Color(int.parse(colors[widget.habit.color])),
        ),
      );
    } else {
      return Icon(
        _getTimerState(),
        color: Color(
          int.parse(
            colors[widget.habit.color],
          ),
        ),
        size: 50,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance.initialize(appId: appId);
    myInterstitial = _interstitialAds();

    myFocusNode = FocusNode();
    var _rawCatagoryItems = widget.habit.catagories
        .substring(1, widget.habit.catagories.length - 1)
        .split(', ');
    for (int i = 0; i < _rawCatagoryItems.length; i++) {
      if (_rawCatagoryItems[i] == 'false') {
        _catagoryItems[i] = false;
      } else {
        _catagoryItems[i] = true;
      }
    }

    String _rawList =
        widget.habit.achieve.substring(1, widget.habit.achieve.length - 1);
    _achievelists = _rawList.split(', ');
    if (_achievelists[0] == '') _achievelists = [];
    List<String> durTimer = widget.habit.timer.split(':');
    List<String> durCompleteTimer = widget.habit.completeTimer.split(':');
    List<String> durTimerSecond = durTimer[2].split('.');
    List<String> durCompleteTimerSecond = durCompleteTimer[2].split('.');
    _timer = Duration(
      hours: int.parse(durTimer[0]) - int.parse(durCompleteTimer[0]),
      minutes: int.parse(durTimer[1]) - int.parse(durCompleteTimer[1]),
      seconds:
          int.parse(durTimerSecond[0]) - int.parse(durCompleteTimerSecond[0]),
    );
    _maxTimer = int.parse(durTimer[0]) * 3600 +
        int.parse(durTimer[1]) * 60 +
        int.parse(
          durTimerSecond[0],
        );
    _percent = widget.habit.percent;
    _iconIndex = widget.habit.icon;
    if (_timer == Duration(hours: 0, minutes: 0, seconds: 0)) {
      _timerState = TimerState.DONE;
    }

    if (Platform.isAndroid && _timerState != TimerState.DONE) {
      _incallManager.enableProximitySensor(true);
      _incallManager.turnScreenOff();
      _incallManager.onProximity.stream.listen(
        (proximity) async {
          if (_timerState == TimerState.DONE) {
            _incallManager.turnScreenOn();
            if (audioPlayer.state == AudioPlayerState.PLAYING &&
                proximity == false) {
              await audioPlayer.stop();
            }
          } else {
            if (proximity == true) {
              if (isProcess == true) {
                if (await Vibration.hasVibrator()) {
                  Vibration.vibrate(
                    duration: 100,
                    amplitude: 2,
                  );
                }
                setState(() {
                  isProcess = false;
                  _timerState = TimerState.PLAY;
                  countdownClock.onPause = false;
                });
              }
            } else {
              if (isProcess == false) {
                if (await Vibration.hasVibrator()) {
                  Vibration.vibrate(
                    duration: 100,
                    amplitude: 200,
                  );
                }
                setState(() {
                  isProcess = true;
                  _timerState = TimerState.PAUSE;
                  countdownClock.onPause = true;
                  var _oldTimer = Duration(
                    hours: int.parse(durTimer[0]),
                    minutes: int.parse(durTimer[1]),
                    seconds: int.parse(durTimerSecond[0]),
                  );
                  Duration _completeTimer = _oldTimer - _timer;
                  _habitBloc.event.add(
                    UpdateHabitEvent(
                      habit: Habit(
                        achieve: _achievelists.toString(),
                        color: widget.habit.color,
                        catagories: _catagoryItems.toString(),
                        completeTimer: _completeTimer.toString(),
                        habitName: widget.habit.habitName,
                        id: widget.habit.id,
                        icon: _iconIndex,
                        timer: widget.habit.timer,
                        isDoneAchieve: _isDoneAchieve.toString(),
                        percent: _percent,
                      ),
                    ),
                  );
                });
                if (audioPlayer.state == AudioPlayerState.PLAYING) {
                  await audioPlayer.stop();
                }
              }
            }
          }
        },
      );
    }

    countdownClock = CountdownClock(
      duration: Duration(
        hours: _timer.inHours,
        minutes: _timer.inMinutes.remainder(60),
        seconds: _timer.inSeconds.remainder(60),
      ),
      onChanged: (duration) {
        _timer = duration;
        setState(() {
          _percent++;
        });
      },
      onDone: () async {
        audioPlayer = await audioCache.loop(
          audioFile['Caught_Pokemon'],
        );
        var maxTime = Duration(
          hours: int.parse(durTimer[0]),
          minutes: int.parse(durTimer[1]),
          seconds: int.parse(durTimerSecond[0]),
        );

        setState(() {
          _timerState = TimerState.DONE;
        });
        await saveHabitDone();
        int doTask = await onDoingHabit();
        int delTask = await readHabitGiveUp();
        int doneTask = await readHabitDone();
        _doDelDoneHabitBloc.event.add(
          UpdateDoDelDoneHabitEvent(
            doDelDoneHabit: DoDelDoneHabit(
              id: 1,
              doTask: doTask,
              delTask: delTask,
              doneTask: doneTask,
            ),
          ),
        );
        int pointGet = maxTime.inMinutes;
        _starBloc.event.add(
          AddStarEvent(
            point: pointGet,
          ),
        );
      },
      separator: ':',
      textStyle: TextStyle(
        fontFamily: 'ABeeZee',
        letterSpacing: 1,
        fontSize: 40,
      ),
    );
    String _superRawIsDoneAchieve = widget.habit.isDoneAchieve
        .substring(1, widget.habit.isDoneAchieve.length - 1);
    var _rawIsDoneAchieve = _superRawIsDoneAchieve.split(', ');
    if (_rawIsDoneAchieve[0] == '') {
      _isDoneAchieve = [];
    } else
      _rawIsDoneAchieve.forEach((element) {
        if (element == 'true')
          _isDoneAchieve.add(true);
        else
          _isDoneAchieve.add(false);
      });
  }

  @override
  void dispose() {
    super.dispose();
    myFocusNode.dispose();
    _incallManager.enableProximitySensor(false);
    _incallManager.turnScreenOn();
  }

  @override
  Widget build(BuildContext context) {
    if (_isInit == false) {
      _habitBloc = Provider.of<HabitBloc>(widget.ctx);
      _doDelDoneHabitBloc = Provider.of<DoDelDoneHabitBloc>(widget.ctx);
      _starBloc = Provider.of<StarBloc>(widget.ctx);
      _isInit = true;
    }

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(
          'Doing task',
          style: TextStyle(
            fontFamily: 'Montserrat',
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(int.parse(colors[widget.habit.color])),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            _onBackPress();
          },
        ),
        actions: <Widget>[
          _timerState != TimerState.DONE
              ? IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    await _buildDeleteCheckDialog(context);
                  },
                )
              : IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () async {
                    _habitBloc.event.add(
                      DeleteHabitEvent(
                        habit: widget.habit,
                      ),
                    );
                    Navigator.pop(context);
                  },
                ),
          IconButton(
            icon: Icon(getIconUsingPrefix(name: icons[_iconIndex])),
            onPressed: () {
              _buildIconPicker(context);
            },
          ),
        ],
      ),
      body: WillPopScope(
        onWillPop: () {
          _onBackPress();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              flex: 5,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 15),
                  Text(
                    '${widget.habit.habitName}',
                    style: TextStyle(
                      fontFamily: 'Alata',
                      fontSize: MediaQuery.of(context).size.width / 25,
                    ),
                  ),
                  countdownClock,
                  SizedBox(height: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SleekCircularSlider(
                        appearance: CircularSliderAppearance(
                          animationEnabled: true,
                          angleRange: 360,
                          startAngle: 270,
                          customWidths: CustomSliderWidths(
                            progressBarWidth: 8,
                            handlerSize: 0,
                            shadowWidth: 0,
                          ),
                          customColors: CustomSliderColors(
                            dotColor:
                                Color(int.parse(colors[widget.habit.color])),
                            progressBarColor:
                                Color(int.parse(colors[widget.habit.color])),
                            trackColor: Colors.white,
                          ),
                          size: (MediaQuery.of(context).size.height - 24) / 3.5,
                        ),
                        initialValue: _percent.toDouble(),
                        min: 0,
                        max: _maxTimer.toDouble(),
                        innerWidget: (percentage) {
                          return Center(
                            child: GestureDetector(
                              onTap: () {
                                if (Platform.isIOS) {
                                  setState(() {
                                    if (_timerState == TimerState.PLAY) {
                                      _timerState = TimerState.PAUSE;
                                      countdownClock.onPause =
                                          !countdownClock.onPause;
                                    } else if (_timerState ==
                                        TimerState.PAUSE) {
                                      _timerState = TimerState.PLAY;
                                      countdownClock.onPause =
                                          !countdownClock.onPause;
                                    }
                                  });
                                }
                              },
                              child: Container(
                                width:
                                    (MediaQuery.of(context).size.height - 24) /
                                            3.5 -
                                        20,
                                height:
                                    (MediaQuery.of(context).size.height - 24) /
                                            3.5 -
                                        20,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(160),
                                  color: Colors.white,
                                ),
                                child: Center(
                                  child: _widgetInCircle(),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  if (_achievelists.length != 0)
                    Flexible(
                      flex: 2,
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: _achievelists.length + 1,
                        itemBuilder: (context, index) {
                          if (index < _achievelists.length)
                            return _buildAchieveTile(index);
                          else {
                            return _buildAddAchieve();
                          }
                        },
                      ),
                    ),
                ],
              ),
            ),
            _buildCatagories(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCatagories(BuildContext context) {
    return Column(
      children: <Widget>[
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Row(
              children: List.generate(
                _catagoryItems.length,
                (index) => GestureDetector(
                  onTap: () {
                    setState(() {
                      _catagoryItems[index] = !_catagoryItems[index];
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: _catagoryItems[index] == false
                            ? Color(
                                int.parse(
                                  colors[widget.habit.color],
                                ),
                              )
                            : Colors.white,
                      ),
                      color: _catagoryItems[index]
                          ? Color(
                              int.parse(
                                colors[widget.habit.color],
                              ),
                            )
                          : Colors.white,
                    ),
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.only(
                      right: 5,
                    ),
                    child: FittedBox(
                      child: Row(
                        children: <Widget>[
                          Icon(
                            catagoryIcons[index],
                            size: 15,
                            color: _catagoryItems[index] == false
                                ? Color(
                                    int.parse(
                                      colors[widget.habit.color],
                                    ),
                                  )
                                : Colors.white,
                          ),
                          Text(
                            ' ${catagories[index]}',
                            style: TextStyle(
                              color: _catagoryItems[index] == false
                                  ? Color(
                                      int.parse(
                                        colors[widget.habit.color],
                                      ),
                                    )
                                  : Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Center(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Color(int.parse(colors[widget.habit.color])),
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      focusNode: myFocusNode,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        labelText: 'Achieve goal',
                        labelStyle: TextStyle(
                          fontFamily: 'Alata',
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                        border: InputBorder.none,
                      ),
                      controller: _achieveTextController,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (_achieveTextController.text != '' &&
                        _achieveTextController != null) {
                      FocusScope.of(context).requestFocus(FocusNode());
                      setState(() {
                        _achievelists.add(_achieveTextController.text
                            .replaceAll(RegExp(r','), ' '));
                        _isDoneAchieve.add(false);
                        _achieveTextController.clear();
                      });
                    }
                  },
                  child: Material(
                    elevation: 1,
                    color: Color(int.parse(colors[widget.habit.color])),
                    borderRadius: BorderRadiusDirectional.circular(10),
                    child: Container(
                      height: 40,
                      width: 40,
                      child: Icon(
                        Ionicons.ios_add,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _buildDeleteCheckDialog(BuildContext context) async {
    showDialog(
      context: context,
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              color: TodoColors.scaffoldWhite,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 5),
                Text(
                  'Warning:',
                  style: TextStyle(
                    fontFamily: 'Alata',
                    fontSize: 20,
                    color: Colors.yellow[900],
                    decoration: TextDecoration.none,
                  ),
                ),
                Text(
                  'Are you sure?',
                  style: TextStyle(
                    fontFamily: 'Alata',
                    fontSize: 30,
                    fontWeight: FontWeight.w300,
                    color: Colors.black,
                    decoration: TextDecoration.none,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: (MediaQuery.of(context).size.width - 80) / 2,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(int.parse(colors[widget.habit.color])),
                          ),
                          child: Center(
                            child: Text(
                              'Cancel',
                              style:
                                  TextStyle(fontFamily: 'Alata', fontSize: 16)
                                      .copyWith(
                                decorationStyle: TextDecorationStyle.double,
                                color: Colors.white,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await saveHabitGiveUp();
                          _habitBloc.event.add(
                            DeleteHabitEvent(
                              habit: widget.habit,
                            ),
                          );
                          int doTask = await onDoingHabit();
                          int delTask = await readHabitGiveUp();
                          int doneTask = await readHabitDone();
                          _doDelDoneHabitBloc.event.add(
                            UpdateDoDelDoneHabitEvent(
                              doDelDoneHabit: DoDelDoneHabit(
                                id: 1,
                                doTask: doTask,
                                delTask: delTask,
                                doneTask: doneTask,
                              ),
                            ),
                          );
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: (MediaQuery.of(context).size.width - 80) / 2,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(int.parse(colors[widget.habit.color])),
                          ),
                          child: Center(
                            child: Text(
                              'Give up',
                              style:
                                  TextStyle(fontFamily: 'Alata', fontSize: 16)
                                      .copyWith(
                                decorationStyle: TextDecorationStyle.double,
                                color: Colors.white,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAchieveTile(int index) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.5,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Material(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(15),
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
              color: Color(int.parse(colors[widget.habit.color])),
              elevation: 5,
              shadowColor:
                  Color(int.parse(colors[widget.habit.color])).withOpacity(0.3),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Text(
                    _achievelists[_achievelists.length - index - 1],
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      fontFamily: 'Alata',
                      fontSize: 16,
                      decoration:
                          _isDoneAchieve[_achievelists.length - index - 1] ==
                                  false
                              ? TextDecoration.none
                              : TextDecoration.lineThrough,
                      color: Colors.white,
                      wordSpacing: 0.02,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Icon(
            AntDesign.pushpin,
            color: Colors.red.shade900,
            size: 20,
          ),
          Align(
            alignment: FractionalOffset.bottomRight,
            child: IconButton(
              autofocus: false,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon: Icon(
                _isDoneAchieve[_achievelists.length - index - 1]
                    ? AntDesign.checkcircle
                    : AntDesign.checkcircleo,
                color: Colors.white,
                size: 15,
              ),
              onPressed: () {
                setState(() {
                  _isDoneAchieve[_achievelists.length - index - 1] =
                      !_isDoneAchieve[_achievelists.length - index - 1];
                });
              },
            ),
          ),
          Align(
            alignment: FractionalOffset.bottomLeft,
            child: IconButton(
              autofocus: false,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon: Icon(
                AntDesign.delete,
                color: Colors.white,
                size: 15,
              ),
              onPressed: () {
                setState(() {
                  _isDoneAchieve.removeAt(_achievelists.length - index - 1);
                  _achievelists.removeAt(_achievelists.length - index - 1);
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Future _buildIconPicker(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: TodoColors.scaffoldWhite,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          height: 200,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(
                  'Icon',
                  style: TextStyle(fontFamily: 'Alata', fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                Divider(),
                Wrap(
                  direction: Axis.horizontal,
                  children: List.generate(
                    icons.length,
                    (index) {
                      return Padding(
                        padding: EdgeInsets.all(5),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _iconIndex = index;
                              Navigator.pop(context);
                            });
                          },
                          child: Material(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                getIconUsingPrefix(
                                  name: icons[index],
                                ),
                                color: Colors.white,
                              ),
                            ),
                            color: Color(int.parse(colors[widget.habit.color])),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Container _buildAddAchieve() {
    return Container(
      width: MediaQuery.of(context).size.width / 1.5,
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1.5,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(15),
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
      child: Center(
        child: IconButton(
          iconSize: 60,
          icon: Icon(
            Icons.add,
            color: Colors.grey,
          ),
          onPressed: () => FocusScope.of(context).requestFocus(myFocusNode),
        ),
      ),
    );
  }
}
