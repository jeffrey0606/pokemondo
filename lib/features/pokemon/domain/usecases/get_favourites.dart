import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../entities/pokemon.dart';
import '../repositories/pokemon_repository.dart';

class GetFavourites extends UseCase<List<Pokemon>, NoParams> {
  final PokemonRepository repository;

  GetFavourites(this.repository);
  @override
  Future<Either<Failure, List<Pokemon>>> call(NoParams params) async {
    return await repository.getFavourites();
  }
}

class NoParams {
  
}