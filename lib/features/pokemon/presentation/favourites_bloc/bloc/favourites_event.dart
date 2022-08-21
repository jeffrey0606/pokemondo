part of 'favourites_bloc.dart';

abstract class FavouritesEvent extends Equatable {
  const FavouritesEvent();
}

class AddPokemonToFavourites extends FavouritesEvent {
  final Pokemon pokemon;

  const AddPokemonToFavourites(this.pokemon);

  @override
  List<Object?> get props => [pokemon];
}

class RemovePokemonFromFavourites extends FavouritesEvent {
  final int id;

  const RemovePokemonFromFavourites(this.id);

  @override
  List<Object?> get props => [id];
}

class GetAllFavourites extends FavouritesEvent {
  @override
  List<Object?> get props => [];
}
