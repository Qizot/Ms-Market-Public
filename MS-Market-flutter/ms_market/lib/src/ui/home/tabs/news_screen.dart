import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

final String newsMessage = 'Aplikacja weszła w fazę testowania!'
'Pamiętaj, że możesz z niej normalnie korzystać'
'jeśli masz jakieś uwagi lub też pomysły jesteśmy otwarci na propozycje';

class NewsScreen extends StatelessWidget {

  final _headerStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 20);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Positioned(
          top: -20,
          left: 0,
          right: 0,
          child: Image.asset("assets/round_doggo.png", height: 400, width: 400)
        ),
        Positioned(
          bottom: 80,
          left: 30,
          right: 30,
          child: Text('Aplikacja weszła w fazę testowania!', style: _headerStyle, textAlign: TextAlign.center)
        )
      ],
    );
  }
}