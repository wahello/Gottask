import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:gottask/bloc/current_pokemon_bloc.dart';
import 'package:gottask/bloc/pokemon_bloc.dart';
import 'package:gottask/bloc/star_bloc.dart';
import 'package:gottask/components/pet_tag.dart';
import 'package:gottask/constant.dart';
import 'package:gottask/events/current_pokemon/update_favourite_pokemon_event.dart';
import 'package:gottask/events/pokemon_state/update_pokemon_state_event.dart';
import 'package:gottask/events/star/buy_item_event.dart';
import 'package:gottask/models/pokemon_state.dart';
import 'package:provider/provider.dart';
import 'package:swipedetector/swipedetector.dart';

class PokemonInfoScreen extends StatefulWidget {
  final BuildContext allPokemonScreenContext;
  final int index;
  final String imageTag;
  final BuildContext ctx;
  const PokemonInfoScreen({
    this.imageTag,
    this.index,
    this.ctx,
    this.allPokemonScreenContext,
  });
  @override
  _PokemonInfoScreenState createState() => _PokemonInfoScreenState();
}

class _PokemonInfoScreenState extends State<PokemonInfoScreen> {
  PokemonStateBloc _pokemonStateBloc;
  StarBloc _starBloc;
  CurrentPokemonBloc _currentPokemonBloc;

  List<PokemonState> _pokemonStateList = [];
  int _currentStarPoint = 0;
  int _currentPokemon = 0;
  bool _isInit = false;

