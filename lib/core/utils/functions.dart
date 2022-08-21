import 'dart:async';

import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

import 'enums.dart';

Future<Size> getImageSize(String asset, ImageType imageType) async {
  try {
    late final Image image;
    switch (imageType) {
      case ImageType.asset:
        image = Image.asset(
          asset,
        );
        break;
      case ImageType.network:
        image = Image.network(
          asset,
        );
        break;
      default:
    }
    final Completer<Size> completer = Completer<Size>();
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
        (ImageInfo image1, bool synchronousCall) {
          final myImage = image1.image;
          final Size size = Size(
            myImage.width.toDouble(),
            myImage.height.toDouble(),
          );
          completer.complete(size);
        },
      ),
    );

    return await completer.future;
  } catch (e) {
    return throw Exception("couldn't get image");
  }
}

Future<Size> resizeImage(
  String asset,
  Size availableSize, {
  ImageType? imageType,
  bool useImageSize = false,
}) async {
  bool scaleImageToFit = false;
  late Size originalSize;
  try {
    originalSize = await getImageSize(
      asset,
      imageType ?? ImageType.asset,
    );
  } catch (e) {
    rethrow;
  }

  double? targetWidth;
  double? targetHeight;

  if (!useImageSize) {
    if (originalSize.width > originalSize.height) {
      //Landscape
      targetWidth = availableSize.width == double.infinity
          ? originalSize.width
          : availableSize.width;
      if (targetWidth > originalSize.width) {
        scaleImageToFit = true;
      }
    } else if (originalSize.width < originalSize.height) {
      targetHeight = availableSize.height;
      if (targetHeight > originalSize.width) {
        scaleImageToFit = true;
      }
    } else {
      targetHeight = availableSize.height;
      targetWidth = availableSize.height;
    }
  }

  targetWidth ??= originalSize.width;

  targetHeight ??= originalSize.height;
  // Calculate resize ratios for resizing
  final double ratioW = targetWidth / originalSize.width;
  final double ratioH = targetHeight / originalSize.height;

  double ratio;
  if (useImageSize || !scaleImageToFit) {
    // smaller ratio will ensure that the image fits in the view
    ratio = ratioW < ratioH ? ratioW : ratioH;
  } else {
    if (targetWidth > originalSize.width) {
      // to scale image up to specified width or height keeping the aspect ratio intact
      ratio = ratioW > ratioH ? ratioW : ratioH;
    } else {
      // to scale image down to specified width or height keeping the aspect ratio intact
      ratio = ratioW < ratioH ? ratioW : ratioH;
    }
  }

  final double newWidth = originalSize.width * ratio;
  final double newHeight = originalSize.height * ratio;

  if (newWidth.toInt() > (1 * originalSize.width.toInt()) ||
      newHeight.toInt() > (1 * originalSize.height)) {
    return originalSize;
  }
  return Size(
    newWidth,
    newHeight,
  );
}

Future<List<Color>> getImageColors(
  String asset,
  ImageType imageType, {
  ImageProvider? imageProvider,
}) async {

  late ImageProvider? imageProvider1;
  
  if (imageProvider == null) {
    switch (imageType) {
      case ImageType.asset:
        imageProvider1 = AssetImage(
          asset,
        );
        break;
      case ImageType.network:
        imageProvider1 = NetworkImage(
          asset,
        );
        break;
      default:
    }
  } else {
    imageProvider1 = imageProvider;
  }

  final PaletteGenerator paletteGenerator =
      await PaletteGenerator.fromImageProvider(imageProvider1!);
  final List<Color> colors = [];
  for (Color color in paletteGenerator.colors.toList()) {
    if (colors.isNotEmpty &&
        getColorHex(colors.first).substring(0, 2) !=
            getColorHex(color).substring(0, 2)) {
      colors.add(color);
      break;
    }

    if (colors.isEmpty) {
      colors.add(color);
    }
  }
  return colors;
}

String getColorHex(Color color) {
  String colorStr = color.toString();
  colorStr = colorStr.replaceFirst("Color(0xff", "");
  colorStr = colorStr.replaceFirst(")", "");

  return colorStr;
}
