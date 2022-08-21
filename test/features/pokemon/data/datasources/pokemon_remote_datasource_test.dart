import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pokemondo/core/error/exceptions.dart';
import 'package:pokemondo/features/pokemon/data/datasources/pokemon_remote_datasource.dart';
import 'package:pokemondo/features/pokemon/data/models/pokemon_model..dart';
import 'package:pokemondo/features/pokemon/domain/entities/named_pokemon.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'pokemon_remote_datasource_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late PokemonRemoteDataSourceImpl dataSourceImpl;
  late MockClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();
    dataSourceImpl = PokemonRemoteDataSourceImpl(
      client: mockHttpClient,
    );
  });

  group("getPokemon", () {
    const NamedPokemon tNamedPokemon = NamedPokemon(
      name: "bulbasaur",
      url: "https://pokeapi.co/api/v2/pokemon/1/",
    );

    final PokemonModel pokemonModel =
        PokemonModel.fromJson(json.decode(fixture('pokemon.json')));

    test("should perform a GET request on a pokemon URL", () async {
      //arrange
      when(mockHttpClient.get(any)).thenAnswer((realInvocation) async =>
          http.Response(fixture('pokemon.json'), 200));

      //act
      dataSourceImpl.getPokemon(tNamedPokemon);

      //assert
      verify(mockHttpClient.get(Uri.parse(tNamedPokemon.url)));
    });

    test("should return Pokemon when the response code is 200 (success)",
        () async {
      //arrange
      when(mockHttpClient.get(any)).thenAnswer((realInvocation) async =>
          http.Response(fixture('pokemon.json'), 200));

      //act
      final result = await dataSourceImpl.getPokemon(tNamedPokemon);

      //assert
      expect(result, equals(pokemonModel));
    });

    test(
        "should throw a ServerException when the response code is 404 or other",
        () async {
      //arrange
      when(mockHttpClient.get(any)).thenAnswer((realInvocation) async =>
          http.Response(fixture('pokemon.json'), 404));
      //act
      final call = dataSourceImpl.getPokemon;
      expect(() => call(tNamedPokemon),
          throwsA(const TypeMatcher<ServerException>()));
    });
  });
}
