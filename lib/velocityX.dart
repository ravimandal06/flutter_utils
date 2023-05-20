import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:sensors_plus/sensors_plus.dart';

class Parallax extends StatefulWidget {
  const Parallax({Key? key}) : super(key: key);

  @override
  State<Parallax> createState() => _ParallaxState();
}

class _ParallaxState extends State<Parallax> with TickerProviderStateMixin {
  double xAngle = 0;
  double prevXAngle = 0;
  double yAngle = 0;
  double prevYAngle = 0;
  double zAngle = 0;
  double prevZAngle = 0;
  final double squareSize = 250;
  final streamsub = <StreamSubscription<dynamic>>[];

  @override
  void initState() {
    super.initState();

    streamsub.add(accelerometerEvents.listen((event) {
      setState(() {
        prevXAngle = xAngle;
        xAngle = event.x;
        prevYAngle = yAngle;
        yAngle = double.parse(event.y.toString());
        prevZAngle = zAngle;
        zAngle = double.parse(event.z.toString());
        
      });
    }));
  }

  @override
  void dispose() {
    super.dispose();
    for (final sub in streamsub) {
      sub.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(
            height: 200,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 50, right: 20),
            child: SizedBox(
              width: 400,
              height: 500,
              child: TweenAnimationBuilder(
                  tween: Tween(begin: prevXAngle, end: xAngle),
                  duration: const Duration(milliseconds: 300),
                  builder: (context, double xValue, _) {
                    return TweenAnimationBuilder(
                        tween: Tween(begin: prevZAngle, end: zAngle),
                        duration: const Duration(milliseconds: 300),
                        builder: (context, double zValue, _) {
                          return [
                            Transform(
                                origin: Offset(squareSize / 2, squareSize / 2),
                                transform: Matrix4.identity()
                                  ..setEntry(3, 2, 0.003)
                                  ..rotateX(-zValue / 10)
                                  ..rotateY(xValue / 10),
                                child: VxBox()
                                    .rounded
                                    .bgImage(const DecorationImage(
                                        image: AssetImage('images/2.png'),
                                        fit: BoxFit.contain))
                                    .width(squareSize)
                                    .height(squareSize)
                                    .make()),
                            Transform(
                                origin: const Offset(150, 150),
                                transform: Matrix4.identity()
                                  ..setEntry(3, 2, 0.002)
                                  ..rotateX(-zValue / 10)
                                  ..rotateY(xValue / 10),
                                child: VxBox(
                                        child: Container(
                                  margin:
                                      const EdgeInsets.only(top: 230, left: 70),
                                  child: const Text(
                                    "@the.ravimandal",
                                    style: TextStyle(color: Colors.white12),
                                  ),
                                ))
                                    .rounded
                                    .bgImage(const DecorationImage(
                                        image: AssetImage('images/1.png'),
                                        fit: BoxFit.fitHeight))
                                    .width(squareSize)
                                    .height(squareSize)
                                    .make())
                          ].zStack();
                        });
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
