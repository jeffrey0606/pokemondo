import 'language_config.dart';
import 'theming_configs.dart';

class StoredConfigs {
  static late LanguageConfigs languageConfigs;
  static Future<void> initBeforeRunApp() async {
    ///Initializing [AppTheme.config] from system or persisted data
    ThemingConfigs.config.value = await ThemingConfigs.extract();

    languageConfigs = await LanguageConfigs.extract();
  }
}
