import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemondo/core/utils/constants.dart';
import 'package:pokemondo/core/utils/enums.dart';
import 'package:pokemondo/core/widgets/loader.dart';
import 'package:pokemondo/features/pokemon/presentation/favourites_bloc/bloc/favourites_bloc.dart';
import 'package:pokemondo/features/pokemon/presentation/widgets/pokemon_card.dart';

class FavouritesPage extends StatelessWidget {
  const FavouritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavouritesBloc, FavouritesState>(
      builder: (context, state) {
        switch (state.status) {
          case FavouritesStatus.failed:
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  state.error.message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
            );
          case FavouritesStatus.initial:
          case FavouritesStatus.loading:
            return const Loader(
              height: 60,
              width: 60,
            );
          case FavouritesStatus.loaded:
            int len = state.pokemons.length;

            if (len <= 0) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "No Favourite Pokemons!",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ),
              );
            } else {
              return GridView.builder(
                gridDelegate: GRID_DELEGATE,
                padding: GRID_PADDING,
                itemBuilder: (context, index) {
                  return PokemonCard(pokemon: state.pokemons[index]);
                },
                itemCount: len,
              );
            }

          default:
            return Container();
        }
      },
    );
  }
}