  @override
  Widget build(BuildContext context) {
    if (_isInit == false) {
      _pokemonStateBloc = Provider.of<PokemonStateBloc>(widget.ctx);
      _starBloc = Provider.of<StarBloc>(widget.ctx);
      _currentPokemonBloc = Provider.of<CurrentPokemonBloc>(widget.ctx);
      _pokemonStateList = pokemonStateList;
      _currentStarPoint = currentStarPoint;
      _currentPokemon = currentPokemon;
      _isInit = true;
    }

    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: SwipeDetector(
        onSwipeRight: () {
          Navigator.pop(context);
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                child: Stack(
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 3.25,
                      child: CustomPaint(
                        child: Container(
                          height: MediaQuery.of(context).size.height / 3.25,
                        ),
                        painter: HeaderPainter(
                          mainTag: pokedex[widget.index]['type'][0],
                          subTag: pokedex[widget.index]['type'].length > 1
                              ? pokedex[widget.index]['type'][1]
                              : null,
                        ),
                      ),
                    ),
                    Positioned(
                      left: MediaQuery.of(context).size.width * 0.05,
                      top: MediaQuery.of(context).size.height * 0.08,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Material(
                              borderRadius: BorderRadius.circular(100),
                              elevation: 20,
                              child: Container(
                                height: MediaQuery.of(context).size.height / 8,
                                width: MediaQuery.of(context).size.height / 8,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                    color: Colors.deepPurple,
                                    width: 2,
                                  ),
                                  color: Colors.white,
                                ),
                                child: Center(
                                  child: Image.asset(
                                    widget.imageTag,
                                    height:
                                        MediaQuery.of(context).size.height / 8 -
                                            25,
                                    width:
                                        MediaQuery.of(context).size.height / 8 -
                                            25,
                                    color:
                                        _pokemonStateList[widget.index].state ==
                                                0
                                            ? Colors.black.withOpacity(0.5)
                                            : null,
                                    colorBlendMode:
                                        _pokemonStateList[widget.index].state ==
                                                0
                                            ? BlendMode.modulate
                                            : null,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              pokedex[widget.index]['name'],
                              style: TextStyle(
                                fontFamily: 'Alata',
                                color: Colors.white,
                                fontSize:
                                    _pokemonStateList[widget.index].state == 0
                                        ? 25
                                        : 25,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            _pokemonStateList[widget.index].state == 1
                                ? Container(
                                    child: _currentPokemon != widget.index
                                        ? GestureDetector(
                                            onTap: () {
                                              _currentPokemonBloc.event.add(
                                                UpdateFavouritePokemonEvent(
                                                  newPokemon: widget.index,
                                                ),
                                              );
                                              setState(() {
                                                _currentPokemon = widget.index;
                                              });
                                            },
                                            child: Icon(
                                              AntDesign.hearto,
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                          )
                                        : GestureDetector(
                                            onTap: () {
                                              _currentPokemonBloc.event.add(
                                                UpdateFavouritePokemonEvent(
                                                  newPokemon: -1,
                                                ),
                                              );
                                              setState(() {
                                                _currentPokemon = -1;
                                              });
                                            },
                                            child: Icon(
                                              AntDesign.heart,
                                              color: Colors.redAccent,
                                              size: 30,
                                            ),
                                          ),
                                  )
                                : GestureDetector(
                                    onTap: () async {
                                      int cS = await currentStar();
                                      if (cS >= 60) {
                                        _showBuyCheckDialog(context);
                                      }
                                    },
                                    child: Material(
                                      elevation: 10,
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          children: <Widget>[
                                            Text(
                                              'Unlock ',
                                              style: TextStyle(
                                                color: _currentStarPoint >= 60
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
                                                  '60 ',
                                                  style: TextStyle(
                                                    color: _currentStarPoint >=
                                                            60
                                                        ? TodoColors.deepPurple
                                                        : Colors.grey,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w300,
                                                    decoration:
                                                        TextDecoration.none,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                Image.asset(
                                                  'assets/png/star.png',
                                                  height: 12,
                                                  color: _currentStarPoint >= 60
                                                      ? null
                                                      : Colors.black
                                                          .withOpacity(0.3),
                                                  colorBlendMode:
                                                      _currentStarPoint >= 60
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
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.24,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Text(
                                  'Height',
                                  style: TextStyle(
                                    fontFamily: 'Alata',
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize:
                                        MediaQuery.of(context).size.width / 20,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                                Text(
                                  pokedex[widget.index]['height'],
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize:
                                        MediaQuery.of(context).size.width / 25,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Text(
                                  'Weight',
                                  style: TextStyle(
                                    fontFamily: 'Alata',
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize:
                                        MediaQuery.of(context).size.width / 20,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                                Text(
                                  pokedex[widget.index]['weight'],
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize:
                                        MediaQuery.of(context).size.width / 25,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Text(
                                  'Category',
                                  style: TextStyle(
                                    fontFamily: 'Alata',
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize:
                                        MediaQuery.of(context).size.width / 20,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                                Text(
                                  pokedex[widget.index]['category'],
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize:
                                        MediaQuery.of(context).size.width / 25,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      'Type',
                      style: TextStyle(
                        fontFamily: 'Alata',
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                    ),
                    child: Wrap(
                      direction: Axis.horizontal,
                      children: List.generate(
                        pokedex[widget.index]['type'].length,
                        (index) => PetTag(
                          nameTag: pokedex[widget.index]['type'][index],
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width / 25,
                            fontFamily: 'Alata',
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      'Weaknesses',
                      style: TextStyle(
                        fontFamily: 'Alata',
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                    ),
                    child: Wrap(
                      direction: Axis.horizontal,
                      children: List.generate(
                        pokedex[widget.index]['weaknesses'].length,
                        (index) => PetTag(
                          nameTag: pokedex[widget.index]['weaknesses'][index],
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width / 25,
                            fontFamily: 'Alata',
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  'Introduction',
                  style: TextStyle(
                    fontFamily: 'Alata',
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  bottom: 10,
                ),
                child: Text(
                  pokedex[widget.index]['introduction'],
                  style: TextStyle(
                    fontFamily: 'Monsterrat',
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future _showBuyCheckDialog(BuildContext context) {
    return showDialog(
      context: context,
      child: Padding(
        padding: const EdgeInsets.all(20),
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
                  'Are you sure?',
                  style: TextStyle(
                    fontFamily: 'Alata',
                    fontSize: 25,
                    color: Colors.black,
                    fontWeight: FontWeight.w200,
                    decoration: TextDecoration.none,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
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
                          width: 260 / 2,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: tagColor[pokedex[widget.index]['type'][0]],
                          ),
                          child: Center(
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontFamily: 'Alata',
                                fontSize: 20,
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
                          await AudioCache().play(audioFile['Level_Up']);
                          _starBloc.event.add(
                            BuyItemEvent(
                              point: 60,
                            ),
                          );
                          _pokemonStateBloc.event.add(
                            UpdatePokemonStateEvent(
                              pokemonState: PokemonState(
                                name: pokedex[widget.index]['name'],
                                state: 1,
                              ),
                            ),
                          );
                          setState(() {
                            _pokemonStateList[widget.index].state = 1;
                          });
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 260 / 2,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: tagColor[pokedex[widget.index]['type'][0]],
                          ),
                          child: Center(
                            child: Text(
                              'Buy',
                              style: TextStyle(
                                fontFamily: 'Alata',
                                fontSize: 20,
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
}

class HeaderPainter extends CustomPainter {
  final String mainTag;
  final String subTag;
  HeaderPainter({this.mainTag, this.subTag});
  Color colorOne = const Color(0xFFFEDCBA);
  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    Paint paint = Paint();

    path.lineTo(0, size.height * 1.175);
    path.lineTo(size.width / 1.3, size.height * 1.33);
    path.relativeQuadraticBezierTo(15, 3, 30, -3);
    path.lineTo(size.width, size.height * 1.175);
    path.lineTo(size.width, 0);
    path.close();
    paint.color = colorOne.withOpacity(0.6);
    canvas.drawPath(path, paint);
    canvas.drawShadow(path, Colors.black38, 10, true);

    path = Path();
    paint = Paint();

    path.lineTo(0, size.height * 1.155);
    path.lineTo(size.width / 1.3, size.height * 1.31);
    path.relativeQuadraticBezierTo(15, 3, 30, -3);
    path.lineTo(size.width, size.height * 1.155);
    path.lineTo(size.width, 0);
    path.close();
    subTag != null
        ? paint.color = tagColor[subTag].withOpacity(0.4)
        : paint.color = Colors.yellow.withOpacity(0.4);
    canvas.drawPath(path, paint);

    path = Path();
    paint = Paint();

    path.lineTo(0, size.height * 1.145);
    path.lineTo(size.width / 1.3, size.height * 1.295);
    path.relativeQuadraticBezierTo(15, 3, 30, -3);
    path.lineTo(size.width, size.height * 1.145);
    path.lineTo(size.width, 0);
    path.close();
    paint.color = tagColor[mainTag].withOpacity(0.9);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => oldDelegate != this;
}
