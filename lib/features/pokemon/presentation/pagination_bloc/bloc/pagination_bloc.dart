import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/utils/constants.dart';
import '../../../../../core/utils/enums.dart';
import '../../../../../core/utils/show_toast.dart';
import '../../../domain/entities/named_pokemon.dart';
import '../../../domain/entities/pagination.dart';
import '../../../domain/entities/pokemon.dart';
import '../../../domain/usecases/get_page.dart';

part 'pagination_event.dart';
part 'pagination_state.dart';

const String SERVER_FAILURE_MESSAGE =
    "Server Failure when getting a page of Pokemons";
const String CACHE_FAILURE_MESSAGE =
    "Cache Failure when getting a page of Pokemons";

class PaginationBloc extends Bloc<PaginationEvent, PaginationState> {
  GetPage getPage;

  PaginationBloc({
    required this.getPage,
  }) : super(const PaginationState()) {
    on<PaginationEvent>((event, emit) async {
      if (event is GetPaginationPage) {
        await handleGattingNewPage(emit, event);
      } else if (event is AddPokemon) {
        emit(
          state.copyWith(
            pokemons: () => [...state.pokemons, event.pokemon],
          ),
        );
      }
    });
  }

  Future<void> handleGattingNewPage(
      Emitter<PaginationState> emit, GetPaginationPage event) async {
    emit(state.copyWith(status: () => PaginationStatus.loading));

    if (event.wait) {
      //This is to wait a little when the user is scrolling
      //to load more content so he sees the loaing spinner
      await Future.delayed(
        const Duration(
          seconds: 5,
        ),
      );
    }
    late Either<Failure, Pagination> failureOrPokemon;

    if (state.isCache == null) {
      failureOrPokemon = await getPage(const Params(url: FRIST_PAGE_URL));
    } else {
      failureOrPokemon = await getPage(Params(url: event.url));
    }

    final result = failureOrPokemon.fold(
      (failure) => state.copyWith(
        error: () => Error(
          _mapFailureToMessage(failure),
        ),
        status: () => PaginationStatus.failed,
      ),
      (pagination) => state.copyWith(
        status: () => PaginationStatus.loaded,
        namedPokemons: () {
          if (state.isCache == null && pagination.isFromCache ||
              state.isCache == null && !pagination.isFromCache) {
            if (pagination.isFromCache) {
              showToast(
                  message: "No Internet Connection! data loaded from cache",
                  type: ToastMessageType.error);
            } else {
              showToast(
                  message: "data loaded with success",
                  type: ToastMessageType.success);
            }

            return pagination.results;
          }
          if (state.isCache! && pagination.isFromCache) {
            return state.namedPokemons;
          }

          if (state.isCache! && !pagination.isFromCache) {
            showToast(
                message:
                    "Internet Connection Available! data loaded successfully",
                type: ToastMessageType.success,
                duration: 2);
            return [...state.namedPokemons, ...pagination.results];
          }

          if (!state.isCache! && !pagination.isFromCache) {
            return [...state.namedPokemons, ...pagination.results];
          }

          if (!state.isCache! && pagination.isFromCache) {
            showToast(
                message: "No Internet Connection! data loaded from cache",
                type: ToastMessageType.error);
            return state.namedPokemons;
          }
          return state.namedPokemons;
        },
        isCache: () => pagination.isFromCache,
        nextUrl: pagination.isFromCache ? null : () => pagination.next,
        prevUrl: pagination.isFromCache ? null : () => pagination.previous,
      ),
    );

    emit(result);
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
