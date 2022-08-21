import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../repositories/pokemon_repository.dart';

class RemoveFromFavourites extends UseCase<bool, RemoveParams> {
  final PokemonRepository repository;

  RemoveFromFavourites(this.repository);

  @override
  Future<Either<Failure, bool>> call(RemoveParams params) async {
    return await repository.removeFromFavourites(params.id);
  }
}

class RemoveParams extends Equatable {
  final int id;

  const RemoveParams(this.id);

  @override
  List<Object?> get props => [id];
}
