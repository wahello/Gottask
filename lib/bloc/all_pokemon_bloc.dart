import 'dart:async';

import 'package:gottask/base/base_bloc.dart';
import 'package:gottask/base/base_event.dart';
import 'package:gottask/database/pokemonStateTable.dart';
import 'package:gottask/events/pokemon_state/update_pokemon_state_event.dart';
import 'package:gottask/models/pokemon_state.dart';


List<PokemonState> allPokemonStateList = [];

class AllPokemonBloc extends BaseBloc {
  final StreamController<List<PokemonState>> _pokemonStateStreamController =
      StreamController<List<PokemonState>>();
  Stream<List<PokemonState>> get listPokemonStateStream =>
      _pokemonStateStreamController.stream;

  Sink<List<PokemonState>> get listPokemonStateSink =>
      _pokemonStateStreamController.sink;

  Future<void> initAllPokemonBloc() async {
    allPokemonStateList = await PokemonStateTable().selectAllPokemonState();
    listPokemonStateSink.add(allPokemonStateList);
  }

  @override
  void dispose() {
    super.dispose();
    _pokemonStateStreamController.close();
  }

  Future<void> _updateEvent(PokemonState pokemonState) async {
    await PokemonStateTable().updatePokemonState(pokemonState);
    allPokemonStateList = await PokemonStateTable().selectAllPokemonState();
    listPokemonStateSink.add(allPokemonStateList);
  }

  @override
  void actEvent(BaseEvent event) {
    if (event is UpdatePokemonStateEvent) {
      _updateEvent(event.pokemonState);
    }
  }
}
