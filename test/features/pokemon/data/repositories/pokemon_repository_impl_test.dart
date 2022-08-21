import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pokemondo/core/error/exceptions.dart';
import 'package:pokemondo/core/error/failures.dart';
import 'package:pokemondo/core/network/network_info.dart';
import 'package:pokemondo/features/pokemon/data/datasources/pokemon_local_datasource.dart';
import 'package:pokemondo/features/pokemon/data/datasources/pokemon_remote_datasource.dart';
import 'package:pokemondo/features/pokemon/data/models/pokemon_model..dart';
import 'package:pokemondo/features/pokemon/data/repositories/pokemon_repository_impl.dart';
import 'package:pokemondo/features/pokemon/domain/entities/named_pokemon.dart';
import 'package:pokemondo/features/pokemon/domain/entities/pokemon.dart';

import 'pokemon_repository_impl_test.mocks.dart';

@GenerateMocks([PokemonRemoteDataSource, NetworkInfo, PokemonLocalDataSource])
void main() {
  late PokemonRepositoryImpl repositoryImpl;
  late MockPokemonLocalDataSource mockPokemonLocalDataSource;
  late MockPokemonRemoteDataSource mockPokemonRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockPokemonLocalDataSource = MockPokemonLocalDataSource();
    mockPokemonRemoteDataSource = MockPokemonRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();

    repositoryImpl = PokemonRepositoryImpl(
      pokemonRemoteDataSource: mockPokemonRemoteDataSource,
      pokemonLocalDataSource: mockPokemonLocalDataSource,
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

  group("getPokemon", () {
    const NamedPokemon tNamedPokemon = NamedPokemon(
      name: "bulbasaur",
      url: "https://pokeapi.co/api/v2/pokemon/1/",
    );

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

    Pokemon tPokemon = tPokemonModel;

    test("should check if the device is online", () async {
      //arrange
      when(mockNetworkInfo.isConnected)
          .thenAnswer((realInvocation) async => true);
      when(mockPokemonRemoteDataSource.getPokemon(tNamedPokemon))
            .thenAnswer((realInvocation) async => tPokemonModel);
            
      //act
      await repositoryImpl.getPokemon(tNamedPokemon);

      //assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
          "should return remote data when the call to remote data source is successful",
          () async {
        //arrange
        when(mockPokemonRemoteDataSource.getPokemon(tNamedPokemon))
            .thenAnswer((realInvocation) async => tPokemonModel);

        //act
        final result = await repositoryImpl.getPokemon(tNamedPokemon);

        //assert
        verify(mockPokemonRemoteDataSource.getPokemon(tNamedPokemon));
        expect(result, equals(Right(tPokemon)));
      });

      test(
          "should cache the data locally when the call to remote data source is successful",
          () async {
        //arrange
        when(mockPokemonRemoteDataSource.getPokemon(tNamedPokemon))
            .thenAnswer((realInvocation) async => tPokemonModel);

        //act
        await repositoryImpl.getPokemon(tNamedPokemon);

        //assert
        verify(mockPokemonRemoteDataSource.getPokemon(tNamedPokemon));
        verify(mockPokemonLocalDataSource.cachePagePokemon(tPokemonModel));
      });

      test(
          "should return server failure when the call to remote data source is unsuccessful",
          () async {
        //arrange
        when(mockPokemonRemoteDataSource.getPokemon(tNamedPokemon))
            .thenThrow(ServerException());

        //act
        final result = await repositoryImpl.getPokemon(tNamedPokemon);

        //assert
        verify(mockPokemonRemoteDataSource.getPokemon(tNamedPokemon));
        verifyZeroInteractions(mockPokemonLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestsOffline(() {
      test("should return locally cached data when the cached data is present",
          () async {
        //arrange
        when(mockPokemonLocalDataSource.getPagePokemon(tNamedPokemon))
            .thenAnswer((realInvocation) async => tPokemonModel);

        //act
        final result = await repositoryImpl.getPokemon(tNamedPokemon);

        //assert
        verifyZeroInteractions(mockPokemonRemoteDataSource);
        verify(mockPokemonLocalDataSource.getPagePokemon(tNamedPokemon));

        expect(result, equals(Right(tPokemon)));
      });

      test("should return cache failure when there is no cached data present",
          () async {
        //arrange
        when(mockPokemonLocalDataSource.getPagePokemon(tNamedPokemon))
            .thenThrow(CacheException());

        //act
        final result = await repositoryImpl.getPokemon(tNamedPokemon);

        //assert
        verifyZeroInteractions(mockPokemonRemoteDataSource);
        verify(mockPokemonLocalDataSource.getPagePokemon(tNamedPokemon));

        expect(result, equals(Left(CacheFailure())));
      });
    });
  });
}
