import 'dart:async';
import "dart:math" as Math;
import 'package:babaloworo/qibla/qibla_util.dart';
import 'package:babaloworo/shared/location_util.dart';
import 'package:babaloworo/shared/screen_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sensors_plus/sensors_plus.dart';

class Qibla extends StatefulWidget {
  const Qibla({super.key});

  @override
  State<Qibla> createState() => _QiblaState();
}

class _QiblaState extends State<Qibla> {
  // final StreamController<AccelerometerEvent> _accelerometerController =
  //     StreamController<AccelerometerEvent>();

  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;

  late StreamSubscription<Position> positionStream;
  double qiblaDirection = 0.0;
  QiblaUtil qibla = QiblaUtil();
  LocationUtil location = LocationUtil();
  double direction = 0;
  Position? currentLocation;
  int newDirection = 0;

  getLocation() async {
    final isGranted = await location.askPermission();
    //  final isGranted = await location.enab();
    if (isGranted) {
      final Position getCurrentLocation = await location.initialize();

      location.streamFunction = (Position position) {
        setState(() {
          currentLocation = position;
        });
        final qiblaDirection = qibla.initialize(
            getCurrentLocation.longitude, getCurrentLocation.longitude);
      };

      startListeningToSensors(qiblaDirection);
      final posStream = await location.startListening();
      setState(() {
        positionStream = posStream;
      });
    }
  }

  void startListeningToSensors(double qiblaDirectionAngle) {
    _accelerometerSubscription =
        accelerometerEventStream(samplingPeriod: const Duration(seconds: 20))
            .listen((AccelerometerEvent event) {
      int eventUpdate = updateEvent(event);

      if ((newDirection - eventUpdate).abs() >= 5) {
        setState(() {
          newDirection = eventUpdate;
        });
        print(newDirection); // _accelerometerController.add(event);
      }
    });
  }

  int updateEvent(AccelerometerEvent event) {
    double deviceHeading = Math.atan2(event.y, event.x) * (180 / Math.pi);
    double qiblaDirectionR = qiblaDirection - deviceHeading;

    qiblaDirectionR = (qiblaDirectionR + 360) % 360;

    return qiblaDirectionR.round();
  }

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  @override
  void dispose() {
    super.dispose();
    if(positionStream != null) positionStream.cancel();
    _accelerometerSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldContainer(
        title: "Qibla",
        bgColor: const Color(0xFFFBF8AB),
        subtitle: "Mecca, Saudi Arabia",
        isWithBackButton: true,
        isGradient: true,
        gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFBF8AB), Color(0xFF8B8725)]),
        body: Center(
          child: CustomPaint(
            painter: const QiblaPainter(),
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  child: Transform(
                    transform: Matrix4.rotationZ(newDirection * 0.0175),
                    alignment: Alignment.center,
                    child: Image.asset(
                      "assets/images/indicator_qibla.png",
                      width: 180,
                      height: 180,
                    ),
                  ).animate(effects: [
                    const RotateEffect(duration: Duration(seconds: 5))
                  ]),
                ),
                SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height - 280,
                    child: Center(
                      child: Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF4B0465),
                          ),
                          child: const Text("")),
                    )),
                SizedBox(
                  height: MediaQuery.of(context).size.height - 280,
                  child: Center(
                    child: Container(
                      height: MediaQuery.of(context).size.height / 3.2,
                      margin: const EdgeInsets.symmetric(horizontal: 50),
                      child: const DefaultTextStyle(
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("W"),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [Text("N"), Text("S")],
                            ),
                            Text("E")
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class QiblaPainter extends CustomPainter {
  const QiblaPainter();

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = const Color(0xFFBC2CD8);

    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), size.width / 2.1, paint);

    paint.color = Colors.white;
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), size.width / 2.35, paint);
    paint.color = const Color(0xFFF9F8DF);

    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), size.width / 2.55, paint);

    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2;
    double count = 70;
    double total = (2 * 3.14);
    double startAngle = 0;
    bool solidSide = true;
    paint.color = const Color(0xFFBC2CD8);

    double stroke = 0;
    double strip = (1 / count) * total;
    for (int i = 1; i <= count; i++) {
      startAngle = stroke;
      stroke = (i / count) * total;

      paint.color = solidSide ? const Color(0xFFBC2CD8) : Colors.transparent;
      solidSide = !solidSide;
      canvas.drawArc(
          Rect.fromCircle(
              center: Offset(size.width / 2, size.height / 2),
              radius: size.width / 2.55),
          startAngle,
          strip,
          false,
          paint);
    }

    paint.style = PaintingStyle.fill;
    paint.color = const Color(0xFFE5A8FB);
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), size.width / 8, paint);
    paint.color = const Color(0xFFFBF1FF);
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), size.width / 13, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // return true;
    throw UnimplementedError();
  }
}
