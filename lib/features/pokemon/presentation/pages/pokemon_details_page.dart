import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokemondo/core/ads/ads_state.dart';
import 'package:pokemondo/core/widgets/my_banner_ad.dart';
import '../widgets/base_stats_title.dart';
import '../widgets/display_pokemon_property.dart';
import '../widgets/favourite_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/widgets/display_icon.dart';
import '../../domain/entities/pokemon.dart';
import '../widgets/display_base_stats.dart';

class PokemonDetailsPage extends StatelessWidget {
  final Pokemon pokemon;
  const PokemonDetailsPage({
    Key? key,
    required this.pokemon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color? color = pokemon.imageColors?.first.withOpacity(0.1);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const DisplayIcon(
            icon: Icons.arrow_back_ios,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: color,
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          border: const Border(
            top: BorderSide(
              color: Color.fromRGBO(0, 0, 0, 0.05),
              width: 2,
            ),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              displayPokemonDetails(
                color,
                context,
              ),
              displayAllPokemonProperties(
                context,
              ),
              const SizedBox(
                height: 8,
              ),
              const BaseStatsTitle(),
              DisplayBaseStats(pokemon: pokemon)
            ],
          ),
        ),
      ),
      floatingActionButton: FavouriteButton(pokemon: pokemon),
      bottomNavigationBar: MyBannarAd(adUnit: AdState.detailsPageAdUnitId),
    );
  }

  Container displayPokemonDetails(Color? color, BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      color: color,
      child: Stack(
        children: [
          Positioned(
            bottom: -10,
            right: -25,
            child: SizedBox(
              width: 176,
              height: 176,
              child: Image.asset(
                "assets/images/vector.png",
                color: pokemon.imageColors?.last.withOpacity(0.3),
              ),
            ),
          ),
          Positioned(
            bottom: -4,
            right: 0,
            child: SizedBox(
              width: 176,
              height: 150,
              child: Hero(
                tag: "image-${pokemon.name}",
                child: CachedNetworkImage(
                  imageUrl: pokemon.image,
                  errorWidget: (context, url, error) {
                    return const DisplayIcon(
                      icon: Icons.image_not_supported_outlined,
                      size: 50,
                    );
                  },
                ),
              ),
            ),
          ),
          Align(
            child: Container(
              padding: const EdgeInsets.only(
                top: 23,
                bottom: 14,
                left: 16,
              ),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Hero(
                          tag: "name-${pokemon.name}",
                          child: Text(
                            pokemon.name,
                            style: Theme.of(context).textTheme.headline1,
                          ),
                        ),
                        Hero(
                          tag: "types-${pokemon.name}",
                          child: Text(
                            pokemon.formattedTypes,
                            style:
                                Theme.of(context).textTheme.headline3!.copyWith(
                                      fontWeight: FontWeight.w400,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Hero(
                    tag: "id-${pokemon.name}",
                    child: Text(
                      pokemon.formattedId,
                      style: Theme.of(context).textTheme.headline3!.copyWith(
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container displayAllPokemonProperties(BuildContext context) {
    return Container(
      height: 78,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 1),
            blurRadius: 4,
            spreadRadius: 0,
            color: Colors.black.withOpacity(0.05),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          DisplayPokemonProperty(
            property: AppLocalizations.of(context)!.height,
            value: pokemon.height.toString(),
            axis: Axis.vertical,
          ),
          const SizedBox(
            width: 48,
          ),
          DisplayPokemonProperty(
            property: AppLocalizations.of(context)!.weight,
            value: pokemon.weight.toString(),
            axis: Axis.vertical,
          ),
          const SizedBox(
            width: 48,
          ),
          DisplayPokemonProperty(
            property: AppLocalizations.of(context)!.bmi,
            value: pokemon.bmi.toString(),
            axis: Axis.vertical,
          ),
        ],
      ),
    );
  }
}
