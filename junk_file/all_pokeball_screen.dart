import 'package:flutter/material.dart';
import 'package:gottask/bloc/star_bloc.dart';
import 'package:gottask/constant.dart';
import 'package:swipedetector/swipedetector.dart';

class AllPokeballScreen extends StatefulWidget {
  final BuildContext ctx;
  AllPokeballScreen({this.ctx});
  @override
  _AllPokeballScreenState createState() => _AllPokeballScreenState();
}

class _AllPokeballScreenState extends State<AllPokeballScreen>
    with SingleTickerProviderStateMixin {
  int _currentPokeball = 0;
  AnimationController animationController;
  Animation curved;
  bool _isInit = false;
  int _currentStarPoint = 0;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
      reverseDuration: const Duration(milliseconds: 800),
    )..addListener(() {
        setState(() {});
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
    if (_isInit == false) {
      Future.delayed(Duration(milliseconds: 100), () {
        setState(() {});
      });
      _currentStarPoint = currentStarPoint;
      _isInit = true;
    }

    return SwipeDetector(
      onSwipeLeft: () => Navigator.pop(context),
      onSwipeRight: () => Navigator.pop(context),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Row(
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: ListWheelScrollView(
                    physics: BouncingScrollPhysics(),
                    offAxisFraction:
                        (MediaQuery.of(context).size.height > 600) ? 8 : 11.2,
                    onSelectedItemChanged: (value) {
                      setState(() {
                        _currentPokeball = value;
                      });
                    },
                    children: List.generate(
                      pokeballInfo.length,
                      (index) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: TodoColors.deepPurple,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: const EdgeInsets.only(
                            bottom: 5,
                            left: 5,
                            right: 5,
                          ),
                          padding: const EdgeInsets.all(5),
                          child: Image.asset(
                            pokeballImages[index],
                            height: MediaQuery.of(context).size.width / 4 - 10,
                          ),
                        );
                      },
                    ),
                    itemExtent: MediaQuery.of(context).size.width / 4,
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 50,
                          left: 50,
                          right: 50,
                        ),
                        child: Image.asset(
                          pokeballImages[_currentPokeball],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: pokeballInfo[_currentPokeball]
                                        ['name'],
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Colors.black,
                                      fontSize: 16,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' - ',
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Colors.black,
                                      fontSize: 20,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                  TextSpan(
                                    text: pokeballInfo[_currentPokeball]
                                        ['type'],
                                    style: TextStyle(
                                      fontFamily: 'Alata',
                                      color: Colors.black,
                                      fontSize: 16,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (_currentStarPoint >= 40) {
                                  
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 2,
                                      color: tagColor[
                                              pokeballInfo[_currentPokeball]
                                                  ['type']]
                                          .withOpacity(0.4),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        'Buy ',
                                        style: TextStyle(
                                          color: _currentStarPoint >= 40
                                              ? TodoColors.deepPurple
                                              : Colors.grey,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            '40 ',
                                            style: TextStyle(
                                              color: _currentStarPoint >= 40
                                                  ? TodoColors.deepPurple
                                                  : Colors.grey,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w300,
                                              decoration: TextDecoration.none,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          Image.asset(
                                            'assets/png/star.png',
                                            height: 12,
                                            color: _currentStarPoint >= 40
                                                ? null
                                                : Colors.black.withOpacity(0.3),
                                            colorBlendMode:
                                                _currentStarPoint >= 40
                                                    ? null
                                                    : BlendMode.modulate,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 10,
                          top: 10,
                          bottom: 10,
                        ),
                        child: Text(
                          '''   ${pokeballInfo[_currentPokeball]['name']} is discounted 10 stars of ${pokeballInfo[_currentPokeball]['type'].toLowerCase()} pokemon. ''',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Colors.black,
                            fontSize: 16,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
