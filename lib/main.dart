import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'core/app/app.dart';
import 'core/app_lang/app_lang_widget.dart';
import 'core/configs/stored_configs.dart';
import 'core/configs/theming_configs.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/extensions.dart';
import 'core/widgets/splash_screen.dart';
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.remove();
  await initServices();
  await StoredConfigs.initBeforeRunApp();
  MobileAds.instance.initialize();
  runApp(
    const SplashScreen(
      myApp: MyApp(),
      duration: Duration(
        seconds: 2,
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    _updateAppTheme();
    ThemingConfigs.listenChanges();
    ThemingConfigs.config.addListener(() {
      _updateAppTheme();
    });
    super.initState();
  }

  void _updateAppTheme() {
    SystemChrome.setSystemUIOverlayStyle(
      ThemingConfigs.config.value!.appMode.systemUiOverlayStyle,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AppLangWidgetBuilder(
      appLanBuilder: (context, lan) {
        return MaterialApp(
          title: 'Pokemondo',
          locale: lan.locale,
          themeMode: ThemingConfigs.config.value?.mode,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          debugShowCheckedModeBanner: false,
          home: const App(),
        );
      },
    );
  }
}
