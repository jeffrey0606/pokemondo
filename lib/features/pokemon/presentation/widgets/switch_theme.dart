import 'package:flutter/material.dart';

import '../../../../core/configs/theming_configs.dart';
import '../../../../core/utils/enums.dart';
import '../../../../core/utils/extensions.dart';


class SwitchTheme extends StatelessWidget {
  const SwitchTheme({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ListTile(
          style: ListTileStyle.drawer,
          title: Text(AppThemeMode.light.translate(context)),
          selected: ThemingConfigs.config.value!.mode == ThemeMode.light,
          textColor: Theme.of(context).textTheme.headline1!.color,
          selectedColor: Theme.of(context).colorScheme.secondary,
          enableFeedback: true,
          onTap: () {
            ThemingConfigs.switchTheme(ThemeMode.light);
          },
        ),
        Divider(
          color: Theme.of(context).colorScheme.background,
          thickness: 2,
        ),
        ListTile(
          style: ListTileStyle.drawer,
          title: Text(AppThemeMode.dark.translate(context)),
          textColor: Theme.of(context).textTheme.headline1!.color,
          selected: ThemingConfigs.config.value!.mode == ThemeMode.dark,
          selectedColor: Theme.of(context).colorScheme.secondary,
          enableFeedback: true,
          onTap: () {
            ThemingConfigs.switchTheme(ThemeMode.dark);
          },
        ),
      ],
    );
  }
}
