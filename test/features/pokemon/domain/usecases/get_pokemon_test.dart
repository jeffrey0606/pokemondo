import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pokemondo/features/pokemon/domain/entities/named_pokemon.dart';
import 'package:pokemondo/features/pokemon/domain/entities/pokemon.dart';
import 'package:pokemondo/features/pokemon/domain/repositories/pokemon_repository.dart';
import 'package:pokemondo/features/pokemon/domain/usecases/get_pokemon.dart';

import 'get_pokemon_test.mocks.dart';

// class MockPokemonRepository extends Mock implements PokemonRepository {}
@GenerateMocks([PokemonRepository])
void main() {
  late GetPokemon usecase;
  late MockPokemonRepository mockPokemonRepository;

  setUp(() {
    mockPokemonRepository = MockPokemonRepository();
    usecase = GetPokemon(mockPokemonRepository);
  });

  const NamedPokemon tNamedPokemon = NamedPokemon(
    name: "bulbasaur",
    url: "https://pokeapi.co/api/v2/pokemon/1/",
  );
  Pokemon tPokemon = Pokemon(
    defense: 49,
    specialAttack: 65,
    specialDefense: 65,
    speed: 45,
    height: 7,
    weight: 69,
    hp: 45,
    attack: 49,
    id: 1,
    name: "bulbasaur",
    types: ["grass", "poison"],
    image:
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png",
  );

  test(
    "should get Pokemon for the NamedPokemon from the repository",
    () async {
      // arrange
      when(mockPokemonRepository.getPokemon(tNamedPokemon)).thenAnswer(
        (_) async => Right(tPokemon),
      );

      // act
      final result = await usecase(const Params(namedPokemon: tNamedPokemon));

      // assert
      expect(result, Right(tPokemon));
      verify(mockPokemonRepository.getPokemon(tNamedPokemon));
      verifyNoMoreInteractions(mockPokemonRepository);
    },
  );
}
