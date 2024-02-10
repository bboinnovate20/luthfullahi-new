import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

WidgetsToImageController controller = WidgetsToImageController();

widgetToImage(Widget widget) async {
  try {
    // Create a global key for the widget
    GlobalKey previewContainer = GlobalKey();

    Builder(
      builder: (BuildContext context) {
        return RepaintBoundary(
          key: previewContainer,
          child: const Text("dddddd"),
        );
      },
    );

    RenderRepaintBoundary? boundary = previewContainer.currentContext
        ?.findRenderObject() as RenderRepaintBoundary?;
    print(boundary);
    // if (boundary.debugNeedsPaint) {
    //   Timer(const Duration(seconds: 1), () => screenShotAndShare());
    //   return null;
    // }

    // await Future.delayed(const Duration(milliseconds: 1000));
    // print("ddd");
    // boundary = containerKey.currentContext?.findRenderObject()
    //     as RenderRepaintBoundary?;
    // print(boundary);
    // if (boundary != null) {
    //   print("not null");
    //   ui.Image image = await boundary.toImage(
    //       pixelRatio: 3.0); // You can adjust the pixel ratio as needed
    //   ByteData? byteData =
    //       await image.toByteData(format: ui.ImageByteFormat.png);
    //   Uint8List? bytes = byteData?.buffer.asUint8List();
    //   print(bytes);
    // }

    // Capture the image as a byte list
    // return bytes;
  } catch (e) {
    print('Error capturing image: $e');
    return null;
  }

//   // WidgetsToImageController to access widget
// // to save image bytes of widget
//   Uint8List? bytes;
//   GlobalKey containerKey = GlobalKey();
//   WidgetsToImage(
//     controller: controller,
//     child: widget,
//   );

//   RenderRepaintBoundary? boundary =
//       containerKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
//   print(boundary);
//   // print(controller.containerKey);
//   // bytes = await controller.capture();
//   // print(bytes);
//   // return bytes;

//   // // Get the temporary directory using path_provider
//   //   Directory tempDir = await getTemporaryDirectory();

//   //   // Create a temporary file
//   //   File tempFile = File('${tempDir.path}/identity.png');

//   // Share.shareXFiles(files)
//   // return bytes;
}

downloadImage(Uint8List byte) async {
  try {
    await ImageGallerySaver.saveImage(byte.buffer.asUint8List());
    return true;
  } catch (e) {
    return false;
  }
}

downloadShareImage(Uint8List bytes) async {
  try {
    Directory tempDir = await getTemporaryDirectory();
    File tempFile = File('${tempDir.path}/identity.png');
    File file = await tempFile.writeAsBytes(bytes);

    Share.shareXFiles([XFile(file.path)]);
    return true;
  } catch (e) {
    return false;
  }
}
