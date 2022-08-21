import '../../domain/entities/named_pokemon.dart';

class NamedPokemonModel extends NamedPokemon {
  const NamedPokemonModel({
    required super.name,
    required super.url,
  });

  factory NamedPokemonModel.fromJson(Map<String, dynamic> json) {
    return NamedPokemonModel(
      name: json["name"],
      url: json["url"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "url": url,
    };
  }
}
