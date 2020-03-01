import 'package:flutter/material.dart';
import 'package:gottask/constant.dart';
import 'package:swipedetector/swipedetector.dart';

class PokeBallInfoScreen extends StatefulWidget {
  final String imageTag;
  final int index;
  const PokeBallInfoScreen({this.imageTag, this.index});

  @override
  _PokeBallInfoScreenState createState() => _PokeBallInfoScreenState();
}

class _PokeBallInfoScreenState extends State<PokeBallInfoScreen>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation curved;
  bool _isReverse = false;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
      reverseDuration: const Duration(milliseconds: 800),
    )..addListener(() {
        setState(() {
        });
      });
    curved = CurvedAnimation(
      curve: Curves.easeInOutQuart,
      parent: animationController,
      reverseCurve: Curves.easeOutSine,
    );

    animationController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SwipeDetector(
      onSwipeRight: () {
        Navigator.pop(context);
      },
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            SafeArea(
              child: Align(
                alignment: FractionalOffset.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    pokedex[widget.index]['name'],
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Alata',
                      fontSize: 40,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Transform.scale(
                scale: _isReverse
                    ? 1.7 + (1 - curved.value) * 0.3
                    : curved.value * 1.7,
                child: GestureDetector(
                  onLongPress: () {
                    _isReverse = true;
                    animationController.reverse();
                  },
                  onLongPressUp: () => animationController.forward(),
                  child: Image.asset(
                    widget.imageTag,
                    height: 150,
                  ),
                ),
              ),
            ),
            Align(
              alignment: FractionalOffset.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  pokedex[widget.index]['description'],
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Alata',
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                    decoration: TextDecoration.none,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
