import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/named_pokemon.dart';
import '../entities/pokemon.dart';

abstract class PokemonRepository {
  Future<Either<Failure, Pokemon>> getPokemon(NamedPokemon namedPokemon);

  Future<Either<Failure, bool>> saveToFavourites(List<Pokemon> pokemons);

  Future<Either<Failure, List<Pokemon>>> getFavourites();

  Future<Either<Failure, bool>> removeFromFavourites(int id);
}
 