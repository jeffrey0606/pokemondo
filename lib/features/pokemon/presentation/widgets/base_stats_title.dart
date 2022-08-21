import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BaseStatsTitle extends StatelessWidget {
  const BaseStatsTitle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Theme.of(context).colorScheme.background,
          ),
        ),
      ),
      child: Text(
        AppLocalizations.of(context)!.height,
        style: Theme.of(context).textTheme.headline3,
      ),
    );
  }
}