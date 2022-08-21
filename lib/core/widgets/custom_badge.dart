import 'package:flutter/material.dart';

import '../utils/extensions.dart';

class CustomBadge extends StatefulWidget {
  // final Color color;
  final int value;
  final double fontSize;
  final double padding;
  const CustomBadge({
    Key? key,
    // this.color = Colors.red,
    this.value = 0,
    this.padding = 1,
    this.fontSize = 10.0,
  }) : super(key: key);

  @override
  State<CustomBadge> createState() => _CustomBadgeState();
}

class _CustomBadgeState extends State<CustomBadge> {
  bool once = true;
  Size? childSize;

  @override
  Widget build(BuildContext context) {
    final Size mediaSize = MediaQuery.of(context).size;
    if (widget.value <= 0) {
      return Container();
    }

    Text text = Text(
      widget.value.toString(),
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: widget.fontSize,
        color: Colors.white,
      ),
    );

    Size textSize = text.size(
      mediaSize,
      extra: widget.padding,
    );

    return Builder(
      builder: (context) {
        if (once) {
          WidgetsBinding.instance.addPostFrameCallback(
            (timeStamp) {
              childSize = context.size;
              once = false;
              setState(() {});
            },
          );
        }
        return Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(widget.padding),
          constraints: BoxConstraints(
            minWidth: widget.fontSize + (widget.padding * 2.5),
            maxHeight: textSize.height + widget.padding,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(
              textSize.height + widget.padding,
            ),
          ),
          child: FittedBox(
            child: text,
          ),
        );
      },
    );
  }
}
