import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pokemondo/core/error/exceptions.dart';
import 'package:pokemondo/core/error/failures.dart';
import 'package:pokemondo/features/pokemon/data/datasources/pagination_local_datasource.dart';
import 'package:pokemondo/features/pokemon/data/datasources/pagination_remote_datasource.dart';
import 'package:pokemondo/features/pokemon/data/datasources/pokemon_local_datasource.dart';
import 'package:pokemondo/features/pokemon/data/datasources/pokemon_remote_datasource.dart';
import 'package:pokemondo/features/pokemon/data/models/named_pokemon_model.dart';
import 'package:pokemondo/features/pokemon/data/models/pagination_model.dart';
import 'package:pokemondo/features/pokemon/data/repositories/pagination_repository_impl.dart';
import 'package:pokemondo/features/pokemon/data/repositories/pokemon_repository_impl.dart';
import 'package:pokemondo/features/pokemon/domain/entities/pagination.dart';

import 'pagination_repository_impl_test.mocks.dart';
import 'pokemon_repository_impl_test.mocks.dart';

@GenerateMocks([PaginationRemoteDataSource, PaginationLocalDataSource])
void main() {
  late PaginationRepositoryImpl repositoryImpl;
  late MockPaginationLocalDataSource mockPaginationLocalDataSource;
  late MockPaginationRemoteDataSource mockPaginationRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockPaginationLocalDataSource = MockPaginationLocalDataSource();
    mockPaginationRemoteDataSource = MockPaginationRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();

    repositoryImpl = PaginationRepositoryImpl(
      paginationRemoteDataSource: mockPaginationRemoteDataSource,
      paginationLocalDataSource: mockPaginationLocalDataSource,
      networknfo: mockNetworkInfo,
    );
  });

  void runTestsOnline(Function body) {
    group("device is online", () {
      setUp(() {
        when(mockNetworkInfo.isConnected)
            .thenAnswer((realInvocation) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group("device is offline", () {
      setUp(() {
        when(mockNetworkInfo.isConnected)
            .thenAnswer((realInvocation) async => false);
      });

      body();
    });
  }

  group("getPagination", () {
    const String tUrl = "https://pokeapi.co/api/v2/pokemon/";
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

    PaginationModel tPaginationModel = PaginationModel(
      next: "https://pokeapi.co/api/v2/pokemon/?offset=0&limit=20",
      previous: null,
      results: tResults.map((result) {
        return NamedPokemonModel.fromJson(result);
      }).toList(),
    );

    Pagination tPagination = tPaginationModel;

    runTestsOnline(() {
      test(
          "should return remote data when the call to remote data source is successful",
          () async {
        //arrange
        when(mockPaginationRemoteDataSource.getPage(tUrl))
            .thenAnswer((realInvocation) async => tPaginationModel);

        //act
        final result = await repositoryImpl.getPage(tUrl);

        //assert
        verify(mockPaginationRemoteDataSource.getPage(tUrl));

        expect(result, equals(Right(tPagination)));
      });

      test(
          "should cache the data locally when the call to remote data source is successful",
          () async {
        //arrange
        when(mockPaginationRemoteDataSource.getPage(tUrl))
            .thenAnswer((realInvocation) async => tPaginationModel);

        //act
        await repositoryImpl.getPage(tUrl);

        //assert
        verify(mockPaginationRemoteDataSource.getPage(tUrl));
        verify(mockPaginationLocalDataSource
            .cachePagePagination(tPaginationModel));
      });

      test(
          "should return server failure when the call to remote data source is unsuccessful",
          () async {
        //arrange
        when(mockPaginationRemoteDataSource.getPage(tUrl))
            .thenThrow(ServerException());

        //act
        final result = await repositoryImpl.getPage(tUrl);

        //assert
        verify(mockPaginationRemoteDataSource.getPage(tUrl));
        verifyZeroInteractions(mockPaginationLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestsOffline(() {
      test("should return locally cached data when the cached data is present",
          () async {
        //arrange
        when(mockPaginationLocalDataSource.getPagePagination())
            .thenAnswer((realInvocation) async => tPaginationModel);

        //act
        final result = await mockPaginationLocalDataSource.getPagePagination();

        //assert
        verifyZeroInteractions(mockPaginationRemoteDataSource);
        verify(mockPaginationLocalDataSource.getPagePagination());

        expect(result, equals(tPaginationModel));
      });

      test("should return cache failure when there is no cached data present",
          () async {
        //arrange
        when(mockPaginationLocalDataSource.getPagePagination())
            .thenThrow(CacheException());

        //act
        final result = await repositoryImpl.getPage(tUrl);

        //assert
        verifyZeroInteractions(mockPaginationRemoteDataSource);
        verify(mockPaginationLocalDataSource.getPagePagination());

        expect(result, equals(Left(CacheFailure())));
      });
    });
  });
}
