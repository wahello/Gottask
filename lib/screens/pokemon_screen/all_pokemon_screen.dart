import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:gottask/bloc/all_pokemon_bloc.dart';
import 'package:gottask/bloc/current_pokemon_bloc.dart';
import 'package:gottask/bloc/handside_bloc.dart';
import 'package:gottask/bloc/pokemon_bloc.dart';
import 'package:gottask/bloc/star_bloc.dart';
import 'package:gottask/components/pet_tag_custom.dart';
import 'package:gottask/constant.dart';
import 'package:gottask/events/current_pokemon/update_favourite_pokemon_event.dart';
import 'package:gottask/events/pokemon_state/update_pokemon_state_event.dart';
import 'package:gottask/events/star/buy_item_event.dart';
import 'package:gottask/models/pokemon_state.dart';
import 'package:gottask/screens/option_screen/about_me_screen.dart';
import 'package:gottask/screens/option_screen/setting_screen.dart';
import 'package:provider/provider.dart';
import 'package:swipedetector/swipedetector.dart';

class AllPokemonScreen extends StatefulWidget {
  final BuildContext ctx;
  final int currentPokemon;
  AllPokemonScreen({
    this.ctx,
    this.currentPokemon,
  });
  @override
  _AllPokemonScreenState createState() => _AllPokemonScreenState();
}

