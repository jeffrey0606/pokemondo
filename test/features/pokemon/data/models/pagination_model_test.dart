import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pokemondo/features/pokemon/data/models/named_pokemon_model.dart';
import 'package:pokemondo/features/pokemon/data/models/pagination_model.dart';
import 'package:pokemondo/features/pokemon/domain/entities/pagination.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  PaginationModel tPaginationModel = PaginationModel(
    next: "https://pokeapi.co/api/v2/pokemon?offset=2&limit=2",
    previous: null,
    results: [
      {"name": "bulbasaur", "url": "https://pokeapi.co/api/v2/pokemon/1/"},
      {"name": "ivysaur", "url": "https://pokeapi.co/api/v2/pokemon/2/"}
    ].map((e) => NamedPokemonModel.fromJson(e)).toList(),
  );

  test("we should have a subclass of Pagination entity", () async {
    expect(tPaginationModel, isA<Pagination>());
  });

  test("should return a valid model", () async {
    //arrange
    final Map<String, dynamic> jsonMap =
        json.decode(fixture("pagination.json"));

    //act
    final result = PaginationModel.fromJson(jsonMap);

    //assert
    expect(result, tPaginationModel);
  });

  test("should return a JSON map containing the proper data", () async {
    //act
    final result = tPaginationModel.toJson();

    //assert
    const expectedMap = {
      "next": "https://pokeapi.co/api/v2/pokemon?offset=2&limit=2",
      "previous": null,
      "results": [
        {"name": "bulbasaur", "url": "https://pokeapi.co/api/v2/pokemon/1/"},
        {"name": "ivysaur", "url": "https://pokeapi.co/api/v2/pokemon/2/"}
      ]
    };
    expect(result, expectedMap);
  });
}
