import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../theme/app_theme.dart';
import 'enums.dart';
import 'functions.dart';

extension ExtentsPokemonModel on List<Map<String, dynamic>> {
  int getBaseStat(String name) {
    return firstWhere((stat) => stat["stat"]["name"] == name)["base_stat"];
  }
}

extension ExtentAppTabs on AppTabs {
  String translate(BuildContext context) {
    switch (this) {
      case AppTabs.allPokemons:
        return AppLocalizations.of(context)!.allPokemons;
      case AppTabs.favourites:
        return AppLocalizations.of(context)!.favourites;
      default:
        return '';
    }
  }
}

extension ExtentLocal on Locale {
  String countryName(BuildContext context) {
    switch (languageCode) {
      case "fr":
        return AppLocalizations.of(context)!.fr;
      case "en":
        return AppLocalizations.of(context)!.en;
      default:
        return AppLocalizations.of(context)!.en;
    }
  }
}

extension ExtentThemeMode on String {
  ThemeMode get toThemeMode {
    switch (this) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}

extension ExtentAppThemeMode1 on String {
  AppThemeMode get toAppThemeMode {
    switch (this) {
      case 'light':
        return AppThemeMode.light;
      case 'dark':
        return AppThemeMode.dark;
      case 'system':
        return AppThemeMode.system;
      default:
        return AppThemeMode.system;
    }
  }
}

extension ExtentColorsString on List<String> {
  List<Color> get colors {
    return map((hexColor) => Color(int.parse("0xff$hexColor"))).toList();
  }
}

extension ExtentColors on List<Color> {
  List<String> get colors {
    return map((color) => getColorHex(color)).toList();
  }
}

extension ToUpperCase on String {
  firstCharToUpperCase() {
    return this[0].toUpperCase() + replaceRange(0, 1, "");
  }
}

extension ExtentAppThemeMode on AppThemeMode {
  String translate(BuildContext context) {
    switch (this) {
      case AppThemeMode.dark:
        return AppLocalizations.of(context)!.dark;
      case AppThemeMode.light:
        return AppLocalizations.of(context)!.light;
      default:
        return '';
    }
  }

  SystemUiOverlayStyle get systemUiOverlayStyle {
    switch (this) {
      case AppThemeMode.dark:
        return AppColorScheme.darkSystemUiOverlayStyle;
      case AppThemeMode.light:
        return AppColorScheme.lightSystemUiOverlayStyle;
      default:
        return AppColorScheme.lightSystemUiOverlayStyle;
    }
  }
}

extension ExtentText on Text {
  Size size(
    Size availableWidth, {
    double extra = 0,
  }) {
    TextSpan textSpan = TextSpan(
      text: data,
      style: style,
    );

    TextPainter painter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    painter.layout(
      maxWidth: availableWidth.width,
      minWidth: 0,
    );

    final Size size = Size(
      painter.width + extra,
      painter.height + extra,
    );

    log('text size: $size');

    return size;
  }
}


extension ExtextToastMessageType on ToastMessageType {
  Color get color {
    switch (this) {
      case ToastMessageType.error:
        return Colors.red;
      case ToastMessageType.info:
        return const Color(0xff3558CD);
      case ToastMessageType.success:
        return Colors.green.shade400;
      default:
        return Colors.orange;
    }
  }
}