import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../configs/theming_configs.dart';
import '../utils/enums.dart';

class AppTheme {
  static String? fontFamily = GoogleFonts.notoSans().fontFamily;

  static ThemeData dark() {
    return AppColorScheme.dark().toTheme;
  }

  static ThemeData light() {
    return AppColorScheme.light().toTheme;
  }
}

List<AppThemeMode> supportedThemes = AppThemeMode.values
    .where(
      (element) => element != AppThemeMode.system,
    )
    .toList();

class AppColorScheme {
  static FlexColorScheme defaultColor = lightColor;

  static SystemUiOverlayStyle darkSystemUiOverlayStyle = SystemUiOverlayStyle(
    systemNavigationBarColor: darkColor.background,
    statusBarColor: darkColor.primary,
    statusBarIconBrightness: Brightness.light,
  );
  static SystemUiOverlayStyle lightSystemUiOverlayStyle = SystemUiOverlayStyle(
    systemNavigationBarColor: lightColor.background,
    statusBarColor: lightColor.primary,
    statusBarIconBrightness: Brightness.dark,
  );

  static FlexColorScheme darkColor = FlexColorScheme(
    primary: const Color(0xff161A33),
    secondary: const Color(0xff3558CD),
    background: const Color(0xff171817),
    appBarBackground: const Color(0xff161A33),
    fontFamily: AppTheme.fontFamily,
    textTheme: const TextTheme(
      headline1: TextStyle(
        color: Color(0xffffffff),
        fontSize: 32,
        fontWeight: FontWeight.w700,
      ),
      headline2: TextStyle(
        color: Color(0xffffffff),
        fontWeight: FontWeight.w700,
        fontSize: 24,
      ),
      headline3: TextStyle(
        color: Color(0xffffffff),
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      headline4: TextStyle(
        color: Color(0xffffffff),
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      button: TextStyle(
        color: Color(0xff000000),
        fontSize: 18,
      ),
      subtitle2: TextStyle(
        color: Color(0xff6B6B6B),
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      subtitle1: TextStyle(
        color: Color(0xffffffff),
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  static FlexColorScheme lightColor = FlexColorScheme(
    primary: const Color(0xffffffff),
    secondary: const Color(0xff3558CD),
    background: const Color(0xffE8E8E8),
    appBarBackground: const Color(0xffffffff),
    fontFamily: AppTheme.fontFamily,
    textTheme: const TextTheme(
      headline1: TextStyle(
        color: Color(0xff161A33),
        fontSize: 32,
        fontWeight: FontWeight.w700,
      ),
      headline2: TextStyle(
        color: Color(0xff161A33),
        fontWeight: FontWeight.w700,
        fontSize: 24,
      ),
      headline3: TextStyle(
        color: Color(0xff161A33),
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      headline4: TextStyle(
        color: Color(0xff161A33),
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      button: TextStyle(
        color: Color(0xff000000),
        fontSize: 18,
      ),
      subtitle2: TextStyle(
        color: Color(0xff6B6B6B),
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      subtitle1: TextStyle(
        color: Color(0xff161A33),
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  static FlexColorScheme light() {
    print('light');

    // return defaultColor;
    if (ThemingConfigs.config.value?.mode == ThemeMode.system) {
      return lightColor;
    } else {
      return switchScheme();
    }
  }

  static FlexColorScheme dark() {
    print('dark');

    // return defaultColor;
    if (ThemingConfigs.config.value?.mode == ThemeMode.system) {
      return darkColor;
    } else {
      return switchScheme();
    }
  }

  static FlexColorScheme switchScheme() {
    switch (ThemingConfigs.config.value?.appMode) {
      case AppThemeMode.light:
        return lightColor;
      case AppThemeMode.dark:
        return darkColor;
      default:
        return lightColor;
    }
  }
}
