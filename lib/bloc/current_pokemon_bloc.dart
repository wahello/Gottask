import 'dart:async';

import 'package:gottask/base/base_bloc.dart';
import 'package:gottask/base/base_event.dart';
import 'package:gottask/constant.dart';
import 'package:gottask/events/current_pokemon/update_favourite_pokemon_event.dart';


int currentPokemon = -1;

class CurrentPokemonBloc extends BaseBloc {
  StreamController<int> _currentPokemonStreamController =
      StreamController<int>();
  Stream<int> get currentPokemonStream =>
      _currentPokemonStreamController.stream;
  Sink<int> get currentPokemonSink => _currentPokemonStreamController.sink;

  initCurrentPokemonBloc() async {
    currentPokemon = await currentFavouritePokemon();
    currentPokemonSink.add(currentPokemon);
  }

  _updateEvent(int newPokemon) async {
    currentPokemon =  await updateFavouritePokemon(newPokemon);
    currentPokemonSink.add(currentPokemon);
  }

  @override
  void dispose() {
    super.dispose();
    _currentPokemonStreamController.close();
  }

  @override
  void actEvent(BaseEvent event) {
    if (event is UpdateFavouritePokemonEvent) {
      _updateEvent(event.newPokemon);
    }
  }
}
