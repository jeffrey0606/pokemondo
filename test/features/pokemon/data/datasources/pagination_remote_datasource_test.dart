import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:pokemondo/core/error/exceptions.dart';
import 'package:pokemondo/features/pokemon/data/datasources/pagination_remote_datasource.dart';
import 'package:pokemondo/features/pokemon/data/datasources/pokemon_remote_datasource.dart';
import 'package:pokemondo/features/pokemon/data/models/pagination_model.dart';
import 'package:pokemondo/features/pokemon/data/models/pokemon_model..dart';
import 'package:pokemondo/features/pokemon/domain/entities/named_pokemon.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'pokemon_remote_datasource_test.mocks.dart';

void main() {
  late PaginationRemoteDataSourceImpl dataSourceImpl;
  late MockClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();
    dataSourceImpl = PaginationRemoteDataSourceImpl(
      client: mockHttpClient,
    );
  });

  group("getPokemon", () {
    const String tUrl = "https://pokeapi.co/api/v2/pokemon?limit=2&offset=0";

    final PaginationModel paginationModel =
        PaginationModel.fromJson(json.decode(fixture('pagination.json')));

    test("should perform a GET request on a pokemon pagination URL", () async {
      //arrange
      when(mockHttpClient.get(any)).thenAnswer((realInvocation) async =>
          http.Response(fixture('pagination.json'), 200));

      //act
      dataSourceImpl.getPage(tUrl);

      //assert
      verify(mockHttpClient.get(Uri.parse(tUrl)));
    });

    test(
        "should return a Pagination Page when the response code is 200 (success)",
        () async {
      //arrange
      when(mockHttpClient.get(any)).thenAnswer((realInvocation) async =>
          http.Response(fixture('pagination.json'), 200));

      //act
      final result = await dataSourceImpl.getPage(tUrl);

      //assert
      expect(result, equals(paginationModel));
    });

    test(
        "should throw a ServerException when the response code is 404 or other",
        () async {
      //arrange
      when(mockHttpClient.get(any)).thenAnswer((realInvocation) async =>
          http.Response(fixture('pagination.json'), 404));
      //act
      final call = dataSourceImpl.getPage;
      expect(() => call(tUrl), throwsA(const TypeMatcher<ServerException>()));
    });
  });
}
