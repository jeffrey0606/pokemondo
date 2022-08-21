import 'package:flutter/material.dart';

import '../../../../core/custom_paints/paint_stats_progress_bar.dart';
import '../../domain/entities/pokemon.dart';
import 'display_pokemon_property.dart';

class DisplayBaseStats extends StatelessWidget {
  const DisplayBaseStats({
    Key? key,
    required this.pokemon,
  }) : super(key: key);

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.primary,
      width: double.infinity,
      child: Column(
        children: pokemon.stats(context).map((stat) {
          return Padding(
            padding: const EdgeInsets.only(
              bottom: 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DisplayPokemonProperty(
                  property: stat["name"],
                  value: stat["base_stat"].toString(),
                  axis: Axis.horizontal,
                  hGap: 4,
                ),
                const SizedBox(
                  height: 8,
                ),
                AnimateStatsProgress(
                  special: stat["special"],
                  percentage: stat["base_stat"] / BASE_STATE_UPPER_LIMIT,
                )
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class AnimateStatsProgress extends StatefulWidget {
  const AnimateStatsProgress({
    Key? key,
    required this.percentage,
    required this.special,
  }) : super(key: key);

  final bool special;
  final double percentage;

  @override
  State<AnimateStatsProgress> createState() => _AnimateStatsProgressState();
}

class _AnimateStatsProgressState extends State<AnimateStatsProgress>
    with SingleTickerProviderStateMixin {
  late Animation animation;
  late AnimationController controller;
  late Tween<double> percentageTween;

  bool once = true;

  @override
  void didChangeDependencies() async {
    if (once) {
      controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      );

      percentageTween = Tween<double>(
        begin: 0,
        end: widget.percentage,
      );

      animation = percentageTween.animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.linear,
        ),
      );

      await Future.delayed(
        const Duration(milliseconds: 600),
      );

      controller.forward();

      once = false;
    }
    super.didChangeDependencies();
  }

  Color get getProgressColor {
    if (widget.special) {
      return const Color(0xffEEC218);
    } else {
      return const Color(0xffCD2873);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 4,
      width: double.infinity,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return CustomPaint(
            painter: PaintStatsProgressBar(
              percentage: animation.value,
              color: getProgressColor,
              bgColor: Theme.of(context).colorScheme.background,
            ),
          );
        },
      ),
    );
  }
}
