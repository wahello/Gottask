import 'package:gottask/database/pokemonStateDatabase.dart';
import 'package:gottask/models/pokemon_state.dart';
import 'package:sqflite/sqflite.dart';

class PokemonStateTable {
  static const TABLE_NAME = 'pokemonstatedb';
  static const CREATE_TABLE_QUERY = '''
    CREATE TABLE $TABLE_NAME (
      name TEXT PRIMARY KEY,
      state INTEGER
    );
  ''';
  
  static const DROP_TABLE_QUERY = '''
      DROP TABLE IF EXISTS $TABLE_NAME
  ''';

  Future<int> insertPokemonState(PokemonState pokemonState) {
    Database db = PokemonStateDatabase.instance.database;
    return db.insert(
      TABLE_NAME,
      pokemonState.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updatePokemonState(PokemonState pokemonState) {
    Database db = PokemonStateDatabase.instance.database;
    print('update ${pokemonState.toMap().toString()}');

    return db.update(
      TABLE_NAME,
      pokemonState.toMap(),
      where: 'name = ?',
      whereArgs: [pokemonState.name],
    );
  }

  Future<List<PokemonState>> selectAllPokemonState() async {
    Database db = PokemonStateDatabase.instance.database;
    List<Map<String, dynamic>> maps = await db.query('$TABLE_NAME');
    if (maps.length == 0) return [];
    return List.generate(
      maps.length,
      (index) {
        return PokemonState(
          name: maps[index]['name'],
          state: maps[index]['state'],
        );
      },
    );
  }
}
