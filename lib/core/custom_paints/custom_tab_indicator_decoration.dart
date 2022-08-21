import 'package:flutter/widgets.dart';

class MyTabIndicator extends Decoration {
  final Color color;
  final BorderRadius borderRadius;
  final double height;

  const MyTabIndicator({
    required this.color,
    required this.borderRadius,
    required this.height,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CustomPainter(
      this,
      onChanged,
      borderRadius: borderRadius,
      color: color,
      height: height,
    );
  }
}

class _CustomPainter extends BoxPainter {
  final MyTabIndicator decoration;
  final Color color;
  final BorderRadius borderRadius;
  final double height;
  _CustomPainter(
    this.decoration,
    VoidCallback? onChanged, {
    required this.color,
    required this.borderRadius,
    required this.height,
  }) : super(onChanged);
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Paint paint = Paint();
    paint.color = color;
    paint.style = PaintingStyle.fill;

    Size? size = configuration.size ?? Size.zero;

    Rect rect = offset & size;

    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(
          rect.left,
          rect.height - height,
          rect.width,
          height,
        ),
        bottomLeft: borderRadius.bottomLeft,
        bottomRight: borderRadius.bottomRight,
        topLeft: borderRadius.topLeft,
        topRight: borderRadius.topRight,
      ),
      paint,
    );
  }
}
