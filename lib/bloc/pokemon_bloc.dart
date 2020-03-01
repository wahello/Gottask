import 'dart:async';

import 'package:gottask/base/base_bloc.dart';
import 'package:gottask/base/base_event.dart';
import 'package:gottask/database/pokemonStateDatabase.dart';
import 'package:gottask/database/pokemonStateTable.dart';
import 'package:gottask/events/pokemon_state/update_pokemon_state_event.dart';
import 'package:gottask/models/pokemon_state.dart';


List<PokemonState> pokemonStateList = [];

class PokemonStateBloc extends BaseBloc {
  final StreamController<List<PokemonState>> _pokemonStateStreamController =
      StreamController<List<PokemonState>>();
  Stream<List<PokemonState>> get listPokemonStateStream =>
      _pokemonStateStreamController.stream;

  Sink<List<PokemonState>> get listPokemonStateSink =>
      _pokemonStateStreamController.sink;

  Future<void> initPokemonStateBloc() async {
    await PokemonStateDatabase.instance.init();
    pokemonStateList = await PokemonStateTable().selectAllPokemonState();
    listPokemonStateSink.add(pokemonStateList);
  }

  @override
  void dispose() {
    super.dispose();
    _pokemonStateStreamController.close();
  }

  Future<void> _updateEvent(PokemonState pokemonState) async {
    await PokemonStateTable().updatePokemonState(pokemonState);
    pokemonStateList = await PokemonStateTable().selectAllPokemonState();
    listPokemonStateSink.add(pokemonStateList);
  }

  @override
  void actEvent(BaseEvent event) {
    if (event is UpdatePokemonStateEvent) {
      _updateEvent(event.pokemonState);
    }
  }
}
