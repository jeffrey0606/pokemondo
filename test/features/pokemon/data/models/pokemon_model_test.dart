import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pokemondo/features/pokemon/data/models/pokemon_model..dart';
import 'package:pokemondo/features/pokemon/domain/entities/pokemon.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
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

  test(
    "we should have a subclass of Pokemon entity",
    () async {
      expect(tPokemonModel, isA<Pokemon>());
    },
  );

  test("should return a valid model", () async {
    //arrange
    final Map<String, dynamic> jsonMap = json.decode(fixture("pokemon.json"));
    //act
    final result = PokemonModel.fromJson(jsonMap);
    //assert
    expect(result, tPokemonModel);
  });

  test("should return a JSON map containing the proper data", () async {
    //act
    final result = tPokemonModel.toJson();

    //assert
    const expectedMap = {
      "defense": 49,
      "special-attack": 65,
      "special-defense": 65,
      "speed": 45,
      "height": 7,
      "weight": 69,
      "hp": 45,
      "attack": 49,
      "id": 1,
      "name": "bulbasaur",
      "types": ["grass", "poison"],
      "image":
          "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png",
      "imageColors": null,
    };
    expect(result, expectedMap);
  });
}
