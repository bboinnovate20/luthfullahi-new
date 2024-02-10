import 'dart:io';
import 'dart:typed_data';

import 'package:babaloworo/shared/arabic_text.dart';
import 'package:babaloworo/shared/primary_btn.dart';
import 'package:babaloworo/shared/saved_widget_image.dart';
import 'package:babaloworo/shared/secured_storage_util.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:ui' as ui;

class IdentityCard extends StatefulWidget {
  final String name;
  final String status;
  const IdentityCard({super.key, required this.name, this.status = "MEMBER"});

  @override
  State<IdentityCard> createState() => _IdentityCardState();
}

class _IdentityCardState extends State<IdentityCard> {
  late CameraController _controller;
  bool isLoading = false;

  GlobalKey globalKey = GlobalKey();
  download() async {
    setState(() {
      isLoading = true;
    });

    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      const SnackBar(content: Text('Saving')),
    );
    
    RenderRepaintBoundary boundary =
        globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

    ui.Image image = await boundary.toImage(pixelRatio: 6.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    final isSaved = await downloadImage(pngBytes);
    if (isSaved) {
      scaffold.removeCurrentSnackBar();
      scaffold.showSnackBar(
        const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Successfully Saved to your Photo')),
      );
    } else {
      scaffold.showSnackBar(
        const SnackBar(
            backgroundColor: Colors.red, content: Text('Failed to save')),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.close,
                      size: 30,
                    ),
                  ],
                ),
              ),
            ),
            //front page
            RepaintBoundary(
                key: globalKey,
                child: FrontBack(name: widget.name, status: widget.status)),
            PrimaryButton(
              isLoading: isLoading,
              title: "Download as Image",
              action: () => {download()},
              icon: "assets/icons/download.png",
            )
          ].animate(),
        ),
      ),
    );
  }
}

class FrontBack extends StatefulWidget {
  final String name;
  final String status;

  const FrontBack({super.key, required this.name, this.status = "MEMBER"});

  @override
  State<FrontBack> createState() => _FrontBackState();
}

class _FrontBackState extends State<FrontBack> {
  String imagePath = "";

  checkImage() async {
    final storage = SecuredStorage();
    final result = await storage.readData(key: "image");
    if (result != null) {
      setState(() {
        imagePath = result.toString();
      });
    }
  }

  takePicture() async {
    final imagePicker = ImagePicker();
    final XFile? image =
        await imagePicker.pickImage(source: ImageSource.gallery);

    // save
    if (image?.path != null) {
      final storage = SecuredStorage();
      await storage.writeData("image", image?.path.toString() ?? "");
      setState(() {
        imagePath = image?.path.toString() ?? "";
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkImage();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Color(0xFFF9F8DF)),
      child: Column(
        children: [
          Container(
            width: 350,
            height: 210,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 1, color: Colors.black),
            ),
            margin: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 70,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              "assets/images/logo.png", // Replace with your image URL or use AssetImage for local images
                              width: 25, // Adjust the width as needed
                              height: 25, // Adjust the height as needed
                              fit: BoxFit
                                  .cover, // Adjust the fit property according to your needs
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const ArabicText(
                                  arabic: "لطـــف الله الدولــيـــــة"),
                              Text(
                                "LUTHFULLAHI INTERNATIONAL",
                                style: Theme.of(context)
                                    .textTheme
                                    .displayLarge
                                    ?.copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => takePicture(),
                        child: Stack(
                          children: [
                            imagePath.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.file(
                                      File(imagePath),
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Stack(
                                    children: [
                                      Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          color: Colors.black26,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      const Positioned.fill(
                                          child: Center(
                                              child: Icon(
                                        Icons.camera_alt_rounded,
                                        size: 25,
                                      )))
                                    ],
                                  )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              child: Text(
                                "E-IDENTITY CARD",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ),
                            Text(widget.name.toUpperCase(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            Text(widget.status,
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary))
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            width: 350,
            height: 250,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 1, color: Colors.black),
            ),
            margin: const EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                      textAlign: TextAlign.center,
                      "This is to certify that the person whose name & photograph appear on the reverse side  is a member of"),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 25),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          textAlign: TextAlign.center,
                          "LUTHFULLAHI INTERNATIONAL",
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        const Text(
                            textAlign: TextAlign.center,
                            "15/17, Alabi Owoyemi Street, Oworosoki, Lagos")
                      ],
                    ),
                  ),
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text("Secretary General"), Text("08023154260")],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
