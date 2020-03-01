import 'package:gottask/constant.dart';
import 'package:gottask/database/pokemonStateTable.dart';
import 'package:gottask/models/pokemon_state.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class PokemonStateDatabase {
  static const DB_NAME = 'pokemonstatedb.db';
  static const DB_VERSION = 1;
  static Database _database;

  PokemonStateDatabase._internal();
  static final PokemonStateDatabase instance = PokemonStateDatabase._internal();

  Database get database => _database;

  static const initScripts = [PokemonStateTable.CREATE_TABLE_QUERY];
  static const migrationScripts = [PokemonStateTable.DROP_TABLE_QUERY];

  init() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), DB_NAME),
      onCreate: (db, version) {
        initScripts.forEach((script) async => await db.execute(script));
      },
      onUpgrade: (db, oldVersion, newVersion) {
        migrationScripts.forEach((script) async => await db.execute(script));
      },
      version: DB_VERSION,
    );
    if (await isInitDatabase() == false) {
      print('hihi');
      PokemonStateTable pokemonStateTable = PokemonStateTable();
      for (int i = 0; i < pokedex.length; i++) {
        pokemonStateTable.insertPokemonState(
          PokemonState(
            name: pokedex[i]['name'],
            state: 0,
          ),
        );
      }
    }
  }
}
