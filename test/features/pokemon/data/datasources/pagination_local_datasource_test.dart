import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pokemondo/core/error/exceptions.dart';
import 'package:pokemondo/features/pokemon/data/datasources/pagination_local_datasource.dart';
import 'package:pokemondo/features/pokemon/data/datasources/pokemon_local_datasource.dart';
import 'package:pokemondo/features/pokemon/data/models/named_pokemon_model.dart';
import 'package:pokemondo/features/pokemon/data/models/pagination_model.dart';
import 'package:pokemondo/features/pokemon/data/models/pokemon_model..dart';
import 'package:pokemondo/features/pokemon/domain/entities/named_pokemon.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'pagination_local_datasource_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late PaginationLocalDataSourceImpl dataSourceImpl;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSourceImpl = PaginationLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  const NamedPokemon tNamedPokemon = NamedPokemon(
    name: "bulbasaur",
    url: "https://pokeapi.co/api/v2/pokemon/1/",
  );

  group("getPagePagination", () {
    final tPaginationModel = PaginationModel.fromJson(
      json.decode(fixture("pagination_cached.json")),
    );
    test(
        "should return a Page Pagination from SharedPreferences when there is one in the cache",
        () async {
      //arrange
      when(mockSharedPreferences.getString(any))
          .thenReturn(fixture("pagination_cached.json"));

      //act
      final result = await dataSourceImpl.getPagePagination();

      // assert
      verify(mockSharedPreferences.getString(CACHED_PAGINATION));
      expect(result, equals(tPaginationModel));
    });

    test("should throw a CacheException when there is not a cached value",
        () async {
      //arrange
      when(mockSharedPreferences.getString(any)).thenThrow(CacheException());

      //act
      final call = dataSourceImpl.getPagePagination;

      // assert
      expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
    });
  });

  group("cachePagePokemon", () {
    PaginationModel tPaginationModel = PaginationModel(
      next: "https://pokeapi.co/api/v2/pokemon?offset=2&limit=2",
      previous: null,
      results: [
        {"name": "bulbasaur", "url": "https://pokeapi.co/api/v2/pokemon/1/"},
        {"name": "ivysaur", "url": "https://pokeapi.co/api/v2/pokemon/2/"}
      ].map((e) => NamedPokemonModel.fromJson(e)).toList(),
    );

    test("should call SharedPreferences to cache the data", () async {
      //arrange

      when(mockSharedPreferences.containsKey(any))
          .thenAnswer((realInvocation) => true);

      when(mockSharedPreferences.setString(any, any))
          .thenAnswer((realInvocation) async => true);

      //act
      dataSourceImpl.cachePagePagination(tPaginationModel);

      //assert
      final expectedJsonString = json.encode(tPaginationModel.toJson());
      verifyNever(mockSharedPreferences.setString(
        CACHED_PAGINATION,
        expectedJsonString,
      ));
    });
  });
}
