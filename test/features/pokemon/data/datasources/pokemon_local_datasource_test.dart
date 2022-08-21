import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pokemondo/core/error/exceptions.dart';
import 'package:pokemondo/features/pokemon/data/datasources/pokemon_local_datasource.dart';
import 'package:pokemondo/features/pokemon/data/models/named_pokemon_model.dart';
import 'package:pokemondo/features/pokemon/data/models/pagination_model.dart';
import 'package:pokemondo/features/pokemon/data/models/pokemon_model..dart';
import 'package:pokemondo/features/pokemon/domain/entities/named_pokemon.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'pokemon_local_datasource_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late PokemonLocalDataSourceImpl dataSourceImpl;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSourceImpl = PokemonLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  const NamedPokemon tNamedPokemon = NamedPokemon(
    name: "bulbasaur",
    url: "https://pokeapi.co/api/v2/pokemon/1/",
  );

  group("getPagePokemon", () {
    final tPokemonModel = PokemonModel.fromJson(
      json.decode(fixture("pokemon_cached.json")),
    );
    test(
        "should return PagePokemon from SharedPreferences when there is one in the cache",
        () async {
      //arrange
      when(mockSharedPreferences.getString(any))
          .thenReturn(fixture("pokemon_cached.json"));

      //act
      final result = await dataSourceImpl.getPagePokemon(tNamedPokemon);

      // assert
      verify(mockSharedPreferences
          .getString('$CACHED_POKEMON_${tNamedPokemon.name}'));
      expect(result, equals(tPokemonModel));
    });

    test("should throw a CacheException when there is not a cached value",
        () async {
      //arrange
      when(mockSharedPreferences.getString(any)).thenThrow(CacheException());

      //act
      final call = dataSourceImpl.getPagePokemon;

      // assert
      expect(() => call(tNamedPokemon),
          throwsA(const TypeMatcher<CacheException>()));
    });
  });

  group("cachePagePokemon", () {
    PokemonModel tPokemonModel = PokemonModel(
      defense: 49,
      specialAttack: 65,
      specialDefense: 65,
      speed: 45,
      height: 7,
      weight: 69,
      hp: 45,
      attack: 49,
      id: 1,
      name: "bulbasaur",
      types: ["grass", "poison"],
      image:
          "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png",
    );

    test("should call SharedPreferences to cache the data", () async {
      //arrange
      when(mockSharedPreferences.setString(any, any)).thenAnswer((realInvocation) async => true);
      
      //act
      dataSourceImpl.cachePagePokemon(tPokemonModel);

      //assert
      final expectedJsonString = json.encode(tPokemonModel.toJson());
      verify(mockSharedPreferences.setString(
        "$CACHED_POKEMON_${tNamedPokemon.name}",
        expectedJsonString,
      ));
    });
  });
}
