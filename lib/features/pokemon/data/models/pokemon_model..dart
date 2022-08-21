import '../../../../core/utils/extensions.dart';
import '../../domain/entities/pokemon.dart';

class PokemonModel extends Pokemon {
  PokemonModel({
    required super.defense,
    required super.specialAttack,
    required super.specialDefense,
    required super.speed,
    required super.height,
    required super.weight,
    required super.hp,
    required super.attack,
    required super.id,
    required super.name,
    required super.types,
    required super.image,
    super.imageColors,
  });

  factory PokemonModel.fromPokemon(Pokemon pokemon) {
    return PokemonModel(
      defense: pokemon.defense,
      specialAttack: pokemon.specialAttack,
      specialDefense: pokemon.specialDefense,
      speed: pokemon.speed,
      height: pokemon.height,
      weight: pokemon.weight,
      hp: pokemon.hp,
      attack: pokemon.attack,
      id: pokemon.id,
      name: pokemon.name,
      types: pokemon.types,
      image: pokemon.image,
      imageColors: pokemon.imageColors,
    );
  }

  factory PokemonModel.fromJson(Map<String, dynamic> json) {
    if (!json.containsKey("stats")) {
      return PokemonModel(
        defense: json["defense"],
        specialAttack: json["special-attack"],
        specialDefense: json["special-defense"],
        speed: json["speed"],
        height: json["height"],
        weight: json["weight"],
        hp: json["hp"],
        attack: json["attack"],
        id: json["id"],
        name: json["name"],
        types: List<String>.from(json["types"]),
        image: json["image"],
        imageColors:
            json.containsKey("imageColors") && json["imageColors"] != null
                ? (List<String>.from(json["imageColors"])).colors
                : null,
      );
    }
    final List<Map<String, dynamic>> stats =
        List<Map<String, dynamic>>.from(json["stats"]);

    final List<String> types =
        (List<Map<String, dynamic>>.from(json["types"])).map((type) {
      return type["type"]["name"].toString();
    }).toList();

    return PokemonModel(
      defense: stats.getBaseStat("defense"),
      specialAttack: stats.getBaseStat("special-attack"),
      specialDefense: stats.getBaseStat("special-defense"),
      speed: stats.getBaseStat("speed"),
      height: json["height"],
      weight: json["weight"],
      hp: stats.getBaseStat("hp"),
      attack: stats.getBaseStat("attack"),
      id: json["id"],
      name: json["name"],
      types: types,
      image: json["sprites"]["other"]["official-artwork"]["front_default"],
      imageColors: null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "defense": defense,
      "special-attack": specialAttack,
      "special-defense": specialDefense,
      "speed": speed,
      "height": height,
      "weight": weight,
      "hp": hp,
      "attack": attack,
      "id": id,
      "name": name,
      "types": types,
      "image": image,
      "imageColors": imageColors?.colors,
    };
  }
}
