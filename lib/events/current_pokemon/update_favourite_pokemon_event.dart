
import 'package:gottask/base/base_event.dart';

class UpdateFavouritePokemonEvent extends BaseEvent {
  final int newPokemon;
  UpdateFavouritePokemonEvent({this.newPokemon});
}
