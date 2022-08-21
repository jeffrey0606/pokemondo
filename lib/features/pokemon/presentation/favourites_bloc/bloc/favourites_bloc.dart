import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/enums.dart';
import '../../../../../core/utils/show_toast.dart';
import '../../../domain/entities/pokemon.dart';
import '../../../domain/usecases/get_favourites.dart';
import '../../../domain/usecases/remove_from_favourites.dart';
import '../../../domain/usecases/save_to_favourites.dart';

part 'favourites_event.dart';
part 'favourites_state.dart';

const String CACHE_FAIL_TO_SAVE = "Failed to save";
const String CACHE_FAIL_TO_REMOVE = "Failed to remove";
const String CACHE_FAIL_TO_GET = "Failed to get favourites";

class FavouritesBloc extends Bloc<FavouritesEvent, FavouritesState> {
  final SaveToFavourites saveToFavourites;
  final RemoveFromFavourites removeFromFavourites;
  final GetFavourites getFavourites;
  FavouritesBloc({
    required this.saveToFavourites,
    required this.removeFromFavourites,
    required this.getFavourites,
  }) : super(const FavouritesState()) {
    on<FavouritesEvent>((event, emit) async {
      if (event is AddPokemonToFavourites) {
        await _handleAddingFavourites(emit, event);
      } else if (event is RemovePokemonFromFavourites) {
        await _handleRemovingFavourites(emit, event);
      } else if (event is GetAllFavourites) {
        await _handleGettingAllFavourites(emit);
      }
    });
  }

  Future<void> _handleGettingAllFavourites(
      Emitter<FavouritesState> emit) async {
    emit(state.copyWith(status: () => FavouritesStatus.loading));

    final failureOrFavourites = await getFavourites(NoParams());

    final result = failureOrFavourites.fold(
      (failure) => state.copyWith(
        status: () => FavouritesStatus.failed,
        error: () => const Error(CACHE_FAIL_TO_GET),
      ),
      (favourites) => state.copyWith(
        status: () => FavouritesStatus.loaded,
        pokemons: () => favourites,
      ),
    );

    emit(result);
  }

  Future<void> _handleRemovingFavourites(
      Emitter<FavouritesState> emit, RemovePokemonFromFavourites event) async {
    emit(state.copyWith(actionStatus: () => FavouritesActionStatus.removing));

    emit(
      state.copyWith(
        pokemons: () => state.pokemons
            .where(
              (element) => event.id != element.id,
            )
            .toList(),
      ),
    );

    final failureOrRemoved = await removeFromFavourites(RemoveParams(event.id));

    final result = failureOrRemoved.fold(
      (failure) => state.copyWith(
        actionStatus: () => FavouritesActionStatus.failed,
        error: () => const Error(CACHE_FAIL_TO_REMOVE),
      ),
      (removed) => state.copyWith(
        actionStatus: () => FavouritesActionStatus.inactive,
      ),
    );

    emit(result);
  }

  Future<void> _handleAddingFavourites(
      Emitter<FavouritesState> emit, AddPokemonToFavourites event) async {
    emit(state.copyWith(
      actionStatus: () => FavouritesActionStatus.adding,
      pokemons: () => [...state.pokemons, event.pokemon],
    ));
    final failureOrSaved =
        await saveToFavourites(SaveParams(pokemons: state.pokemons));

    final result = failureOrSaved.fold(
      (failure) => state.copyWith(
        actionStatus: () => FavouritesActionStatus.failed,
        error: () => const Error(CACHE_FAIL_TO_SAVE),
      ),
      (saved) => state.copyWith(
        actionStatus: () => FavouritesActionStatus.inactive,
      ),
    );
    log("result: $result");
    emit(result);
  }
}
