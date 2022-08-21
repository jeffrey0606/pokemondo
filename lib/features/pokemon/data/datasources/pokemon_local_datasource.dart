import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/named_pokemon.dart';
import '../models/pokemon_model..dart';

abstract class PokemonLocalDataSource {
  ///Get the cached [PokemonModel] which is within a single page[0 - 20]
  ///This is gotten the first time the user had an internat connection.
  ///
  ///Throws [NoLocalDataException] if no cached data is present.
  Future<PokemonModel> getPagePokemon(NamedPokemon namedPokemon);

  Future<void> cachePagePokemon(PokemonModel pokemonModel);

  Future<bool> saveFavourites(List<PokemonModel> pokemonModels);

  Future<bool> removeFavourite(int id);

  Future<List<PokemonModel>> getFavourites();
}

const String CACHED_POKEMON_ = "CACHED_POKEMON_";
const String SAVED_FAVOURITE_POKEMONS = "SAVED_FAVOURITE_POKEMONS";

class PokemonLocalDataSourceImpl extends PokemonLocalDataSource {
  final SharedPreferences sharedPreferences;

  PokemonLocalDataSourceImpl({
    required this.sharedPreferences,
  });

  @override
  Future<PokemonModel> getPagePokemon(NamedPokemon namedPokemon) {
    final String? jsonString =
        sharedPreferences.getString("$CACHED_POKEMON_${namedPokemon.name}");
    if (jsonString != null) {
      return Future.value(PokemonModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cachePagePokemon(PokemonModel pokemonModel) {
    return sharedPreferences.setString(
      "$CACHED_POKEMON_${pokemonModel.name}",
      json.encode(pokemonModel.toJson()),
    );
  }

  @override
  Future<List<PokemonModel>> getFavourites() async {
    final List<String>? listJsonString =
        sharedPreferences.getStringList(SAVED_FAVOURITE_POKEMONS);

    if (listJsonString != null) {
      return listJsonString
          .map(
            (jsonString) => PokemonModel.fromJson(
              json.decode(jsonString),
            ),
          )
          .toList();
    } else {
      return [];
    }
  }

  @override
  Future<bool> removeFavourite(int id) {
    final List<String>? listJsonString =
        sharedPreferences.getStringList(SAVED_FAVOURITE_POKEMONS);
    if (listJsonString != null) {
      int len = listJsonString.length;

      if (len <= 1) {
        return sharedPreferences.remove(SAVED_FAVOURITE_POKEMONS);
      } else {
        listJsonString.removeWhere((jsonString) {
          Map<String, dynamic> pokemon = json.decode(jsonString);

          return pokemon["id"] == id;
        });

        return sharedPreferences.setStringList(
          SAVED_FAVOURITE_POKEMONS,
          listJsonString,
        );
      }
    } else {
      throw CacheException();
    }
  }

  @override
  Future<bool> saveFavourites(List<PokemonModel> pokemonModels) {
    return sharedPreferences.setStringList(
        SAVED_FAVOURITE_POKEMONS,
        pokemonModels
            .map(
              (pokemonModel) => jsonEncode(pokemonModel),
            )
            .toList());
  }
}
