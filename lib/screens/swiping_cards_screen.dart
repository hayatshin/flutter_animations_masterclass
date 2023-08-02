import 'dart:math';

import 'package:flutter/material.dart';

class SwipingCardsScreen extends StatefulWidget {
  const SwipingCardsScreen({super.key});

  @override
  State<SwipingCardsScreen> createState() => _SwipingCardsScreenState();
}

class _SwipingCardsScreenState extends State<SwipingCardsScreen>
    with SingleTickerProviderStateMixin {
  late final size = MediaQuery.of(context).size;

  double posX = 0;
  late final AnimationController _position = AnimationController(
    vsync: this,
    duration: const Duration(
      milliseconds: 300,
    ),
    lowerBound: (size.width + 100) * -1,
    upperBound: (size.width + 100),
    value: 0.0,
  );

  late final Tween<double> _rotation = Tween(
    begin: -15,
    end: 15,
  );

  late final Tween<double> _scale = Tween(
    begin: 0.8,
    end: 1,
  );

  late final Tween<double> _cardScale = Tween(
    begin: 1.0,
    end: 1.3,
  );

  void _onHorizontalDargUpdate(DragUpdateDetails details) {
    _position.value += details.delta.dx;
  }

  void _whenComplete() {
    _position.value = 0;
    setState(() {
      _index == 5 ? 1 : _index += 1;
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    final bound = size.width - 200;
    final dropZone = size.width + 100;
    if (_position.value.abs() >= bound) {
      final factor = _position.value.isNegative ? -1 : 1;
      _position
          .animateTo(
            dropZone * factor,
            curve: Curves.easeOut,
          )
          .whenComplete(
            _whenComplete,
          );
    } else {
      _position.animateTo(
        0,
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _position.dispose();
    super.dispose();
  }

  int _index = 1;

  void _onDropDownClose() {
    final dropZone = size.width + 100;
    final factor = _position
        .animateTo(dropZone * -1, curve: Curves.easeOut)
        .whenComplete(_whenComplete);
  }

  void _onDropDownCheck() {
    final dropZone = size.width + 100;
    final factor = _position
        .animateTo(dropZone, curve: Curves.easeOut)
        .whenComplete(_whenComplete);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Swiping Cards"),
      ),
      body: AnimatedBuilder(
        animation: _position,
        builder: (context, child) {
          final angle = _rotation
              .transform((_position.value + size.width / 2) / size.width);
          final scale = _scale.transform(_position.value.abs() / size.width);
          return Column(
            children: [
              SizedBox(
                width: size.width,
                height: size.height * 0.6,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Positioned(
                      top: 70,
                      child: Transform.scale(
                        scale: min(scale, 1.0),
                        child: Card(
                          index: _index == 5 ? 1 : _index + 1,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 70,
                      child: GestureDetector(
                        onHorizontalDragUpdate: _onHorizontalDargUpdate,
                        onHorizontalDragEnd: _onHorizontalDragEnd,
                        child: Transform.translate(
                          offset: Offset(_position.value, 0),
                          child: Transform.rotate(
                            angle: angle * pi / 180,
                            child: Card(index: _index),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: AnimatedBuilder(
                  animation: _position,
                  builder: (context, child) {
                    final negativeScale = _position.value.isNegative
                        ? _cardScale
                            .transform(_position.value.abs() / size.width)
                        : 1.0;
                    final positiveScale = !_position.value.isNegative
                        ? _cardScale
                            .transform(_position.value.abs() / size.width)
                        : 1.0;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: _onDropDownClose,
                          child: Material(
                            elevation: 5,
                            shape: const CircleBorder(),
                            child: Transform.scale(
                              scale: negativeScale,
                              child: Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: negativeScale > 1
                                      ? Colors.red.shade200
                                      : Colors.white,
                                  border: Border.all(
                                    width: 5.0,
                                    color: negativeScale > 1
                                        ? Colors.white
                                        : Colors.red.shade200,
                                  ),
                                ),
                                child: Icon(
                                  Icons.close_rounded,
                                  size: 45,
                                  color: negativeScale > 1
                                      ? Colors.white
                                      : Colors.red.shade200,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        GestureDetector(
                          onTap: _onDropDownCheck,
                          child: Material(
                            elevation: 5,
                            shape: const CircleBorder(),
                            child: Transform.scale(
                              scale: positiveScale,
                              child: Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: positiveScale > 1
                                      ? Colors.green.shade200
                                      : Colors.white,
                                  border: Border.all(
                                    width: 5.0,
                                    color: positiveScale > 1
                                        ? Colors.white
                                        : Colors.green.shade200,
                                  ),
                                ),
                                child: Icon(
                                  Icons.check_rounded,
                                  size: 45,
                                  color: positiveScale > 1
                                      ? Colors.white
                                      : Colors.green,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

class Card extends StatelessWidget {
  final int index;
  const Card({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        width: size.width * 0.8,
        height: size.height * 0.5,
        child: Image.asset(
          "assets/covers/$index.jpg",
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
