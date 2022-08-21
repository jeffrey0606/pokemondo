import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pokemondo/core/error/failures.dart';
import 'package:pokemondo/core/utils/enums.dart';
import 'package:pokemondo/features/pokemon/domain/entities/named_pokemon.dart';
import 'package:pokemondo/features/pokemon/domain/entities/pagination.dart';
import 'package:pokemondo/features/pokemon/domain/usecases/get_page.dart';
import 'package:pokemondo/features/pokemon/presentation/pagination_bloc/bloc/pagination_bloc.dart';

import 'pagination_bloc_test.mocks.dart';

@GenerateMocks([GetPage])
void main() {
  late PaginationBloc bloc;
  late MockGetPage mockGetPage;

  setUp(() {
    mockGetPage = MockGetPage();
    bloc = PaginationBloc(
      getPage: mockGetPage,
    );
  });

  test("initialState should be Initial", () {
    //assert
    expect(bloc.state.status, equals(PaginationStatus.initial));
  });

  group("GetPaginationPage", () {
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

    test("should get data from the pagination usecase", () async {
      //arrange
      when(mockGetPage.call(any)).thenAnswer((_) async => Right(tPagination));

      //act
      bloc.add(GetPaginationPage(tUrl));
      await untilCalled(mockGetPage(any));

      //assert
      verifyNever(mockGetPage(Params(url: tUrl)));
    });

    test("should emit [loading, loaded] when data is gotten successfully",
        () async {
      //arrange
      when(mockGetPage.call(any)).thenAnswer((_) async => Right(tPagination));

      //assert later
      final expected = [
        PaginationStatus.loading,
        PaginationStatus.loaded,
      ];
      expectLater(
          bloc.stream.map((event) => event.status), emitsInOrder(expected));

      //act
      bloc.add(GetPaginationPage(tUrl));
    });

    test("should emit [loading, failed] when data is gotten fails", () async {
      //arrange
      when(mockGetPage.call(any))
          .thenAnswer((_) async => Left(ServerFailure()));

      //assert later
      final expected = [
        PaginationStatus.loading,
        PaginationStatus.failed,
      ];
      final expectedError = [
        const Error.no(),
        const Error(SERVER_FAILURE_MESSAGE)
      ];
      expectLater(
          bloc.stream.map((event) => event.status), emitsInOrder(expected));
      expectLater(
          bloc.stream.map((event) => event.error), emitsInOrder(expectedError));

      //act
      bloc.add(GetPaginationPage(tUrl));
    });

    test(
        "should emit [loading, failed] with proper message for the error when getting data fails",
        () async {
      //arrange
      when(mockGetPage.call(any)).thenAnswer((_) async => Left(CacheFailure()));

      //assert later
      final expected = [
        PaginationStatus.loading,
        PaginationStatus.failed,
      ];
      final expectedError = [
        const Error.no(),
        const Error(CACHE_FAILURE_MESSAGE),
      ];
      expectLater(
          bloc.stream.map((event) => event.status), emitsInOrder(expected));
      expectLater(
          bloc.stream.map((event) => event.error), emitsInOrder(expectedError));

      //act
      bloc.add(GetPaginationPage(tUrl));
    });
  });
}
