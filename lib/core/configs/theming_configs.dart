import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/enums.dart';
import '../utils/extensions.dart';

class ThemingConfigs {
  final ThemeMode mode;
  final AppThemeMode appMode;

  static ValueNotifier<ThemingConfigs?> config = ValueNotifier(null);

  ThemingConfigs({
    required this.appMode,
    required this.mode,
  });

  ThemingConfigs.fromJson(Map json)
      : appMode = json['appMode'].toString().toAppThemeMode,
        mode = json['mode'].toString().toThemeMode;

  Map toJson() {
    return {
      'mode': mode.name,
      'appMode': appMode.name,
    };
  }

  static const String Config_Name = 'ThemingConfigs';

  static Future<ThemingConfigs> store(ThemingConfigs newTheme) async {
    final String data = jsonEncode(
      newTheme.toJson(),
    );

    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(Config_Name, data);

    return newTheme;
  }

  static Future<ThemingConfigs> extract() async {
    final prefs = await SharedPreferences.getInstance();
    final ThemeMode mode = getSystemThemeMode();

    if (!prefs.containsKey(Config_Name)) {
      AppThemeMode appMode;
      if (mode == ThemeMode.dark) {
        appMode = AppThemeMode.dark;
      } else {
        appMode = AppThemeMode.light;
      }
      ThemingConfigs themingConfigs = ThemingConfigs(
        appMode: appMode,
        mode: mode,
      );

      return themingConfigs;
    } else if (mode == ThemeMode.dark) {
      return ThemingConfigs(
        appMode: AppThemeMode.dark,
        mode: mode,
      );
    }
    final Map data = jsonDecode((prefs.get(Config_Name)).toString());

    return ThemingConfigs.fromJson(data);
  }

  static void listenChanges() {
    var window = WidgetsBinding.instance.window;

    // This callback is called every time the brightness changes.
    window.onPlatformBrightnessChanged = () async {
      WidgetsBinding.instance.handlePlatformBrightnessChanged();
      var brightness = window.platformBrightness;
      bool isDarkMode = brightness == Brightness.dark;

      switchTheme(isDarkMode ? ThemeMode.dark : ThemeMode.light);

      // callback.call();
    };
  }

  static switchTheme(ThemeMode themeMode) async {

    if(themeMode == config.value!.mode) {
      return;
    }
    AppThemeMode appMode;
    ThemeMode mode = themeMode;
    if (mode == ThemeMode.dark) {
      appMode = AppThemeMode.dark;
    } else {
      appMode = AppThemeMode.light;
    }
    ThemingConfigs themingConfigs = ThemingConfigs(
      appMode: appMode,
      mode: mode,
    );

    ThemingConfigs.config.value = themingConfigs;

    await ThemingConfigs.store(themingConfigs);
  }
}

ThemeMode getSystemThemeMode() {
  var brightness = SchedulerBinding.instance.window.platformBrightness;
  bool isDarkMode = brightness == Brightness.dark;

  if (isDarkMode) {
    return ThemeMode.dark;
  } else {
    return ThemeMode.light;
  }
}
