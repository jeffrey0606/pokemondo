import 'package:flutter/material.dart';

class DisplayPokemonProperty extends StatelessWidget {
  final String property;
  final String value;
  final Axis axis;
  final double hGap;
  const DisplayPokemonProperty({
    Key? key,
    required this.axis,
    this.hGap = 8,
    required this.property,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (axis == Axis.horizontal) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            property,
            style: Theme.of(context).textTheme.subtitle2!.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
          ),
          SizedBox(
            width: hGap,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            property,
            style: Theme.of(context).textTheme.subtitle2!.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  fontWeight: FontWeight.w400,
                ),
          ),
        ],
      );
    }
  }
}
