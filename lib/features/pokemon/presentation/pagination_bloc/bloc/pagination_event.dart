part of 'pagination_bloc.dart';

abstract class PaginationEvent extends Equatable {
  const PaginationEvent();
}

class GetPaginationPage extends PaginationEvent {
  final String url;
  final bool wait;

  const GetPaginationPage(this.url, {this.wait = false});

  @override
  List<Object> get props => [url];
}

class AddPokemon extends PaginationEvent {
  final Pokemon pokemon;

  const AddPokemon(this.pokemon);

  @override
  List<Object> get props => [pokemon];
}