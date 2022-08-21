import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pokemondo/features/pokemon/domain/entities/named_pokemon.dart';
import 'package:pokemondo/features/pokemon/domain/entities/pagination.dart';
import 'package:pokemondo/features/pokemon/domain/repositories/pagination_repository.dart';
import 'package:pokemondo/features/pokemon/domain/usecases/get_page.dart';

import 'get_page_test.mocks.dart';

@GenerateMocks([PaginationRepository])
void main() {
  late GetPage usecase;
  late MockPaginationRepository mockPaginationRepository;

  setUp(() {
    mockPaginationRepository = MockPaginationRepository();
    usecase = GetPage(mockPaginationRepository);
  });

  String tUrl = "https://pokeapi.co/api/v2/pokemon/";
  List<Map<String, String>> tResults = [
    {"name": "bulbasaur", "url": "https://pokeapi.co/api/v2/pokemon/1/"},
    {"name": "ivysaur", "url": "https://pokeapi.co/api/v2/pokemon/2/"},
    {"name": "venusaur", "url": "https://pokeapi.co/api/v2/pokemon/3/"},
    {"name": "charmander", "url": "https://pokeapi.co/api/v2/pokemon/4/"},
    {"name": "charmeleon", "url": "https://pokeapi.co/api/v2/pokemon/5/"},
    {"name": "charizard", "url": "https://pokeapi.co/api/v2/pokemon/6/"},
    {"name": "squirtle", "url": "https://pokeapi.co/api/v2/pokemon/7/"},
    {"name": "wartortle", "url": "https://pokeapi.co/api/v2/pokemon/8/"},
    {"name": "blastoise", "url": "https://pokeapi.co/api/v2/pokemon/9/"},
    {"name": "caterpie", "url": "https://pokeapi.co/api/v2/pokemon/10/"},
    {"name": "metapod", "url": "https://pokeapi.co/api/v2/pokemon/11/"},
    {"name": "butterfree", "url": "https://pokeapi.co/api/v2/pokemon/12/"},
    {"name": "weedle", "url": "https://pokeapi.co/api/v2/pokemon/13/"},
    {"name": "kakuna", "url": "https://pokeapi.co/api/v2/pokemon/14/"},
    {"name": "beedrill", "url": "https://pokeapi.co/api/v2/pokemon/15/"},
    {"name": "pidgey", "url": "https://pokeapi.co/api/v2/pokemon/16/"},
    {"name": "pidgeotto", "url": "https://pokeapi.co/api/v2/pokemon/17/"},
    {"name": "pidgeot", "url": "https://pokeapi.co/api/v2/pokemon/18/"},
    {"name": "rattata", "url": "https://pokeapi.co/api/v2/pokemon/19/"},
    {"name": "raticate", "url": "https://pokeapi.co/api/v2/pokemon/20/"}
  ];

  Pagination tPagination = Pagination(
    next: "https://pokeapi.co/api/v2/pokemon/?offset=20&limit=20",
    previous: null,
    results: tResults.map((result) {
      return NamedPokemon(
        name: result["name"].toString(),
        url: result["url"].toString(),
      );
    }).toList(),
  );

  test("should get the page and all its attached Named Pokemon API resources",
      () async {
    //arrange
    when(mockPaginationRepository.getPage(tUrl))
        .thenAnswer((_) async => Right(tPagination));

    // act
    final result = await usecase(Params(url: tUrl));

    // assert
    expect(result, Right(tPagination));
    verify(mockPaginationRepository.getPage(tUrl));
    verifyNoMoreInteractions(mockPaginationRepository);
  });
}
