part of 'pokemon_bloc.dart';

abstract class PokemonState extends Equatable {
  const PokemonState();

  @override
  List<Object> get props => [];
}

class Initial extends PokemonState {}

class Loading extends PokemonState {}

class Loaded extends PokemonState {
  final Pokemon pokemon;

  const Loaded(this.pokemon);

  @override
  List<Object> get props => [pokemon];
}

class PokemonError extends PokemonState {
  final String message;

  const PokemonError(this.message);

  @override
  List<Object> get props => [message];
}
