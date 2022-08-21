import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageConfigs {
  final Locale? locale;
  LanguageConfigs({
    this.locale,
  });

  LanguageConfigs.fromJson(Map json) : locale = Locale(json['languageCode']);

  Map toJson() {
    return {
      'languageCode': locale!.languageCode,
    };
  }

  static const String Config_Name = 'LanguageConfigs';

  static Future<LanguageConfigs> store(LanguageConfigs newLanguage) async {
    final String data = jsonEncode(
      newLanguage.toJson(),
    );

    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(Config_Name, data);

    return newLanguage;
  }

  static Future<LanguageConfigs> extract() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey(Config_Name)) {
      return LanguageConfigs();
    }
    final Map data = jsonDecode((prefs.get(Config_Name)).toString());

    return LanguageConfigs.fromJson(data);
  }
}
