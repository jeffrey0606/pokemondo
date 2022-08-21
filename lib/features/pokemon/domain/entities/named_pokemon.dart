import 'package:equatable/equatable.dart';

///[NamedPokemon] represents the NamedAPIResource (type)
class NamedPokemon extends Equatable {
  final String name;
  final String url;

  const NamedPokemon({
    required this.name,
    required this.url,
  });

  @override
  List<Object?> get props => [name, url];
}
