import 'package:flutter/cupertino.dart';

import '../../../../core/utils/enums.dart';
import '../../../../core/utils/functions.dart';
import '../../domain/entities/pokemon.dart';

class DiplayPokemonColorsBuilder extends StatefulWidget {
  final Pokemon pokemon;
  final Widget Function(BuildContext context, List<Color>? imageColors) builder;
  final ImageProvider imageProvider;
  const DiplayPokemonColorsBuilder({
    Key? key,
    required this.pokemon,
    required this.builder,
    required this.imageProvider,
  }) : super(key: key);

  @override
  State<DiplayPokemonColorsBuilder> createState() =>
      _DiplayPokemonColorsBuilderState();
}

class _DiplayPokemonColorsBuilderState
    extends State<DiplayPokemonColorsBuilder> {
  late Future<List<Color>?> _getImageColors;

  @override
  void initState() {
    _getImageColors = setImageColors();
    super.initState();
  }

  Future<List<Color>?> setImageColors() async {
    if (widget.pokemon.imageColors != null) {
      return Future.value(widget.pokemon.imageColors);
    } else {
      try {
        final result = await getImageColors(
          widget.pokemon.image,
          ImageType.network,
          imageProvider: widget.imageProvider,
        );

        widget.pokemon.imageColors = result;

        return result;
      } catch (e) {
        return Future.value(null);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Color>?>(
      future: _getImageColors,
      builder: (context, snapshot) {
        return widget.builder(context, snapshot.data);
      },
      initialData: const [],
    );
  }
}
