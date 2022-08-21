part of 'pokemon_bloc.dart';

abstract class PokemonEvent extends Equatable {
  const PokemonEvent();
}

class GetPokemonForDetails extends PokemonEvent {
  final NamedPokemon namedPokemon;

  const GetPokemonForDetails(this.namedPokemon);

  @override
  List<Object> get props => [namedPokemon];
}