import 'package:flutter/material.dart';

class ImplicitAnimationScreen extends StatefulWidget {
  const ImplicitAnimationScreen({super.key});

  @override
  State<ImplicitAnimationScreen> createState() =>
      _ImplicitAnimationScreenState();
}

class _ImplicitAnimationScreenState extends State<ImplicitAnimationScreen> {
  bool _visible = true;

  void _trigger() {
    setState(() {
      _visible = !_visible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Implicit Animations",
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder(
              tween: ColorTween(
                begin: Colors.purple,
                end: Colors.red,
              ),
              curve: Curves.bounceInOut,
              duration: const Duration(
                seconds: 2,
              ),
              builder: (context, value, child) {
                return Image.network(
                  "https://cf.festa.io/img/2022-11-18/4131a58d-1562-4aa8-880c-101d93252023.png",
                  color: value,
                  colorBlendMode: BlendMode.colorBurn,
                );
              },
            ),
            // AnimatedContainer(
            //   curve: Curves.bounceIn,
            //   duration: const Duration(seconds: 2),
            //   width: size.width * 0.8,
            //   height: size.width * 0.8,
            //   transform: Matrix4.rotationZ(
            //     _visible ? 1 : 0,
            //   ),
            //   transformAlignment: Alignment.center,
            //   decoration: BoxDecoration(
            //     color: _visible ? Colors.red : Colors.amber,
            //     borderRadius: BorderRadius.circular(
            //       _visible ? 100 : 0,
            //     ),
            //   ),
            // ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
              onPressed: _trigger,
              child: const Text("go!"),
            )
          ],
        ),
      ),
    );
  }
}
