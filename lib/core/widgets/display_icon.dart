import 'package:flutter/material.dart';

class DisplayIcon extends StatelessWidget {
  final IconData icon;
  final double? size;
  final Color? color;
  const DisplayIcon({required this.icon, this.size, this.color, Key? key})
      : super(key: key);

  DisplayIcon.appBar({required this.icon, required BuildContext context, Key? key}) : 
    size = 24,
    color = Theme.of(context).textTheme.headline4!.color,
    super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: size ?? 24,
      color: color ?? Theme.of(context).textTheme.headline4!.color,
    );
  }
}
