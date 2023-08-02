import 'dart:math';

import 'package:flutter/material.dart';

class AppleWatchScreen extends StatefulWidget {
  const AppleWatchScreen({super.key});

  @override
  State<AppleWatchScreen> createState() => _AppleWatchScreenState();
}

class _AppleWatchScreenState extends State<AppleWatchScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..forward();

  late Animation<double> _redProgress;
  late Animation<double> _greenProgress;
  late Animation<double> _blueProgress;

  late final CurvedAnimation _curve = CurvedAnimation(
    parent: _animationController,
    curve: Curves.bounceOut,
  );

  void _animateValues() {
    final redNewBegin = _redProgress.value;
    final redRandom = Random();
    final redNewEnd = redRandom.nextDouble() * 2.0;
    final redNewTween =
        Tween(begin: redNewBegin, end: redNewEnd).animate(_curve);
    final greenNewBegin = _greenProgress.value;

    final greenRandom = Random();
    final greenNewEnd = greenRandom.nextDouble() * 2.0;
    final greenNewTween =
        Tween(begin: greenNewBegin, end: greenNewEnd).animate(_curve);
    final blueNewBegin = _greenProgress.value;

    final blueRandom = Random();
    final blueNewEnd = blueRandom.nextDouble() * 2.0;
    final blueNewTween =
        Tween(begin: blueNewBegin, end: blueNewEnd).animate(_curve);
    setState(() {
      _redProgress = redNewTween;
      _greenProgress = greenNewTween;
      _blueProgress = blueNewTween;
    });
    _animationController.forward(from: 0);

    // _progress = _animationController.drive(Tween(begin: ))
  }

  @override
  void initState() {
    super.initState();
    final redRandom = Random();
    final redNewBegin = redRandom.nextDouble() * 1.5;
    _redProgress = Tween(
      begin: 0.05,
      end: redNewBegin,
    ).animate(_curve);
    final greenRandom = Random();
    final greenNewBegin = greenRandom.nextDouble() * 1.5;
    _greenProgress = Tween(
      begin: 0.05,
      end: greenNewBegin,
    ).animate(_curve);
    final blueRandom = Random();
    final blueNewBegin = blueRandom.nextDouble() * 1.5;
    _blueProgress = Tween(
      begin: 0.05,
      end: blueNewBegin,
    ).animate(_curve);
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Apple Watch"),
      ),
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return CustomPaint(
              painter: AppleWatchPainter(
                redProgress: _redProgress.value,
                greenProgress: _greenProgress.value,
                blueProgress: _blueProgress.value,
              ),
              size: const Size(400, 400),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _animateValues,
        child: const Icon(
          Icons.refresh,
        ),
      ),
    );
  }
}

class AppleWatchPainter extends CustomPainter {
  final double redProgress;
  final double greenProgress;
  final double blueProgress;

  AppleWatchPainter(
      {required this.redProgress,
      required this.greenProgress,
      required this.blueProgress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const startingAngle = -0.5 * pi;

    // draw red
    final redCirclePaint = Paint()
      ..color = Colors.red.shade400.withOpacity(0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25;
    final redCircleRadius = (size.width / 2) * 0.9;

    canvas.drawCircle(center, redCircleRadius, redCirclePaint);

    // draw blue
    final greenCirclePaint = Paint()
      ..color = Colors.green.shade400.withOpacity(0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25;
    final greenCircleRadius = (size.width / 2) * 0.76;

    canvas.drawCircle(center, greenCircleRadius, greenCirclePaint);

    // draw blue
    final blueCirclePaint = Paint()
      ..color = Colors.cyan.shade400.withOpacity(0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25;
    final blueCircleRadius = (size.width / 2) * 0.62;

    canvas.drawCircle(center, blueCircleRadius, blueCirclePaint);

    // red arc
    final redArcRect = Rect.fromCircle(center: center, radius: redCircleRadius);
    final redArcPaint = Paint()
      ..color = Colors.red.shade400
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 25;

    canvas.drawArc(
      redArcRect,
      startingAngle,
      redProgress * pi,
      false,
      redArcPaint,
    );

    // green arc
    final greenArcRect =
        Rect.fromCircle(center: center, radius: greenCircleRadius);
    final greenArcPaint = Paint()
      ..color = Colors.green.shade400
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 25;

    canvas.drawArc(
      greenArcRect,
      startingAngle,
      greenProgress * pi,
      false,
      greenArcPaint,
    );

    // blue arc
    final blueArcRect =
        Rect.fromCircle(center: center, radius: blueCircleRadius);
    final blueArcPaint = Paint()
      ..color = Colors.cyan.shade400
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 25;

    canvas.drawArc(
      blueArcRect,
      startingAngle,
      blueProgress * pi,
      false,
      blueArcPaint,
    );
  }

  @override
  bool shouldRepaint(covariant AppleWatchPainter oldDelegate) {
    return oldDelegate.redProgress != redProgress ||
        oldDelegate.greenProgress != greenProgress ||
        oldDelegate.blueProgress != blueProgress;
  }
}
