import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/display_icon.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/pokemon.dart';
import '../favourites_bloc/bloc/favourites_bloc.dart';
import '../pages/pokemon_details_page.dart';
import 'display_pokemon_colors_builder.dart';

class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;
  const PokemonCard({
    Key? key,
    required this.pokemon,
  }) : super(key: key);

  void goToDetails(BuildContext context, Pokemon pokemon) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider<FavouritesBloc>.value(
          value: serviceLocator<FavouritesBloc>(),
          child: PokemonDetailsPage(
            pokemon: pokemon,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.primary,
      borderRadius: BorderRadius.circular(4),
      child: InkWell(
        onTap: () => goToDetails(context, pokemon),
        splashColor: Theme.of(context).backgroundColor.withOpacity(1),
        highlightColor: Theme.of(context).backgroundColor.withOpacity(1),
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: CachedNetworkImage(
                imageUrl: pokemon.image,
                errorWidget: (context, url, error) {
                  return const DisplayIcon(
                    icon: Icons.image_not_supported_outlined,
                  );
                },
                imageBuilder: (context, imageProvider) {
                  return DiplayPokemonColorsBuilder(
                    pokemon: pokemon,
                    imageProvider: imageProvider,
                    builder: (context, imageColors) {
                      return DecoratedBox(
                        decoration: BoxDecoration(
                          color: pokemon.imageColors?.first.withOpacity(0.1),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4),
                          ),
                        ),
                        child: Stack(
                          children: [
                            Align(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 5,
                                ),
                                child: Hero(
                                  tag: "image-${pokemon.name}",
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: imageProvider,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            if (pokemon.imageColors != null)
                              Positioned(
                                bottom: 4,
                                right: 0,
                                child: SizedBox(
                                  width: 25,
                                  height: 12.5,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(4),
                                      bottomLeft: Radius.circular(4),
                                    ),
                                    child: Row(
                                      children: pokemon.imageColors!
                                          .map(
                                            (color) => Expanded(
                                              child: Container(
                                                color: color,
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                ),
                              )
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                  bottom: 8,
                  left: 8,
                  right: 8,
                  top: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Hero(
                            tag: "id-${pokemon.name}",
                            child: Text(
                              pokemon.formattedId,
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                          ),
                          Hero(
                            tag: "name-${pokemon.name}",
                            child: Text(
                              pokemon.name,
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Hero(
                      tag: "types-${pokemon.name}",
                      child: Text(
                        pokemon.formattedTypes,
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
