import 'dart:developer';

import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/named_pokemon.dart';
import '../../domain/entities/pokemon.dart';
import '../../domain/repositories/pokemon_repository.dart';
import '../datasources/pokemon_local_datasource.dart';
import '../datasources/pokemon_remote_datasource.dart';
import '../models/pokemon_model..dart';

class PokemonRepositoryImpl extends PokemonRepository {
  final PokemonRemoteDataSource pokemonRemoteDataSource;
  final PokemonLocalDataSource pokemonLocalDataSource;
  final NetworkInfo networknfo;
  PokemonRepositoryImpl({
    required this.pokemonRemoteDataSource,
    required this.pokemonLocalDataSource,
    required this.networknfo,
  });

  @override
  Future<Either<Failure, Pokemon>> getPokemon(NamedPokemon namedPokemon) async {
    if (await networknfo.isConnected) {
      try {
        final remotePokemon =
            await pokemonRemoteDataSource.getPokemon(namedPokemon);
        // await remotePokemon.setPokemonImageColors();
        await pokemonLocalDataSource.cachePagePokemon(remotePokemon);

        log("pokemon: ${remotePokemon.toJson()}");
        return Right(remotePokemon);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localPokemon =
            await pokemonLocalDataSource.getPagePokemon(namedPokemon);

        return Right(localPokemon);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, List<Pokemon>>> getFavourites() async {
    try {
      final favourites = await pokemonLocalDataSource.getFavourites();

      return Right(favourites);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> removeFromFavourites(int id) async {
    try {
      final removed = await pokemonLocalDataSource.removeFavourite(id);

      return Right(removed);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> saveToFavourites(List<Pokemon> pokemons) async {
    try {
      final saved = await pokemonLocalDataSource.saveFavourites(
        pokemons.map((pokemon) => PokemonModel.fromPokemon(pokemon)).toList(),
      );

      return Right(saved);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
