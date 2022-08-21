import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../injection_container.dart';
import '../../domain/entities/pokemon.dart';
import '../favourites_bloc/bloc/favourites_bloc.dart';

class FavouriteButton extends StatelessWidget {
  final Pokemon pokemon;
  const FavouriteButton({
    Key? key,
    required this.pokemon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocSelector<FavouritesBloc, FavouritesState, bool>(
      selector: (state) {
        try {
          state.pokemons.firstWhere(
            (element) => element.id == pokemon.id,
          );
          return true;
        } catch (e) {
          return false;
        }
      },
      builder: (context, isFavorite) {
        return TextButton(
          onPressed: () {
            if (isFavorite) {
              serviceLocator<FavouritesBloc>().add(
                RemovePokemonFromFavourites(pokemon.id),
              );
            } else {
              serviceLocator<FavouritesBloc>().add(
                AddPokemonToFavourites(pokemon),
              );
            }
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              isFavorite
                  ? const Color(0xffD5DEFF)
                  : Theme.of(context).colorScheme.secondary,
            ),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(36)),
            ),
            padding: MaterialStateProperty.all(
              const EdgeInsets.all(16),
            ),
            elevation: MaterialStateProperty.all(8),
          ),
          child: Text(
            isFavorite
                ? AppLocalizations.of(context)!.removeFromFav
                : AppLocalizations.of(context)!.addToFav,
            style: TextStyle(
              color: isFavorite
                  ? Theme.of(context).colorScheme.secondary
                  : Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        );
      },
    );
  }
}
