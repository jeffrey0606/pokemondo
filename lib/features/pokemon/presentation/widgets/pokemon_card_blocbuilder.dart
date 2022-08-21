import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/loader.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/named_pokemon.dart';
import '../../domain/entities/pokemon.dart';
import '../pagination_bloc/bloc/pagination_bloc.dart';
import '../pokemon_bloc/bloc/pokemon_bloc.dart';
import 'pokemon_card.dart';

class PokemonCardBlocBuilder extends StatelessWidget {
  final NamedPokemon namedPokemon;
  const PokemonCardBlocBuilder({
    Key? key,
    required this.namedPokemon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocSelector<PaginationBloc, PaginationState, Pokemon?>(
      selector: (state) {
        try {
          final pokemon = state.pokemons.firstWhere(
            (element) => namedPokemon.name == element.name,
          );
          return pokemon;
        } catch (e) {
          return null;
        }
      },
      builder: (context, pokemon) {
        if (pokemon == null) {
          return BlocProvider<PokemonBloc>(
            create: (context) => serviceLocator<PokemonBloc>()
              ..add(
                GetPokemonForDetails(namedPokemon),
              ),
            child: BlocConsumer<PokemonBloc, PokemonState>(
              listener: (context, state) {
                if (state is Loaded) {
                  serviceLocator<PaginationBloc>().add(
                    AddPokemon(state.pokemon),
                  );
                }
              },
              builder: (context, state) {
                if (state is Initial) {
                  return Container();
                } else if (state is Loading) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: const Loader(
                      height: 35,
                      width: 35,
                    ),
                  );
                } else if (state is PokemonError) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: Center(
                      child: Text(
                        state.message,
                        style: Theme.of(context).textTheme.subtitle2,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                } else if (state is Loaded) {
                  return PokemonCard(
                    pokemon: state.pokemon,
                  );
                } else {
                  return Container();
                }
              },
            ),
          );
        } else {
          return PokemonCard(
            pokemon: pokemon,
          );
        }
      },
    );
  }
}
