import 'package:babaloworo/shared/screen_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TesbihCounterProvider extends ChangeNotifier {
  double count = 34;

  int cycle = 0;
  double countOffset = 0.14;
  String userStatus = "TAP";
  double totalCircleRound = (2 * 3.14) - 0.14;
  double currentCount = 1;
  Color strokeColor = const Color(0xFFFFF500);
  double counting = 0;

  TesbihCounterProvider() {
    init();
  }

  changeCount(number) {
    if (number > 1000) {
      return;
    }
    if (count != number) {
      count = number + 1;
      notifyListeners();
    }
  }

  reset() {
    userStatus = "TAP";
    currentCount = 1;
    strokeColor = const Color(0xFFFFF500);
    counting = (currentCount / count) * totalCircleRound;
    cycle = 0;
    notifyListeners();
  }

  increaseAndResetCount() {
    if (currentCount < count) {
      currentCount = currentCount + 1;
      counting = (currentCount / count) * totalCircleRound;
    }
    if (currentCount == count - 1) {
      strokeColor = const Color(0xFF590676);
      userStatus = "RESET";
      currentCount++;
    } else if (currentCount == count) {
      userStatus = "TAP";
      strokeColor = const Color(0xFFFFF500);
      currentCount = 1;
      counting = countOffset;
      cycle = cycle + 1;
    }
    notifyListeners();
  }

  init() {
    counting = ((currentCount / count) * totalCircleRound) + countOffset;
    notifyListeners();
  }
}

class Tesbih extends StatefulWidget {
  const Tesbih({super.key});

  @override
  State<Tesbih> createState() => _TesbihState();
}

TextEditingController counterController = TextEditingController(text: "");

