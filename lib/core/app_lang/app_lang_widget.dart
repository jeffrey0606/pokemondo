import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../configs/language_config.dart';
import '../configs/stored_configs.dart';
import 'app_lang_cubit.dart';

class AppLangWidgetBuilder extends StatelessWidget {
  final Widget Function(BuildContext, LanguageConfigs) appLanBuilder;
  const AppLangWidgetBuilder({
    Key? key,
    required this.appLanBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppLangCubit>(
      create: (BuildContext context) => AppLangCubit(
        StoredConfigs.languageConfigs,
      ),
      child: BlocBuilder<AppLangCubit, LanguageConfigs>(
        builder: appLanBuilder,
      ),
    );
  }
}
