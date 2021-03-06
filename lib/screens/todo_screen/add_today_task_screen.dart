import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:gottask/bloc/do_del_done_todo_bloc.dart';
import 'package:gottask/bloc/today_task_bloc.dart';
import 'package:gottask/components/image_viewer.dart';
import 'package:gottask/constant.dart';
import 'package:gottask/events/do_del_done/update_dodeldone_todo_event.dart';
import 'package:gottask/events/today_task/add_today_task_event.dart';
import 'package:gottask/models/do_del_done_task.dart';
import 'package:gottask/models/today_task.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:path_provider/path_provider.dart';

class AddTodayTaskScreen extends StatefulWidget {
  final BuildContext ctx; //context screen trước
  const AddTodayTaskScreen({this.ctx});
  @override
  _AddTodayTaskScreenState createState() => _AddTodayTaskScreenState();
}

class _AddTodayTaskScreenState extends State<AddTodayTaskScreen>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation animation;
  Animation opacityAnimation;
  int indexColor = 0;

  final TextEditingController _todayTaskEditting = TextEditingController();
  bool isExpandCamera = false;
  bool _isRecording = false;
  bool isCreate = false;
  bool _haveRecord = false;
  bool _isInit = false;
  bool _isInitWidget = false;

  PlayerState _playerState = PlayerState.READY;
  List<File> imageFileList = [];
  List<String> images = [];
  List<bool> _catagoryItems = List.generate(9, (index) => false);

  String _audioPath = '';

  FlutterAudioRecorder _recorder;
  Recording _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;
  AudioPlayer audioPlayer = AudioPlayer();
  AudioCache audioCache;
  Duration _duration = const Duration();
  Duration _position = const Duration();

  TodayTaskBloc _todayTaskBloc;
  DoDelDoneTodoBloc _doDelDoneTodoBloc;

  Future _openGallery() async {
    File imageFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 100,
      maxWidth: 100,
    );
    if (imageFile != null) {
      images.add(imageFile.path);
      imageFileList.add(imageFile);
    }
  }

  Future _openCamera() async {
    File imageFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );
    if (imageFile != null) {
      images.add(imageFile.path);
      imageFileList.add(imageFile);
    }
  }

  Future<bool> _exist() async => await File('$_audioPath').exists();

  Future<void> _init() async {
    try {
      if (Platform.isIOS) {
        PermissionStatus permission = await PermissionHandler()
            .checkPermissionStatus(PermissionGroup.camera);
        if (permission.value == 0) {
          // Map<PermissionGroup, PermissionStatus> permissions =
          //     await PermissionHandler()
          //         .requestPermissions([PermissionGroup.camera]);
        }
      }

      if (await FlutterAudioRecorder.hasPermissions) {
        Directory appDocDirectory;
        if (Platform.isIOS) {
          appDocDirectory = await getApplicationDocumentsDirectory();
        } else {
          appDocDirectory = await getExternalStorageDirectory();
        }

        // can add extension like ".mp4" ".wav" ".m4a" ".aac"

        // .wav <---> AudioFormat.WAV
        // .mp4 .m4a .aac <---> AudioFormat.AAC
        // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.
        if (await _exist()) {
          final dir = Directory('$_audioPath');
          dir.deleteSync(recursive: true);
        }
        _audioPath = appDocDirectory.path +
            '/audio_' +
            '${DateTime.now().millisecondsSinceEpoch.toString()}.wav';
        _recorder =
            FlutterAudioRecorder(_audioPath, audioFormat: AudioFormat.WAV);

        await _recorder.initialized;
        // after initialization
        var current = await _recorder.current(channel: 0);

        setState(() {
          _current = current;
          _currentStatus = current.status;
        });
        _isInit = true;
      } else {
        Scaffold.of(context).showSnackBar(
          const SnackBar(
            content: const Text('You must accept permissions'),
          ),
        );
      }
    } catch (e) {
      print(e);
      _isInit = false;
    }
  }

  void initPlayer() {
    audioPlayer = AudioPlayer();
    audioCache = AudioCache(fixedPlayer: audioPlayer);

    audioPlayer.durationHandler = (d) => setState(() {
          _duration = d;
        });

    audioPlayer.positionHandler = (p) => setState(() {
          _position = p;
        });
    audioPlayer.completionHandler = () => setState(() {
          _position = _duration;
          _playerState = PlayerState.READY;
          audioPlayer.stop();
          _position = const Duration();
        });
  }

  Future _start() async {
    try {
      if (audioPlayer.state != AudioPlayerState.STOPPED) {
        await audioPlayer.stop();
      }
      if (await _exist() == true) {
        final dir = Directory('$_audioPath');
        dir.deleteSync(recursive: true);
      }
      _recorder.recording;
      await _recorder.start();
      var recording = await _recorder.current(channel: 0);
      setState(() {
        _current = recording;
        _isRecording = true;
        _playerState = PlayerState.READY;
      });

      const tick = const Duration(milliseconds: 50);
      Timer.periodic(tick, (Timer t) async {
        if (_currentStatus == RecordingStatus.Stopped) {
          t.cancel();
        }

        var current = await _recorder.current(channel: 0);
        try {
          setState(() {
            _current = current;
            _currentStatus = _current.status;
          });
        } catch (e) {
          var res = _recorder.recording;
          if (res.status != RecordingStatus.Stopped) {
            await _recorder.stop();
          }
        }
      });
    } catch (e) {
      print(e);
    }
  }

  Future _stop() async {
    _isInit = true;
    var result = await _recorder.stop();
    initPlayer();
    setState(() {
      _current = result;
      _currentStatus = _current.status;
      _audioPath = _current.path;
      _haveRecord = true;
      _isRecording = false;
      _playerState = PlayerState.READY;
      _position = const Duration();
    });
  }

  Future onPlayAudio() async {
    if (_isInit == false) {
      await _init();
    }
    if (_playerState == PlayerState.PAUSE) {
      await audioPlayer.resume();
    } else if (_playerState == PlayerState.READY) {
      await audioPlayer.play(_audioPath, isLocal: true);
    }
    setState(() {
      _playerState = PlayerState.PLAY;
    });
  }

  Future<void> onPauseAudio() async {
    await audioPlayer.pause();
    setState(() {
      _playerState = PlayerState.PAUSE;
    });
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 300),
    );
    animation = Tween<double>(begin: 0, end: 1).animate(animationController)
      ..addListener(() {
        setState(() {});
      });
    opacityAnimation =
        Tween<double>(begin: 1, end: 0).animate(animationController)
          ..addListener(() {
            setState(() {});
          });
    _init();
  }

  _deleteFile() {
    images.forEach((path) {
      final dir = Directory(path);
      dir.deleteSync(recursive: true);
    });
    if (_haveRecord) {
      final dir = Directory(_audioPath);
      dir.deleteSync(recursive: true);
    }
  }

  @override
  dispose() async {
    super.dispose();
    if (_playerState != PlayerState.READY) {
      await audioPlayer.stop();
    }
    if (_currentStatus == RecordingStatus.Recording) {
      await _recorder.stop();
      _haveRecord = true;
    }
    if (isCreate == false) {
      _deleteFile();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitWidget == false) {
      _todayTaskBloc = Provider.of<TodayTaskBloc>(widget.ctx);
      _doDelDoneTodoBloc = Provider.of<DoDelDoneTodoBloc>(widget.ctx);
      _isInitWidget = true;
    }

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      bottomNavigationBar: _buildAddTaskButton(_todayTaskBloc, context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildTaskNameTextField(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 10, top: 5),
                      child: Text(
                        'Color',
                        style: TextStyle(
                          fontFamily: 'Alata',
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    _buildColorPicker(),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, top: 5),
                      child: Text(
                        'Catagory',
                        style: TextStyle(
                          fontFamily: 'Alata',
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    _buildCatagoriesPicker(),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 5),
                  child: Text(
                    'File',
                    style: TextStyle(
                      fontFamily: 'Alata',
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            if (isExpandCamera == false) {
                              animationController.forward();
                              setState(() {
                                isExpandCamera = true;
                              });
                            } else {
                              animationController.reverse();
                              setState(() {
                                isExpandCamera = false;
                              });
                            }
                          },
                          child: _cameraButton(),
                        ),
                        isExpandCamera == true
                            ? GestureDetector(
                                onTap: () async {
                                  animationController.reverse();
                                  await _openCamera();
                                  setState(() {
                                    isExpandCamera = false;
                                  });
                                },
                                child: AnimatedOpacity(
                                  duration: animationController.duration,
                                  opacity: animation.value,
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 200),
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Color(
                                            int.parse(colors[indexColor])),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    child: Icon(
                                      SimpleLineIcons.camera,
                                      color:
                                          Color(int.parse(colors[indexColor])),
                                      size: 50,
                                    ),
                                  ),
                                ),
                              )
                            : Container(height: 0, width: 0),
                        isExpandCamera == true
                            ? GestureDetector(
                                onTap: () async {
                                  animationController.reverse();
                                  await _openGallery();
                                  setState(() {
                                    isExpandCamera = false;
                                  });
                                },
                                child: AnimatedOpacity(
                                  duration: animationController.duration,
                                  opacity: animation.value,
                                  child: Container(
                                    margin: const EdgeInsets.all(10),
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Color(
                                            int.parse(colors[indexColor])),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    child: Icon(
                                      SimpleLineIcons.picture,
                                      color:
                                          Color(int.parse(colors[indexColor])),
                                      size: 50,
                                    ),
                                  ),
                                ),
                              )
                            : Container(height: 0, width: 0),
                        imageFileList.isEmpty
                            ? isExpandCamera == true
                                ? Container()
                                : AnimatedOpacity(
                                    opacity: opacityAnimation.value,
                                    duration: animationController.duration,
                                    child: Text(
                                      'Empty',
                                      style: TextStyle(
                                        fontFamily: 'Alata',
                                        fontSize: 20,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  )
                            : isExpandCamera == true
                                ? Container()
                                : LimitedBox(
                                    maxHeight: 100,
                                    maxWidth:
                                        MediaQuery.of(context).size.width - 140,
                                    child: StreamBuilder<List<File>>(
                                      initialData: imageFileList,
                                      builder: (context, snapshot) =>
                                          _buildListImages(snapshot),
                                    ),
                                  ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            if (_isRecording == false) {
                              _start();
                            } else {
                              _stop();
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(
                                left: 10, right: 10, top: 10),
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Color(int.parse(colors[indexColor])),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: Icon(
                              _isRecording == false
                                  ? SimpleLineIcons.microphone
                                  : Icons.stop,
                              size: 50,
                              color: Color(int.parse(colors[indexColor])),
                            ),
                          ),
                        ),
                        _haveRecord
                            ? LimitedBox(
                                maxHeight: 100,
                                maxWidth:
                                    MediaQuery.of(context).size.width - 140,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    const SizedBox(height: 10),
                                    SliderTheme(
                                      data: SliderTheme.of(context).copyWith(
                                        activeTrackColor: Color(
                                            int.parse(colors[indexColor])),
                                        inactiveTrackColor: Colors.grey,
                                        trackHeight: 3,
                                        thumbColor: Color(
                                            int.parse(colors[indexColor])),
                                        thumbShape: const RoundSliderThumbShape(
                                          enabledThumbRadius: 4,
                                        ),
                                        overlayColor:
                                            Color(int.parse(colors[indexColor]))
                                                .withOpacity(0.3),
                                        overlayShape:
                                            const RoundSliderOverlayShape(
                                          overlayRadius: 4,
                                        ),
                                      ),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                150,
                                        child: Slider(
                                          value: _position.inMilliseconds
                                              .toDouble(),
                                          onChanged: (value) {},
                                          min: 0,
                                          max: _duration.inMilliseconds
                                              .toDouble(),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        InkWell(
                                          onTap: () {
                                            if (_isRecording == false) {
                                              if (_playerState ==
                                                  PlayerState.PLAY) {
                                                onPauseAudio();
                                              } else {
                                                if (_playerState ==
                                                        PlayerState.READY ||
                                                    _playerState ==
                                                        PlayerState.PAUSE) {
                                                  onPlayAudio();
                                                }
                                              }
                                            }
                                          },
                                          child: Icon(
                                            _playerState == PlayerState.PLAY
                                                ? Icons.pause
                                                : Icons.play_arrow,
                                            size: 30,
                                            color: Color(
                                                int.parse(colors[indexColor])),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            if (_isRecording == false) {
                                              if (_playerState ==
                                                      PlayerState.PLAY ||
                                                  _playerState ==
                                                      PlayerState.PAUSE) {
                                                audioPlayer.stop();
                                                final dir =
                                                    Directory('$_audioPath');
                                                dir.deleteSync(recursive: true);
                                              }
                                              _audioPath = '';

                                              setState(() {
                                                _duration = const Duration();
                                                _position = const Duration();
                                              });

                                              _init();
                                              setState(() {
                                                _haveRecord = false;
                                              });
                                            }
                                          },
                                          child: Icon(
                                            Icons.delete_outline,
                                            size: 30,
                                            color: Color(
                                                int.parse(colors[indexColor])),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            : Text(
                                'Empty',
                                style: TextStyle(
                                  fontFamily: 'Alata',
                                  fontSize: 20,
                                  color: Colors.grey,
                                ),
                              ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCatagoriesPicker() => Padding(
        padding: const EdgeInsets.only(
          top: 5,
        ),
        child: Wrap(
          children: List.generate(
            catagories.length,
            (index) => GestureDetector(
              onTap: () {
                setState(() {
                  _catagoryItems[index] = !_catagoryItems[index];
                });
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 100),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: _catagoryItems[index] == false
                        ? Color(
                            int.parse(
                              colors[indexColor],
                            ),
                          )
                        : Colors.white,
                  ),
                  color: _catagoryItems[index]
                      ? Color(
                          int.parse(
                            colors[indexColor],
                          ),
                        )
                      : Colors.white,
                ),
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(
                  bottom: 5,
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
                                  colors[indexColor],
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
                                    colors[indexColor],
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
      );

  Widget _buildColorPicker() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Wrap(
          direction: Axis.horizontal,
          children: List.generate(
            colors.length,
            (index) {
              if (indexColor == index) {
                return Container(
                  margin: const EdgeInsets.all(3),
                  height: (MediaQuery.of(context).size.width - 59) / 6,
                  width: (MediaQuery.of(context).size.width - 59) / 6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Color(
                      int.parse(colors[index]),
                    ),
                  ),
                  child: Icon(Icons.check, color: Colors.white),
                );
              }
              return GestureDetector(
                onTap: () {
                  setState(() {
                    indexColor = index;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.all(3),
                  height: (MediaQuery.of(context).size.width - 59) / 6,
                  width: (MediaQuery.of(context).size.width - 59) / 6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Color(
                      int.parse(colors[index]),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );

  ListView _buildListImages(AsyncSnapshot<List<File>> snapshot) =>
      ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: snapshot.data.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(right: 10),
          child: SizedBox(
            height: 100,
            width: 100,
            child: Stack(
              children: <Widget>[
                SizedBox(
                  height: 100,
                  width: 100,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ImageViewer(
                            color: Color(int.parse(colors[indexColor])),
                            imageLinkList: snapshot.data,
                            imageLinkIndex: index,
                          ),
                        ),
                      );
                    },
                    child: Image.file(
                      snapshot.data[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Align(
                    alignment: FractionalOffset.topRight,
                    child: GestureDetector(
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white38,
                        child: Icon(
                          Icons.close,
                          color: Colors.white.withOpacity(0.5),
                          size: 20,
                        ),
                      ),
                      onTap: () {
                        final dir = Directory(images[index]);
                        dir.deleteSync(recursive: true);
                        images.removeAt(index);
                        setState(() {
                          snapshot.data.removeAt(index);
                        });
                      },
                    ),
                  ),
                ),
                Container(),
              ],
            ),
          ),
        ),
      );

  Container _cameraButton() => Container(
        margin: const EdgeInsets.all(10),
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(
            color: Color(int.parse(colors[indexColor])),
            width: 1,
          ),
          color: Colors.white,
          borderRadius: BorderRadius.circular(3),
        ),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: FractionalOffset.center,
              child: AnimatedOpacity(
                duration: animationController.duration,
                opacity: animation.value,
                child: Icon(
                  Ionicons.ios_arrow_back,
                  size: 50,
                  color: Color(int.parse(colors[indexColor])),
                ),
              ),
            ),
            Align(
              alignment: FractionalOffset.center,
              child: AnimatedOpacity(
                duration: animationController.duration,
                opacity: opacityAnimation.value,
                child: Icon(
                  SimpleLineIcons.camera,
                  size: 50,
                  color: Color(int.parse(colors[indexColor])),
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildTaskNameTextField() => AnimatedContainer(
        duration: Duration(milliseconds: 100),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Color(int.parse(colors[indexColor])),
            width: 1,
          ),
        ),
        child: TextField(
          controller: _todayTaskEditting,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(10),
            labelText: 'To-do name',
            labelStyle: TextStyle(
              fontFamily: 'Alata',
              color: Colors.grey,
              fontSize: 16,
            ),
            focusColor: TodoColors.lightOrange,
            border: InputBorder.none,
          ),
        ),
      );

  Widget _buildAddTaskButton(
          TodayTaskBloc _todayTaskBloc, BuildContext context) =>
      GestureDetector(
        onTap: () async {
          if (_isRecording == false) {
            isCreate = true;
            int id = await saveTodayTaskID();
            _todayTaskBloc.event.add(
              AddTodayTaskEvent(
                todayTask: TodayTask(
                  content: _todayTaskEditting.text,
                  id: id,
                  images: images.toString(),
                  color: indexColor,
                  audioPath: _haveRecord ? _audioPath : '',
                  catagories: _catagoryItems.toString(),
                ),
              ),
            );

            int doTodo = await onDoingTask();
            int delTodo = await readDeleteTask();
            int doneTodo = await readDoneTask();
            _doDelDoneTodoBloc.event.add(
              UpdateDoDelDoneTodoEvent(
                doDelDoneTodo: DoDelDoneTodo(
                  id: 1,
                  doTodo: doTodo,
                  delTodo: delTodo,
                  doneTodo: doneTodo,
                ),
              ),
            );
            Navigator.pop(context);
          } else {
            await showWarning(context);
          }
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Ionicons.ios_add,
                  color: Colors.white,
                ),
                Text(
                  ' Add to-do',
                  style: TextStyle(
                    fontFamily: 'Alata',
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          color: Color(int.parse(colors[indexColor])),
        ),
      );

  Future showWarning(BuildContext context) => showDialog(
        context: context,
        child: Center(
          child: Container(
            height: 200,
            width: 400,
            decoration: BoxDecoration(
              color: TodoColors.scaffoldWhite,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 20),
                Text(
                  'Warning:',
                  style: TextStyle(
                    fontFamily: 'Alata',
                    fontSize: 30,
                    decorationStyle: TextDecorationStyle.double,
                    color: Colors.yellow[900],
                    decoration: TextDecoration.none,
                  ),
                ),
                Text(
                  'Do not go out if recording not done.',
                  style: TextStyle(
                    fontFamily: 'Alata',
                    fontSize: 20,
                    decorationStyle: TextDecorationStyle.double,
                    color: Colors.black,
                    decoration: TextDecoration.none,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(int.parse(colors[indexColor])),
                      ),
                      child: Center(
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontFamily: 'Alata',
                            fontSize: 30,
                            decorationStyle: TextDecorationStyle.double,
                            color: Colors.white,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