class _AllPokemonScreenState extends State<AllPokemonScreen>
    with AfterLayoutMixin<AllPokemonScreen> {
  int _currentPokemon = 0;
  int _currentStarPoint = 0;
  int _favouritePokemon = 0;
  bool _isInit = false;
  ScrollController _scrollController = FixedExtentScrollController();
  HandSide _currentHandside;

  AllPokemonBloc _allPokemonBloc;
  StarBloc _starBloc;
  PokemonStateBloc _pokemonStateBloc;
  CurrentPokemonBloc _currentPokemonBloc;
  HandsideBloc _handsideBloc;

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
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color:
                                tagColor[pokedex[_currentPokemon]['type'][0]],
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
                                name: pokedex[_currentPokemon]['name'],
                                state: 1,
                              ),
                            ),
                          );
                          _allPokemonBloc.event.add(
                            UpdatePokemonStateEvent(
                              pokemonState: PokemonState(
                                name: pokedex[_currentPokemon]['name'],
                                state: 1,
                              ),
                            ),
                          );
                          _currentStarPoint -= 60;
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: (MediaQuery.of(context).size.width - 80) / 2,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color:
                                tagColor[pokedex[_currentPokemon]['type'][0]],
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

  getCurrentHandside() async {
    _currentHandside = await currentHandSide();
  }

  @override
  void initState() {
    super.initState();
    _currentPokemon = widget.currentPokemon;
  }

  @override
  void afterFirstLayout(BuildContext context) {
    Future.delayed(
      Duration(milliseconds: 100),
      () {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(
            MediaQuery.of(context).size.width / 4 * _currentPokemon,
          );
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _allPokemonBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isInit == false) {
      _allPokemonBloc = Provider.of<AllPokemonBloc>(context);
      _starBloc = Provider.of<StarBloc>(widget.ctx);
      _pokemonStateBloc = Provider.of<PokemonStateBloc>(widget.ctx);
      _currentPokemonBloc = Provider.of<CurrentPokemonBloc>(widget.ctx);
      _handsideBloc = Provider.of<HandsideBloc>(context);

      _allPokemonBloc.initAllPokemonBloc();
      _handsideBloc.initHandsideBloc();
      getCurrentHandside();
      _currentStarPoint = currentStarPoint;
      _favouritePokemon = currentPokemon;
      _isInit = true;
    }

    return StreamBuilder<HandSide>(
      stream: _handsideBloc.handsideStream,
      builder: (context, snapshot) => LayoutBuilder(
        builder: (context, constraints) {
          if (!snapshot.hasData) {
            return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
            );
          }
          if (_currentHandside != null) {
            if (_currentHandside != snapshot.data) {
              Future.delayed(
                Duration(milliseconds: 100),
                () {
                  setState(() {});
                  if (_scrollController.hasClients) {
                    _scrollController.jumpTo(
                      MediaQuery.of(context).size.width / 4 * _currentPokemon,
                    );
                  }
                },
              );
              _currentHandside = snapshot.data;
            }
          }
          if (snapshot.data == HandSide.Left) {
            return SwipeDetector(
              onSwipeRight: () => Navigator.pop(context),
              onSwipeLeft: () => Navigator.pop(context),
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: CustomPaint(
                  painter: HeaderPainterLeftHand(
                    ctx: widget.ctx,
                    type1: tagColor[pokedex[_currentPokemon]['type'][0]],
                  ),
                  child: StreamBuilder<List<PokemonState>>(
                    stream: _allPokemonBloc.listPokemonStateStream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return Container();
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Flexible(
                            flex: 1,
                            child: Stack(
                              children: <Widget>[
                                ListWheelScrollView(
                                  controller: _scrollController,
                                  physics: BouncingScrollPhysics(),
                                  offAxisFraction:
                                      (MediaQuery.of(context).size.height > 600)
                                          ? 6
                                          : 13,
                                  onSelectedItemChanged: (value) {
                                    setState(() {
                                      _currentPokemon = value;
                                    });
                                  },
                                  children: List.generate(
                                    pokedex.length,
                                    (index) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: TodoColors.deepPurple,
                                            width: 2,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        margin: const EdgeInsets.only(
                                          bottom: 5,
                                          left: 5,
                                          right: 5,
                                        ),
                                        padding: const EdgeInsets.all(5),
                                        child: Stack(
                                          children: <Widget>[
                                            Image.asset(
                                              pokemonImages[index],
                                              height: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      4 -
                                                  10,
                                              color:
                                                  snapshot.data[index].state ==
                                                          0
                                                      ? Colors.black54
                                                      : null,
                                              colorBlendMode:
                                                  snapshot.data[index].state ==
                                                          0
                                                      ? BlendMode.modulate
                                                      : null,
                                            ),
                                            if (snapshot.data[index].state == 0)
                                              Align(
                                                alignment:
                                                    FractionalOffset.center,
                                                child: Icon(
                                                  AntDesign.question,
                                                  size: 30,
                                                  color: Colors.white,
                                                ),
                                              ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  itemExtent:
                                      MediaQuery.of(context).size.width / 4,
                                ),
                                SafeArea(
                                  child: Align(
                                    alignment: FractionalOffset.bottomLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 15,
                                        vertical: 20,
                                      ),
                                      child: GestureDetector(
                                        child: Icon(
                                          Icons.settings,
                                          color: Colors.black45,
                                          size: 30,
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => SettingScreen(
                                                ctx: context,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            flex: 3,
                            child: Stack(
                              children: <Widget>[
                                SingleChildScrollView(
                                  physics: BouncingScrollPhysics(),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                5,
                                      ),
                                      Center(
                                        child: Image.asset(
                                          pokemonImages[_currentPokemon],
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              4,
                                          color: snapshot.data[_currentPokemon]
                                                      .state ==
                                                  0
                                              ? Colors.black45
                                              : null,
                                          colorBlendMode: snapshot
                                                      .data[_currentPokemon]
                                                      .state ==
                                                  0
                                              ? BlendMode.modulate
                                              : null,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 20,
                                          left: 14,
                                          right: 14,
                                        ),
                                        child: SizedBox(
                                          height: 56,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                pokedex[_currentPokemon]
                                                    ['name'],
                                                style: TextStyle(
                                                  fontFamily: 'Alata',
                                                  color: Colors.black,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                                  .size
                                                                  .width >
                                                              600
                                                          ? 35
                                                          : 26,
                                                  decoration:
                                                      TextDecoration.none,
                                                ),
                                              ),
                                              snapshot.data[_currentPokemon]
                                                          .state ==
                                                      1
                                                  ? _buildFavouriteButton()
                                                  : GestureDetector(
                                                      onTap: () async {
                                                        int cS =
                                                            await currentStar();
                                                        if (cS >= 60) {
                                                          print(MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width);
                                                          _showBuyCheckDialog(
                                                              context);
                                                        }
                                                      },
                                                      child: Material(
                                                        elevation: 4,
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10),
                                                          child: Column(
                                                            children: <Widget>[
                                                              Text(
                                                                'Unlock ',
                                                                style:
                                                                    TextStyle(
                                                                  color: _currentStarPoint >=
                                                                          60
                                                                      ? TodoColors
                                                                          .deepPurple
                                                                      : Colors
                                                                          .grey,
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  decoration:
                                                                      TextDecoration
                                                                          .none,
                                                                ),
                                                              ),
                                                              Row(
                                                                children: <
                                                                    Widget>[
                                                                  Text(
                                                                    '60 ',
                                                                    style:
                                                                        TextStyle(
                                                                      color: _currentStarPoint >=
                                                                              60
                                                                          ? TodoColors
                                                                              .deepPurple
                                                                          : Colors
                                                                              .grey,
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300,
                                                                      decoration:
                                                                          TextDecoration
                                                                              .none,
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  ),
                                                                  Image.asset(
                                                                    'assets/png/star.png',
                                                                    height: 12,
                                                                    color: _currentStarPoint >=
                                                                            60
                                                                        ? null
                                                                        : Colors
                                                                            .black
                                                                            .withOpacity(0.3),
                                                                    colorBlendMode: _currentStarPoint >=
                                                                            60
                                                                        ? null
                                                                        : BlendMode
                                                                            .modulate,
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
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 15),
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
                                                pokedex[_currentPokemon]['type']
                                                    .length,
                                                (index) => PetTagCustom(
                                                  nameTag:
                                                      pokedex[_currentPokemon]
                                                          ['type'][index],
                                                  height: 35,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      2 /
                                                      3 /
                                                      2,
                                                  style: TextStyle(
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            25,
                                                    fontFamily: 'Alata',
                                                    color: Colors.white,
                                                    decoration:
                                                        TextDecoration.none,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 15),
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
                                                pokedex[_currentPokemon]
                                                        ['weaknesses']
                                                    .length,
                                                (index) => PetTagCustom(
                                                  nameTag:
                                                      pokedex[_currentPokemon]
                                                          ['weaknesses'][index],
                                                  height: 35,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      2 /
                                                      3 /
                                                      2,
                                                  style: TextStyle(
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            25,
                                                    fontFamily: 'Alata',
                                                    color: Colors.white,
                                                    decoration:
                                                        TextDecoration.none,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15),
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
                                          pokedex[_currentPokemon]
                                              ['introduction'],
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
                                SafeArea(
                                  child: Align(
                                    alignment: FractionalOffset.topRight,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 15,
                                        vertical: 20,
                                      ),
                                      child: GestureDetector(
                                        child: Icon(
                                          Feather.info,
                                          color: Colors.black45,
                                          size: 30,
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => AboutMeScreen(),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            );
          }
          return SwipeDetector(
            onSwipeRight: () => Navigator.pop(context),
            onSwipeLeft: () => Navigator.pop(context),
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: CustomPaint(
                painter: HeaderPainterRightHand(
                  ctx: widget.ctx,
                  type1: tagColor[pokedex[_currentPokemon]['type'][0]],
                ),
                child: StreamBuilder<List<PokemonState>>(
                  stream: _allPokemonBloc.listPokemonStateStream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Container();
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Flexible(
                          flex: 3,
                          child: Stack(
                            children: <Widget>[
                              SingleChildScrollView(
                                physics: BouncingScrollPhysics(),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              5,
                                    ),
                                    Center(
                                      child: Image.asset(
                                        pokemonImages[_currentPokemon],
                                        height:
                                            MediaQuery.of(context).size.height /
                                                4,
                                        color: snapshot.data[_currentPokemon]
                                                    .state ==
                                                0
                                            ? Colors.black45
                                            : null,
                                        colorBlendMode: snapshot
                                                    .data[_currentPokemon]
                                                    .state ==
                                                0
                                            ? BlendMode.modulate
                                            : null,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 20,
                                        left: 14,
                                        right: 14,
                                      ),
                                      child: SizedBox(
                                        height: 56,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              pokedex[_currentPokemon]['name'],
                                              style: TextStyle(
                                                fontFamily: 'Alata',
                                                color: Colors.black,
                                                fontSize: MediaQuery.of(context)
                                                            .size
                                                            .width >
                                                        600
                                                    ? 35
                                                    : 26,
                                                decoration: TextDecoration.none,
                                              ),
                                            ),
                                            snapshot.data[_currentPokemon]
                                                        .state ==
                                                    1
                                                ? _buildFavouriteButton()
                                                : GestureDetector(
                                                    onTap: () async {
                                                      if (await currentStar() >=
                                                          60) {
                                                        print(MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width);
                                                        _showBuyCheckDialog(
                                                            context);
                                                      }
                                                    },
                                                    child: Material(
                                                      elevation: 4,
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10),
                                                        child: Column(
                                                          children: <Widget>[
                                                            Text(
                                                              'Unlock ',
                                                              style: TextStyle(
                                                                color: _currentStarPoint >=
                                                                        60
                                                                    ? TodoColors
                                                                        .deepPurple
                                                                    : Colors
                                                                        .grey,
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                decoration:
                                                                    TextDecoration
                                                                        .none,
                                                              ),
                                                            ),
                                                            Row(
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  '60 ',
                                                                  style:
                                                                      TextStyle(
                                                                    color: _currentStarPoint >=
                                                                            60
                                                                        ? TodoColors
                                                                            .deepPurple
                                                                        : Colors
                                                                            .grey,
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300,
                                                                    decoration:
                                                                        TextDecoration
                                                                            .none,
                                                                  ),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                                Image.asset(
                                                                  'assets/png/star.png',
                                                                  height: 12,
                                                                  color: _currentStarPoint >=
                                                                          60
                                                                      ? null
                                                                      : Colors
                                                                          .black
                                                                          .withOpacity(
                                                                              0.3),
                                                                  colorBlendMode:
                                                                      _currentStarPoint >=
                                                                              60
                                                                          ? null
                                                                          : BlendMode
                                                                              .modulate,
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
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 15),
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
                                              pokedex[_currentPokemon]['type']
                                                  .length,
                                              (index) => PetTagCustom(
                                                nameTag:
                                                    pokedex[_currentPokemon]
                                                        ['type'][index],
                                                height: 35,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    2 /
                                                    3 /
                                                    2,
                                                style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          25,
                                                  fontFamily: 'Alata',
                                                  color: Colors.white,
                                                  decoration:
                                                      TextDecoration.none,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 15),
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
                                              pokedex[_currentPokemon]
                                                      ['weaknesses']
                                                  .length,
                                              (index) => PetTagCustom(
                                                nameTag:
                                                    pokedex[_currentPokemon]
                                                        ['weaknesses'][index],
                                                height: 35,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    2 /
                                                    3 /
                                                    2,
                                                style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          25,
                                                  fontFamily: 'Alata',
                                                  color: Colors.white,
                                                  decoration:
                                                      TextDecoration.none,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 15),
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
                                        pokedex[_currentPokemon]
                                            ['introduction'],
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
                              SafeArea(
                                child: Align(
                                  alignment: FractionalOffset.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 20,
                                    ),
                                    child: GestureDetector(
                                      child: Icon(
                                        Feather.info,
                                        color: Colors.black45,
                                        size: 30,
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => AboutMeScreen(),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Stack(
                            children: <Widget>[
                              ListWheelScrollView(
                                controller: _scrollController,
                                physics: BouncingScrollPhysics(),
                                offAxisFraction:
                                    (MediaQuery.of(context).size.height > 600)
                                        ? -6
                                        : -13,
                                onSelectedItemChanged: (value) {
                                  setState(() {
                                    _currentPokemon = value;
                                  });
                                },
                                children: List.generate(
                                  pokedex.length,
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
                                      child: Stack(
                                        children: <Widget>[
                                          Image.asset(
                                            pokemonImages[index],
                                            height: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    4 -
                                                10,
                                            color:
                                                snapshot.data[index].state == 0
                                                    ? Colors.black54
                                                    : null,
                                            colorBlendMode:
                                                snapshot.data[index].state == 0
                                                    ? BlendMode.modulate
                                                    : null,
                                          ),
                                          if (snapshot.data[index].state == 0)
                                            Align(
                                              alignment:
                                                  FractionalOffset.center,
                                              child: Icon(
                                                AntDesign.question,
                                                size: 30,
                                                color: Colors.white,
                                              ),
                                            ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                itemExtent:
                                    MediaQuery.of(context).size.width / 4,
                              ),
                              SafeArea(
                                child: Align(
                                  alignment: FractionalOffset.bottomRight,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 20,
                                    ),
                                    child: GestureDetector(
                                      child: Icon(
                                        Icons.settings,
                                        color: Colors.black45,
                                        size: 30,
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => SettingScreen(
                                              ctx: context,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFavouriteButton() {
    return Container(
      child: _favouritePokemon != _currentPokemon
          ? GestureDetector(
              onTap: () {
                _currentPokemonBloc.event.add(
                  UpdateFavouritePokemonEvent(
                    newPokemon: _currentPokemon,
                  ),
                );
                setState(() {
                  _favouritePokemon = _currentPokemon;
                });
              },
              child: Icon(
                AntDesign.hearto,
                color: Colors.black45,
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
                  _favouritePokemon = -1;
                });
              },
              child: Icon(
                AntDesign.heart,
                color: Colors.redAccent,
                size: 30,
              ),
            ),
    );
  }
}

class HeaderPainterLeftHand extends CustomPainter {
  final BuildContext ctx;
  final Color type1;
  const HeaderPainterLeftHand({
    this.type1,
    this.ctx,
  });
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    Path path = Path();

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 0);
    paint = Paint()..color = type1.withOpacity(0.6);
    canvas.drawPath(path, paint);

    path.reset();
    path.moveTo(0, size.height / 5);
    path.quadraticBezierTo(
      size.width / 2 + 8.3,
      size.height / 2,
      0,
      size.height * 4 / 5,
    );

    paint = Paint()..color = Colors.white;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => oldDelegate != this;
}

class HeaderPainterRightHand extends CustomPainter {
  final BuildContext ctx;
  final Color type1;
  const HeaderPainterRightHand({
    this.type1,
    this.ctx,
  });
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    Path path = Path();

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 0);
    paint = Paint()..color = type1.withOpacity(0.6);
    canvas.drawPath(path, paint);

    path.reset();
    path.moveTo(size.width, size.height / 5);
    path.quadraticBezierTo(
      size.width / 2 - 8.3,
      size.height / 2,
      size.width,
      size.height * 4 / 5,
    );

    paint = Paint()..color = Colors.white;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => oldDelegate != this;
}
