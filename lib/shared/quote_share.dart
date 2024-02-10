import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:babaloworo/calendar/calendar.dart';
import 'package:babaloworo/calendar/calendart_util.dart';
import 'package:babaloworo/shared/arabic_text.dart';
import 'package:babaloworo/shared/primary_btn.dart';
import 'package:babaloworo/shared/saved_widget_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class QuoteShare extends StatefulWidget {
  final String title;
  final String arabic;
  final String english;
  final String reference;
  const QuoteShare(
      {super.key,
      required this.title,
      required this.arabic,
      required this.english,
      required this.reference});

  @override
  State<QuoteShare> createState() => _QuoteShareState();
}

class _QuoteShareState extends State<QuoteShare> {
  bool isDownloading = false;
  bool isSharing = false;

  getDate() {
    final date = CalendarUtil();
    final result = date.init();
    final arr = result['fullDate'];
    return arr ?? "";
  }

  GlobalKey globalKey = GlobalKey();

  download({toShare = false}) async {
    setState(() {
      if (toShare) {
        isSharing = true;
      } else {
        isDownloading = true;
      }
      print(widget.title);
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

    final isSaved = toShare
        ? await downloadShareImage(pngBytes)
        : await downloadImage(pngBytes);
    if (isSaved) {
      scaffold.removeCurrentSnackBar();
      scaffold.showSnackBar(
        SnackBar(
            backgroundColor: Colors.green,
            content: Text(
                'Successfully ${toShare ? 'shared' : 'saved'} to your Photo')),
      );
    } else {
      scaffold.showSnackBar(
        const SnackBar(
            backgroundColor: Colors.red, content: Text('Failed to save')),
      );
    }
    setState(() {
      if (toShare) {
        isSharing = false;
      } else {
        isDownloading = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RepaintBoundary(
                    key: globalKey,
                    child: Align(
                      alignment: Alignment.center,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                              minHeight: 400, minWidth: 375),
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            width: 400,
                            height: 600,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: const DecorationImage(
                                fit: BoxFit.cover,
                                image:
                                    AssetImage("assets/images/background.png"),
                              ),
                            ),
                            child: DefaultTextStyle(
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              child: Center(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: SizedBox(
                                    width: 500,
                                    // height: 400,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Column(
                                        children: [
                                          const Text(
                                              "SHEIKH RABIU ADEBAYO APP"),
                                          const Text(
                                              "LUTHFULLAHI SOCIETY OF NIGERIA"),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                top: 30, bottom: 20),
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 5,
                                              horizontal: 8,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 1),
                                            ),
                                            child: Text(
                                              getDate(),
                                              style: const TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                          Text(
                                            widget.title,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge
                                                ?.copyWith(color: Colors.white),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            margin:
                                                const EdgeInsets.only(top: 20),
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 1),
                                            ),
                                            child: Column(
                                              children: [
                                                ArabicText(
                                                  fontSize: 25,
                                                  arabic: widget.arabic,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8.0),
                                                  child: Text(
                                                    widget.english,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .displayMedium,
                                                  ),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(vertical: 10),
                                                  child: Text(
                                                    widget.reference,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Row(
                                          //   children: [
                                          //     PrimaryButton(title: "Share", action: () => {}),
                                          //     PrimaryButton(
                                          //         title: "Download", action: () => {}),
                                          //   ],
                                          // )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                            child: PrimaryButton(
                                isLoading: isSharing,
                                title: "Share",
                                action: () => {download(toShare: true)})),
                        Expanded(
                            child: PrimaryButton(
                                isLoading: isDownloading,
                                title: "Download",
                                action: () => {download()})),
                      ],
                    ),
                  )

                  // PrimaryButton(title: "Share", action: () => {}),
                  // PrimaryButton(title: "Share", action: () => {}),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              margin: const EdgeInsets.only(top: 60, right: 30.0),
              child: const Row(
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
        ],
      ),
    );
  }
}