class _TesbihState extends State<Tesbih> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldContainer(
      title: "E-Tesbih",
      // titleColor: Colors.white,
      isGradient: true,
      leadingColor: Colors.black,
      isWithBackButton: true,
      bgColor: const Color(0xFFFBF8AB),

      gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFBF8AB), Color(0xFF8B8725)]),

      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: ChangeNotifierProvider(
            create: (context) => TesbihCounterProvider(),
            builder: (context, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ChangeCounter(
                          text: "",
                          action: () {
                            _dialogBuilder(
                                context,
                                context.read<TesbihCounterProvider>().count,
                                (text) => {
                                      context
                                          .read<TesbihCounterProvider>()
                                          .changeCount(double.tryParse(text)),
                                    });
                          }),
                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: ChangeCounter(
                            text: "RESET",
                            action: () =>
                                context.read<TesbihCounterProvider>().reset(),
                            requireIcon: false),
                      ),
                    ],
                  ),
                  const Expanded(child: ProgressPaint()),
                ],
              );
            }),
      ),
    );
  }

  Future<void> _dialogBuilder(
      BuildContext context, double text, Function changeText) {
    counterController.text = "${text.toInt() - 1}";
    bool countMaintained = true;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            backgroundColor: Colors.white,
            title: const Text(' Update'),
            content: TextField(
                keyboardType: TextInputType.number,
                controller: counterController,
                cursorColor: Colors.black,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                    errorText:
                        countMaintained ? null : "Tesbih count exceed 1000",
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)))),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).colorScheme.primary),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 16.0),
                      child: Text(
                        'Update',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    )),
                onPressed: () {
                  if (counterController.text.isEmpty) {
                    Navigator.of(context).pop();
                    return;
                  }
                  try {
                    if (int.parse(counterController.text) > 1000) {
                      setState(() {
                        countMaintained = false;
                      });
                    } else {
                      changeText(counterController.text);
                      Navigator.of(context).pop();
                    }
                  } catch (e) {
                    Navigator.of(context).pop();
                    return;
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class ChangeCounter extends StatelessWidget {
  final bool requireIcon;
  final String text;
  final Function action;

  const ChangeCounter(
      {super.key,
      this.requireIcon = true,
      required this.text,
      required this.action});

  @override
  Widget build(BuildContext context) {
    var count = context.watch<TesbihCounterProvider>().count;
    return GestureDetector(
      child: Container(
        width: 120,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: GestureDetector(
          onTap: () => action(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 8),
            child: !requireIcon
                ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(text, style: Theme.of(context).textTheme.displayLarge),
                    requireIcon
                        ? const Icon(Icons.edit_note_outlined)
                        : Container()
                  ])
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${count.toInt() - 1}",
                          style: Theme.of(context).textTheme.displayLarge),
                      requireIcon
                          ? const Icon(Icons.edit_note_outlined)
                          : Container()
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class ProgressPaint extends StatefulWidget {
  const ProgressPaint({super.key});

  @override
  State<ProgressPaint> createState() => _ProgressPaintState();
}

class _ProgressPaintState extends State<ProgressPaint>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late double current;
  double animateCount = -20;
  double opacity = 0;

  @override
  void initState() {
    super.initState();
    animateCount = -0.5;
    Future.delayed(
        const Duration(seconds: 1),
        () => setState(() {
              animateCount = 0;
              opacity = 1;
            }));

    _controller = AnimationController(
        lowerBound: 0.5,
        vsync: this,
        duration: const Duration(
          milliseconds: 150,
        ));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TesbihCounterProvider tesbihState = context.watch<TesbihCounterProvider>();

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Positioned(
          top: 35,
          child: Column(
            children: [
              Row(
                children: [
                  CountingAnim(
                      animation: _controller,
                      animateCount: animateCount,
                      opacity: opacity,
                      tesbihState: tesbihState),
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: " / ${tesbihState.count.toInt() - 1}",
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(color: Colors.black, fontSize: 35)),
                      TextSpan(
                          text: " - (${tesbihState.cycle})",
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall
                              ?.copyWith(color: Colors.black54, fontSize: 35)),
                    ]),
                  ),
                ],
              ),
            ],
          ),
        ),
        CustomPaint(
          painter: ProgressPainter(
              count: tesbihState.counting + tesbihState.countOffset,
              strokeColor: tesbihState.strokeColor),
          child: Center(
            child: GestureDetector(
              onTap: () {
                context.read<TesbihCounterProvider>().increaseAndResetCount();
                // _controller.reverse();
                _controller.reset();
                _controller.forward();
              },
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white, shape: BoxShape.circle),
                child: Padding(
                  padding: const EdgeInsets.all(45.0),
                  child: Text(
                    tesbihState.userStatus,
                    style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        fontFamily: "inter"),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CountingAnim extends AnimatedWidget {
  const CountingAnim(
      {super.key,
      required this.animateCount,
      required this.opacity,
      required this.tesbihState,
      required AnimationController animation})
      : super(listenable: animation);

  Animation<double> get _progress => listenable as Animation<double>;

  final double animateCount;
  final double opacity;
  final TesbihCounterProvider tesbihState;

  @override
  Widget build(BuildContext context) {
    return FractionalTranslation(
      translation: Offset(0, _progress.value == 0 ? -1 : _progress.value - 1),
      child: Opacity(
        opacity: _progress.value,
        child: Text("${tesbihState.currentCount.toInt() - 1}",
            style: Theme.of(context)
                .textTheme
                .displaySmall
                ?.copyWith(color: Colors.black54, fontSize: 30)),
      ),
    );
  }
}

class ProgressPainter extends CustomPainter {
  ProgressPainter({required this.count, required this.strokeColor});
  final double count;
  final Color strokeColor;
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = Colors.white;

    paint.strokeCap = StrokeCap.round;

    paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);

    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), size.width / 2.5, paint);

    paint.strokeWidth = 40;
    paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 0);
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), size.width / 2.5, paint);

    paint.style = PaintingStyle.stroke;
    paint.color = strokeColor;

    canvas.drawArc(
        Rect.fromCircle(
            center: Offset(size.width / 2, size.height / 2),
            radius: size.width / 2.5),
        0.0,
        count,
        false,
        paint);

    paint.style = PaintingStyle.fill;
    paint.color = Colors.black12;
    paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), size.width / 5.5, paint);
  }

  @override
  bool shouldRepaint(ProgressPainter oldDelegate) {
    return count != oldDelegate.count || strokeColor != oldDelegate.strokeColor;
  }
}
