import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:math' as math;

class ContactScreen extends StatefulWidget {
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> with SingleTickerProviderStateMixin{
  
  final _rotatedText = TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 30);
  final radius = 80;

  Animation<double> contactAnimation;
  AnimationController controller;
  Animation<double> arrowAnimation;
  Animation<Color> arrowColor;
  Animation<double> arrowRotation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    contactAnimation = Tween<double>(begin: 16, end: 21).animate(controller)
      ..addListener(() {
        setState(() {
          // print("ticker");
        });
      });
    arrowAnimation = Tween<double>(begin: 80, end: 50).animate(controller);
    arrowColor = ColorTween(begin: Colors.green, end: Colors.red).animate(controller);
    final Animation curve = CurvedAnimation(parent: controller, curve: Curves.easeInOutSine);
    arrowRotation = Tween<double>(begin: math.pi / 4, end: -math.pi / 4).animate(curve);

    controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset("assets/shibu_doggo.png"),
        Positioned(
          top: 80,
          left: 60,
          child: Transform.rotate(angle: -  math.pi / 4, child: Text("Woof", style: _rotatedText))
        ),
        Positioned(
          top: 60,
          right: 40,
          child: Transform.rotate(angle: math.pi / 6, child: Text("Oh, hi there", style: _rotatedText))
        ),
        Positioned(
          bottom: 150,
          left: 30,
          right: 30,
          child: Column(
            children: <Widget>[
              Text("msmarket.contact@gmail.com", style: TextStyle(fontSize: contactAnimation .value))
            ],
          )
        ),
        Positioned(
          bottom: 120 - radius * math.cos(arrowRotation.value),
          // left: 40,
          left:  - radius * 4 * math.sin(-arrowRotation.value),
          right: 0,
          child: Transform.rotate(angle:  -math.pi / 2 - arrowRotation.value, child: Icon(Icons.arrow_forward, size: arrowAnimation.value, color: arrowColor.value,))
        )
      ],
    );
  }
}