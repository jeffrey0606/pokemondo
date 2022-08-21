import '../../domain/entities/pagination.dart';
import 'named_pokemon_model.dart';

class PaginationModel extends Pagination {
  const PaginationModel({
    required super.next,
    required super.previous,
    required super.results,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    final results = (List<Map<String, dynamic>>.from(json["results"]));

    return PaginationModel(
      next: json["next"],
      previous: json["previous"],
      results: results.map((e) => NamedPokemonModel.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "next": next,
      "previous": previous,
      "results": results.map((e) => (e as NamedPokemonModel).toJson()).toList()
    };
  }
}
