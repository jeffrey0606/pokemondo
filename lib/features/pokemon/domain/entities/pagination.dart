import 'package:equatable/equatable.dart';

import 'named_pokemon.dart';

class Pagination extends Equatable {
  final String? next;
  final String? previous;
  final bool isFromCache;
  final List<NamedPokemon> results;

  const Pagination({
    required this.next,
    required this.previous,
    required this.results,
    this.isFromCache = false,
  });

  Pagination fromCache() {
    return Pagination(
      next: next,
      previous: previous,
      results: results,
      isFromCache: true,
    );
  }

  @override
  List<Object?> get props => [next, previous];
}
