import 'package:flutter/material.dart';
import 'package:pokemondo/core/utils/enums.dart';
import 'package:pokemondo/features/pokemon/presentation/widgets/switch_language.dart';

import 'switch_theme.dart' as st;

Future<void> showMyDialog(
  BuildContext context,
  DialogType dialogType,
) async {
  final size = MediaQuery.of(context).size;
  await showModalBottomSheet<void>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(42),
      ),
    ),
    isScrollControlled: true,
    isDismissible: true,
    backgroundColor: Theme.of(context).colorScheme.primary,
    barrierColor: Colors.black.withOpacity(0.05),
    // useRootNavigator: true,
    builder: (BuildContext context1) {
      return PhysicalModel(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(4),
        ),
        child: SizedBox(
          height: size.height * 0.3,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 5,
                  width: 66,
                  decoration: BoxDecoration(
                    color: Theme.of(context).textTheme.headline1!.color,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                Expanded(
                  child: getDialogWidget(dialogType),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget getDialogWidget(DialogType dialogType) {
  switch (dialogType) {
    case DialogType.lang:
      return const SwitchLanguage();
    case DialogType.theme:
      return const st.SwitchTheme();
    default:
      return Container();
  }
}
