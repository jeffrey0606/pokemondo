import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../configs/language_config.dart';

class AppLangCubit extends Cubit<LanguageConfigs> {
  AppLangCubit(LanguageConfigs configs) : super(configs);

  // static late LanguageConfigs configs;
  Future<void> change(Locale locale) async {
    final lang = await LanguageConfigs.store(
      LanguageConfigs(
        locale: locale,
      ),
    );

    emit(lang);
  }
}
