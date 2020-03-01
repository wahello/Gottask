
import 'package:gottask/base/base_event.dart';
import 'package:gottask/models/pokemon_state.dart';

class UpdatePokemonStateEvent extends BaseEvent {
  final PokemonState pokemonState;
  UpdatePokemonStateEvent({this.pokemonState});
}
