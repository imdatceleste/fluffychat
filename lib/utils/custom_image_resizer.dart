import 'dart:typed_data';

import 'package:image/image.dart' as il;
import 'package:matrix/matrix.dart';

Future<MatrixImageFileResizedResponse?> customImageResizer(
  MatrixImageFileResizeArguments arguments,
) async {
  try {
    il.Image? image = il.decodeImage(arguments.bytes);
    if (image == null) {
      return null;
    }
    final width = image.width;
    final height = image.height;

    final max = arguments.maxDimension;
    if (width > max || height > max) {
      var w = max, h = max;
      if (width > height) {
        h = max * height ~/ width;
      } else {
        w = max * width ~/ height;
      }
      image = il.copyResize(
        image,
        width: w,
        height: h,
        maintainAspect: true,
        interpolation: il.Interpolation.cubic,
      );
    }
    final imageData = Uint8List.fromList(il.encodeJpg(image, quality: 75));
    return MatrixImageFileResizedResponse(
      bytes: imageData,
      width: image.width,
      height: image.height,
      blurhash: null,
    );
  } catch (e) {
    return null;
  }
}
