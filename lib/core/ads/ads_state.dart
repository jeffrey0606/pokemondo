import 'dart:io';

class AdState {
  static bool appInDevMode = false;

  static String get appId => "ca-app-pub-7101902781826262~1954409331";

  static String get homePageAdUnitId => Platform.isAndroid
      ? appInDevMode
          ? "ca-app-pub-3940256099942544/6300978111"
          : "ca-app-pub-7101902781826262/7662031583"
      : "";

  static String get detailsPageAdUnitId => Platform.isAndroid
      ? appInDevMode
          ? "ca-app-pub-3940256099942544/6300978111"
          : "ca-app-pub-7101902781826262/6529462058"
      : "";
}
