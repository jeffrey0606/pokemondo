import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../entities/named_pokemon.dart';
import '../entities/pokemon.dart';
import '../repositories/pokemon_repository.dart';

class GetPokemon implements UseCase<Pokemon, Params> {
  final PokemonRepository repository;

  GetPokemon(this.repository);

  @override
  Future<Either<Failure, Pokemon>> call(Params params) async {
    return await repository.getPokemon(params.namedPokemon);
  }
}

class Params extends Equatable {
  final NamedPokemon namedPokemon;

  const Params({
    required this.namedPokemon,
  });
  
  @override
  List<Object?> get props => [namedPokemon];
}