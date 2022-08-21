import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/app_lang/app_lang_cubit.dart';
import '../../../../core/configs/language_config.dart';
import '../../../../core/utils/extensions.dart';

class SwitchLanguage extends StatelessWidget {
  const SwitchLanguage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: AppLocalizations.supportedLocales.map((locale) {
        return BlocBuilder<AppLangCubit, LanguageConfigs>(
          builder: (context, state) {
            bool select = locale == state.locale;

            if(state.locale == null && locale.languageCode == "en") {
              select = true;
            }
            return ListTile(
              style: ListTileStyle.drawer,
              title: Text(locale.countryName(context)),
              selected: select,
              textColor: Theme.of(context).textTheme.headline1!.color,
              selectedColor: Theme.of(context).colorScheme.secondary,
              enableFeedback: true,
              onTap: () {
                context.read<AppLangCubit>().change(locale);
              },
            );
          },
        );
      }).toList(),
    );
  }
}
