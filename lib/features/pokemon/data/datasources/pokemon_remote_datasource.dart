import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/named_pokemon.dart';
import '../models/pokemon_model..dart';

abstract class PokemonRemoteDataSource {
  ///Calls the https://pokeapi.co/api/v2/pokemon/{id}/ endpoint.
  ///
  ///Throws a [ServerException] for all error codes.
  Future<PokemonModel> getPokemon(NamedPokemon namedPokemon);
}

class PokemonRemoteDataSourceImpl extends PokemonRemoteDataSource {
  final http.Client client;

  PokemonRemoteDataSourceImpl({
    required this.client,
  });

  @override
  Future<PokemonModel> getPokemon(NamedPokemon namedPokemon) async {
    final response = await client.get(Uri.parse(namedPokemon.url));

    if (response.statusCode == 200) {
      return PokemonModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
