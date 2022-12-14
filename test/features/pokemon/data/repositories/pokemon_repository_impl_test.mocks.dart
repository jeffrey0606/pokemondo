// Mocks generated by Mockito 5.2.0 from annotations
// in pokemondo/test/features/pokemon/data/repositories/pokemon_repository_impl_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i4;

import 'package:mockito/mockito.dart' as _i1;
import 'package:pokemondo/core/network/network_info.dart' as _i6;
import 'package:pokemondo/features/pokemon/data/datasources/pokemon_local_datasource.dart'
    as _i7;
import 'package:pokemondo/features/pokemon/data/datasources/pokemon_remote_datasource.dart'
    as _i3;
import 'package:pokemondo/features/pokemon/data/models/pokemon_model..dart'
    as _i2;
import 'package:pokemondo/features/pokemon/domain/entities/named_pokemon.dart'
    as _i5;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakePokemonModel_0 extends _i1.Fake implements _i2.PokemonModel {}

/// A class which mocks [PokemonRemoteDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockPokemonRemoteDataSource extends _i1.Mock
    implements _i3.PokemonRemoteDataSource {
  MockPokemonRemoteDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.PokemonModel> getPokemon(_i5.NamedPokemon? namedPokemon) =>
      (super.noSuchMethod(Invocation.method(#getPokemon, [namedPokemon]),
              returnValue:
                  Future<_i2.PokemonModel>.value(_FakePokemonModel_0()))
          as _i4.Future<_i2.PokemonModel>);
}

/// A class which mocks [NetworkInfo].
///
/// See the documentation for Mockito's code generation for more information.
class MockNetworkInfo extends _i1.Mock implements _i6.NetworkInfo {
  MockNetworkInfo() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<bool> get isConnected =>
      (super.noSuchMethod(Invocation.getter(#isConnected),
          returnValue: Future<bool>.value(false)) as _i4.Future<bool>);
}

/// A class which mocks [PokemonLocalDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockPokemonLocalDataSource extends _i1.Mock
    implements _i7.PokemonLocalDataSource {
  MockPokemonLocalDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.PokemonModel> getPagePokemon(_i5.NamedPokemon? namedPokemon) =>
      (super.noSuchMethod(Invocation.method(#getPagePokemon, [namedPokemon]),
              returnValue:
                  Future<_i2.PokemonModel>.value(_FakePokemonModel_0()))
          as _i4.Future<_i2.PokemonModel>);
  @override
  _i4.Future<void> cachePagePokemon(_i2.PokemonModel? pokemonModel) =>
      (super.noSuchMethod(Invocation.method(#cachePagePokemon, [pokemonModel]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i4.Future<void>);
  @override
  _i4.Future<bool> saveFavourites(List<_i2.PokemonModel>? pokemonModels) =>
      (super.noSuchMethod(Invocation.method(#saveFavourites, [pokemonModels]),
          returnValue: Future<bool>.value(false)) as _i4.Future<bool>);
  @override
  _i4.Future<bool> removeFavourite(int? id) =>
      (super.noSuchMethod(Invocation.method(#removeFavourite, [id]),
          returnValue: Future<bool>.value(false)) as _i4.Future<bool>);
  @override
  _i4.Future<List<_i2.PokemonModel>> getFavourites() =>
      (super.noSuchMethod(Invocation.method(#getFavourites, []),
              returnValue:
                  Future<List<_i2.PokemonModel>>.value(<_i2.PokemonModel>[]))
          as _i4.Future<List<_i2.PokemonModel>>);
}
