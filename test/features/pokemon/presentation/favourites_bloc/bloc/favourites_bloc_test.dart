import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pokemondo/core/error/failures.dart';
import 'package:pokemondo/core/utils/enums.dart';
import 'package:pokemondo/core/utils/show_toast.dart';
import 'package:pokemondo/features/pokemon/data/models/pokemon_model..dart';
import 'package:pokemondo/features/pokemon/domain/entities/pokemon.dart';
import 'package:pokemondo/features/pokemon/domain/usecases/get_favourites.dart';
import 'package:pokemondo/features/pokemon/domain/usecases/remove_from_favourites.dart';
import 'package:pokemondo/features/pokemon/domain/usecases/save_to_favourites.dart';
import 'package:pokemondo/features/pokemon/presentation/favourites_bloc/bloc/favourites_bloc.dart';

import '../../../../../fixtures/fixture_reader.dart';
import 'favourites_bloc_test.mocks.dart';

@GenerateMocks([SaveToFavourites, RemoveFromFavourites, GetFavourites])
void main() {
  late FavouritesBloc bloc;
  late MockSaveToFavourites mockSaveToFavourites;
  late MockRemoveFromFavourites mockRemoveFromFavourites;
  late MockGetFavourites mockGetFavourites;

  setUp(() {
    mockGetFavourites = MockGetFavourites();
    mockRemoveFromFavourites = MockRemoveFromFavourites();
    mockSaveToFavourites = MockSaveToFavourites();
    bloc = FavouritesBloc(
      getFavourites: mockGetFavourites,
      removeFromFavourites: mockRemoveFromFavourites,
      saveToFavourites: mockSaveToFavourites,
    );
  });

  Pokemon tPokemon = PokemonModel.fromJson(
    json.decode(fixture("pokemon_cached.json")),
  );

  test("initialState should be Initial", () {
    //assert
    expect(bloc.state.status, equals(FavouritesStatus.initial));
  });

  group("AddPokemonToFavourites", () {
    test("should add a pokemon to favourites", () async {
      //arrange
      when(mockSaveToFavourites.call(any))
          .thenAnswer((_) async => const Right(true));

      //act
      bloc.add(AddPokemonToFavourites(tPokemon));
      await untilCalled(mockSaveToFavourites(any));

      //assert
      verifyNever(mockSaveToFavourites(
          SaveParams(pokemons: [...bloc.state.pokemons, tPokemon])));
    });

    test(
        "should emit [adding, failed] with proper message for the error when adding data fails",
        () async {
      //arrange
      when(mockSaveToFavourites.call(any))
          .thenAnswer((_) async => Left(CacheFailure()));

      //assert later
      final expected = [
        FavouritesActionStatus.adding,
        FavouritesActionStatus.failed,
      ];
      final expectedError = [
        const Error.no(),
        const Error(CACHE_FAIL_TO_SAVE),
      ];
      expectLater(bloc.stream.map((event) => event.actionStatus),
          emitsInOrder(expected));
      expectLater(
          bloc.stream.map((event) => event.error), emitsInOrder(expectedError));

      //act
      bloc.add(AddPokemonToFavourites(tPokemon));
    });
  });

  group("GetAllFavourites", () {
    List<Pokemon> tPokemons = [tPokemon];
    test("should get all saved favourite pokemons", () async {
      //arrange
      when(mockGetFavourites.call(any))
          .thenAnswer((_) async => Right(tPokemons));

      //act
      bloc.add(GetAllFavourites());
      await untilCalled(mockGetFavourites(any));

      //assert
      verifyNever(mockGetFavourites(NoParams()));
    });

    test(
        "should emit [removing, failed] with proper message for the error when getting data fails",
        () async {
      //arrange
      when(mockGetFavourites.call(any))
          .thenAnswer((_) async => Left(CacheFailure()));

      //assert later
      final expected = [
        FavouritesStatus.loading,
        FavouritesStatus.failed,
      ];
      final expectedError = [
        const Error.no(),
        const Error(CACHE_FAIL_TO_GET),
      ];
      expectLater(
          bloc.stream.map((event) => event.status), emitsInOrder(expected));
      expectLater(
          bloc.stream.map((event) => event.error), emitsInOrder(expectedError));

      //act
      bloc.add(GetAllFavourites());
    });
  });

  group("RemovePokemonFromFavourites", () {
    int tId = 1;

    test("should remove a pokemon from favourites", () async {
      //arrange
      when(mockRemoveFromFavourites.call(any))
          .thenAnswer((_) async => const Right(true));

      //act
      bloc.add(RemovePokemonFromFavourites(tId));
      await untilCalled(mockRemoveFromFavourites(any));

      //assert
      verify(mockRemoveFromFavourites(RemoveParams(tId)));
    });

    test(
        "should emit [removing, failed] with proper message for the error when removing data fails",
        () async {
      //arrange
      when(mockRemoveFromFavourites.call(any))
          .thenAnswer((_) async => Left(CacheFailure()));

      //assert later
      final expected = [
        FavouritesActionStatus.removing,
        FavouritesActionStatus.failed,
      ];
      final expectedError = [
        const Error.no(),
        const Error(CACHE_FAIL_TO_REMOVE),
      ];
      expectLater(bloc.stream.map((event) => event.actionStatus),
          emitsInOrder(expected));
      expectLater(
          bloc.stream.map((event) => event.error), emitsInOrder(expectedError));

      //act
      bloc.add(RemovePokemonFromFavourites(tId));
    });
  });
}
