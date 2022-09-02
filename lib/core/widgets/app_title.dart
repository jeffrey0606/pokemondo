import 'package:flutter/material.dart';

class AppTitle extends StatelessWidget {
  final String? title;
  const AppTitle({Key? key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 24,
          width: 24,
          child: Image.asset(
            "assets/images/logo.png",
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        Padding(
          padding: const EdgeInsets.only(
            bottom: 1,
          ),
          child: Text(
            title ?? 'Pokemondo',
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
      ],
    );
  }
}
