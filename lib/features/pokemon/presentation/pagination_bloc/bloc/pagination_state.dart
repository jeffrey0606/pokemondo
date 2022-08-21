part of 'pagination_bloc.dart';

class PaginationState extends Equatable {
  final PaginationStatus status;
  final List<NamedPokemon> namedPokemons;
  final List<Pokemon> pokemons;
  final String? nextUrl;
  final String? prevUrl;
  final Error error;
  final bool? isCache;

  const PaginationState({
    this.status = PaginationStatus.initial,
    this.namedPokemons = const [],
    this.pokemons = const [],
    this.isCache,
    this.nextUrl,
    this.error = const Error.no(),
    this.prevUrl,
  });

  PaginationState copyWith({
    PaginationStatus Function()? status,
    List<NamedPokemon> Function()? namedPokemons,
    List<Pokemon> Function()? pokemons,
    String? Function()? nextUrl,
    String? Function()? prevUrl,
    Error Function()? error,
    bool? Function()? isCache,
  }) {
    if (error != null) {
      showToast(message: error().message, type: ToastMessageType.error);
    } else if (isCache != null && isCache()!) {
      showToast(message: "No Internet Connection! data loaded from cache", type: ToastMessageType.error);
    }
    return PaginationState(
      error: error != null ? error() : this.error,
      namedPokemons:
          namedPokemons != null ? namedPokemons() : this.namedPokemons,
      nextUrl: nextUrl != null ? nextUrl() : this.nextUrl,
      prevUrl: prevUrl != null ? prevUrl() : this.prevUrl,
      status: status != null ? status() : this.status,
      pokemons: pokemons != null ? pokemons() : this.pokemons,
      isCache: isCache != null ? isCache() : this.isCache,
    );
  }

  @override
  List<Object> get props => [
        status,
        namedPokemons,
        pokemons,
        nextUrl ?? "",
        error,
        prevUrl ?? "",
        isCache ?? false,
      ];
}

class Error extends Equatable {
  final String message;

  const Error(this.message);

  const Error.no() : message = "";

  @override
  List<Object> get props => [message];
}
