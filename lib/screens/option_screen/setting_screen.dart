import 'package:flutter/material.dart';
import 'package:gottask/base/base_event.dart';
import 'package:gottask/bloc/handside_bloc.dart';
import 'package:gottask/constant.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatefulWidget {
  final BuildContext ctx;
  SettingScreen({this.ctx});
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation animation;
  Animation fadeAnimation;

  HandSide _handSide;
  HandsideBloc _handsideBloc;
  bool _isInit = false;

  List<bool> _leftOrRight;

  initHandSide() async {
    _handSide = await currentHandSide();
    _refreshLeftOrRight();
  }

  _refreshLeftOrRight() {
    setState(() {
      if (_handSide == HandSide.Left)
        _leftOrRight = [true, false];
      else if (_handSide == HandSide.Right) _leftOrRight = [false, true];
    });
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
      reverseDuration: Duration(milliseconds: 300),
    );
    animation = Tween<double>(begin: 0, end: 1).animate(animationController);
    fadeAnimation =
        Tween<double>(begin: 1, end: 0).animate(animationController);
  }

  @override
  Widget build(BuildContext context) {
    if (_isInit == false) {
      _handsideBloc = Provider.of<HandsideBloc>(widget.ctx);
      initHandSide();
      _isInit = true;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Setting',
          style: TextStyle(
            fontFamily: 'Montserrat',
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Handside control ',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  ToggleButtons(
                    isSelected:
                        _leftOrRight != null ? _leftOrRight : [false, false],
                    onPressed: (index) async {
                      if (index == 0) {
                        _handSide = HandSide.Left;
                        await updateHandSide(_handSide);
                        _refreshLeftOrRight();
                        _handsideBloc.event.add(BaseEvent());
                      } else {
                        _handSide = HandSide.Right;
                        await updateHandSide(_handSide);
                        _refreshLeftOrRight();
                        _handsideBloc.event.add(BaseEvent());
                      }
                    },
                    children: <Widget>[
                      Text('L'),
                      Text('R'),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
