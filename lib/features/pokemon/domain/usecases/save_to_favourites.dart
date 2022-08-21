import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:pokemondo/core/error/failures.dart';
import 'package:pokemondo/core/usecases/usecases.dart';
import 'package:pokemondo/features/pokemon/domain/entities/pokemon.dart';
import 'package:pokemondo/features/pokemon/domain/repositories/pokemon_repository.dart';

class SaveToFavourites extends UseCase<bool, SaveParams> {
  final PokemonRepository repository;

  SaveToFavourites(this.repository);

  @override
  Future<Either<Failure, bool>> call(SaveParams params) async {
    return await repository.saveToFavourites(params.pokemons);
  }
}

class SaveParams extends Equatable {
  final List<Pokemon> pokemons;

  const SaveParams({
    required this.pokemons,
  });

  @override
  List<Object?> get props => [pokemons];
}
