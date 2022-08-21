import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pokemondo/core/error/failures.dart';
import 'package:pokemondo/features/pokemon/domain/entities/named_pokemon.dart';
import 'package:pokemondo/features/pokemon/domain/entities/pokemon.dart';
import 'package:pokemondo/features/pokemon/domain/usecases/get_pokemon.dart';
import 'package:pokemondo/features/pokemon/presentation/pokemon_bloc/bloc/pokemon_bloc.dart';

import 'pokemon_bloc_test.mocks.dart';

@GenerateMocks([GetPokemon])
void main() {
  late PokemonBloc bloc;
  late MockGetPokemon mockGetPokemon;

  setUp(() {
    mockGetPokemon = MockGetPokemon();
    bloc = PokemonBloc(
      getPokemon: mockGetPokemon,
    );
  });

  test("initialState should be Initial", () {
    //assert
    expect(bloc.state, equals(Initial()));
  });

  group("GetPokemonForDetails", () {
    const NamedPokemon tNamedPokemon = NamedPokemon(
      name: "bulbasaur",
      url: "https://pokeapi.co/api/v2/pokemon/1/",
    );
    Pokemon tPokemon = Pokemon(
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

    test("should get data from the pokemon usecase", () async {
      //arrange
      when(mockGetPokemon.call(any))
          .thenAnswer((_) async => Right(tPokemon));

      //act
      bloc.add(const GetPokemonForDetails(tNamedPokemon));
      await untilCalled(mockGetPokemon(any));
      
      //assert
      verify(mockGetPokemon(const Params(namedPokemon: tNamedPokemon)));
    });

    test("should emit [Loading, Loaded] when data is gotten successfully", () async {
      //arrange
      when(mockGetPokemon.call(any))
          .thenAnswer((_) async => Right(tPokemon));
      
      //assert later
      final expected = [
        Initial(),
        Loading(),
        Loaded(tPokemon),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));

      //act
      bloc.add(const GetPokemonForDetails(tNamedPokemon));
    });

    test("should emit [Loading, Error] when data is gotten fails", () async {
      //arrange
      when(mockGetPokemon.call(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      
      //assert later
      final expected = [
        Initial(),
        Loading(),
        const PokemonError(SERVER_FAILURE_MESSAGE),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));

      //act
      bloc.add(const GetPokemonForDetails(tNamedPokemon));
    });

    test("should emit [Loading, Error] with proper message for the error when getting data fails", () async {
      //arrange
      when(mockGetPokemon.call(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      
      //assert later
      final expected = [
        Initial(),
        Loading(),
        const PokemonError(CACHE_FAILURE_MESSAGE),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));

      //act
      bloc.add(const GetPokemonForDetails(tNamedPokemon));
    });
  });
}
