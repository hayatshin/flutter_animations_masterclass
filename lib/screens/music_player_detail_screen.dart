import 'package:flutter/material.dart';

class MusicPlayerDetailScreen extends StatefulWidget {
  final int index;
  const MusicPlayerDetailScreen({super.key, required this.index});

  @override
  State<MusicPlayerDetailScreen> createState() =>
      _MusicPlayerDetailScreenState();
}

class _MusicPlayerDetailScreenState extends State<MusicPlayerDetailScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _progressController = AnimationController(
    vsync: this,
    duration: const Duration(minutes: 1),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  String formatTime(double value) {
    int totalSecons = (value * 60).floor();
    int minutes = totalSecons ~/ 60;
    int seconds = totalSecons % 60;
    String formattedTime =
        "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("interstellar"),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Align(
            alignment: Alignment.center,
            child: Hero(
              tag: "${widget.index}",
              child: Container(
                width: 350,
                height: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: const Offset(0, 8),
                    )
                  ],
                  image: DecorationImage(
                    image: AssetImage(
                      "assets/covers/${widget.index}.jpg",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          AnimatedBuilder(
            animation: _progressController,
            builder: (context, child) => CustomPaint(
              size: Size(size.width - 80, 5),
              painter: ProgressBar(
                progressValue: _progressController.value,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 40,
            ),
            child: Row(
              children: [
                AnimatedBuilder(
                  animation: _progressController,
                  builder: (context, child) => Text(
                    formatTime(_progressController.value),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                const Text(
                  "01:00",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Interstellar",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          const Text(
            "A Film by Christopher Nolan - Original Motion Picture Soundtrack",
            maxLines: 1,
            overflow: TextOverflow.visible,
            style: TextStyle(
              fontSize: 18,
            ),
          )
        ],
      ),
    );
  }
}

class ProgressBar extends CustomPainter {
  final double progressValue;

  ProgressBar({required this.progressValue});

  @override
  void paint(Canvas canvas, Size size) {
    final progress = size.width * progressValue;

    // track
    final trackPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.fill;

    final trackRect = RRect.fromLTRBR(
        0, 0, size.width, size.height, const Radius.circular(10));

    canvas.drawRRect(trackRect, trackPaint);

    //progress
    final progressPaint = Paint()
      ..color = Colors.grey.shade500
      ..style = PaintingStyle.fill;

    final progressRect =
        RRect.fromLTRBR(0, 0, progress, size.height, const Radius.circular(10));

    canvas.drawRRect(progressRect, progressPaint);

    // thumb
    canvas.drawCircle(Offset(progress, size.height / 2), 10, progressPaint);
  }

  @override
  bool shouldRepaint(covariant ProgressBar oldDelegate) {
    return oldDelegate.progressValue != progressValue;
  }
}
