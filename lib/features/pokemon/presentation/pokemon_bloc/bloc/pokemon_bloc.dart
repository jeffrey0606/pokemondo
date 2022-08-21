import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failures.dart';
import '../../../domain/entities/named_pokemon.dart';
import '../../../domain/entities/pokemon.dart';
import '../../../domain/usecases/get_pokemon.dart';

part 'pokemon_event.dart';
part 'pokemon_state.dart';

const String SERVER_FAILURE_MESSAGE =
    "Server Failure when getting Pokemon Datails";
const String CACHE_FAILURE_MESSAGE =
    " Cache Failure when getting Pokemon Datails";

class PokemonBloc extends Bloc<PokemonEvent, PokemonState> {
  final GetPokemon getPokemon;

  PokemonBloc({
    required this.getPokemon,
  }) : super(Initial()) {
    on<PokemonEvent>(
      (event, emit) async {
        // await Future.delayed(Duration(seconds: 5));
        emit(Initial());
        if (event is GetPokemonForDetails) {
          emit(Loading());
          final failureOrPokemon =
              await getPokemon(Params(namedPokemon: event.namedPokemon));
          final result = failureOrPokemon.fold(
            (failure) => PokemonError(
              _mapFailureToMessage(failure),
            ),
            (pokemon) => Loaded(pokemon),
          );

          emit(result);
        }
      },
      transformer: concurrent(),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return "Unexpected error";
    }
  }
}
