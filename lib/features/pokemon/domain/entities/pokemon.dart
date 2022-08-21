import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/utils/extensions.dart';

///
const int BASE_STATE_UPPER_LIMIT = 255;

class Pokemon extends Equatable {
  final int id;
  final String name;
  final List<String> types;
  final String image;
  final int height;
  final int weight;
  final int hp;
  final int attack;
  final int defense;
  final int specialAttack;
  final int specialDefense;
  final int speed;
  List<Color>? imageColors;

  double get bmi {
    return double.parse((weight / (height ^ 2)).toStringAsFixed(1));
  }

  int get avgPower {
    return (hp + attack + defense + specialAttack + specialDefense + speed) ~/
        6;
  }

  String get formattedTypes {
    return types
        .map(
          (type) => type.firstCharToUpperCase(),
        )
        .toList()
        .join(", ");
  }

  List<Map<String, dynamic>> stats(BuildContext context) {
    return [
      {
        "name": "Hp",
        "base_stat": hp,
        "special": false,
      },
      {
        "name": AppLocalizations.of(context)!.attack,
        "base_stat": attack,
        "special": false,
      },
      {
        "name": AppLocalizations.of(context)!.defense,
        "special": false,
        "base_stat": defense,
      },
      {
        "name": AppLocalizations.of(context)!.specialAttack,
        "base_stat": specialAttack,
        "special": true,
      },
      {
        "name": AppLocalizations.of(context)!.specialDefense,
        "base_stat": specialDefense,
        "special": true,
      },
      {
        "name": AppLocalizations.of(context)!.speed,
        "base_stat": speed,
        "special": false,
      },
      {
        "name": AppLocalizations.of(context)!.avgPower,
        "base_stat": avgPower,
        "special": false,
      },
    ];
  }

  String get formattedId {
    final int idLen = id.toString().length;

    final int numberOfZeros = 3 - idLen;

    final String zeros = List.generate(numberOfZeros, (index) => "0").join("");

    return "#$zeros$id";
  }

  Pokemon({
    required this.defense,
    required this.specialAttack,
    required this.specialDefense,
    required this.speed,
    required this.height,
    required this.weight,
    required this.hp,
    required this.attack,
    required this.id,
    required this.name,
    required this.types,
    required this.image,
    this.imageColors,
  });

  @override
  List<Object?> get props => [];
}
