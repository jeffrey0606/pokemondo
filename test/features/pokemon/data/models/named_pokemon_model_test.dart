import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pokemondo/features/pokemon/data/models/named_pokemon_model.dart';
import 'package:pokemondo/features/pokemon/domain/entities/named_pokemon.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const NamedPokemonModel tNamedPokemonModel = NamedPokemonModel(
    name: "bulbasaur",
    url: "https://pokeapi.co/api/v2/pokemon/1/",
  );

  test("we should have a subclass of NamedPokemon entity", () async {
    expect(tNamedPokemonModel, isA<NamedPokemon>());
  });

  test("should return a valid model", () async {
    //arrange
    final Map<String, dynamic> jsonMap =
        json.decode(fixture("named_pokemon.json"));

    //act
    final result = NamedPokemonModel.fromJson(jsonMap);

    //assert
    expect(result, tNamedPokemonModel);
  });

  test("should return a JSON map containing the proper data", () async {
    //act
    final result = tNamedPokemonModel.toJson();

    //assert
    const expectedMap = {
      "name": "bulbasaur",
      "url": "https://pokeapi.co/api/v2/pokemon/1/",
    };
    expect(result, expectedMap);
  });
}
