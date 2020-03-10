import 'package:flutter/widgets.dart';

class BerzierTop extends StatelessWidget {
  final Color color;

  BerzierTop({this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      child: Container(
        height: 300.0,
      ),
      painter: CurvePainter(color: color),
    );
  }
}

class CurvePainter extends CustomPainter{
  final Color color;

  CurvePainter({this.color});

  @override
  void paint(Canvas canvas, Size size) {
  Path path = Path();
  Paint paint = Paint();


  // path.lineTo(0, size.height *0.75);
  // path.quadraticBezierTo(size.width* 0.10, size.height*0.70, size.width*0.17, size.height*0.90);
  // path.quadraticBezierTo(size.width*0.20, size.height, size.width*0.25, size.height*0.90);
  // path.quadraticBezierTo(size.width*0.40, size.height*0.40, size.width*0.50, size.height*0.70);
  // path.quadraticBezierTo(size.width*0.60, size.height*0.85, size.width*0.65, size.height*0.65);
  // path.quadraticBezierTo(size.width*0.70, size.height*0.90, size.width, 0);
  // path.close();

  path.lineTo(0, size.height * 0.50);
  path.quadraticBezierTo(size.width/4, size.height * 0.25, size.width/2, size.height * 0.5);
  path.quadraticBezierTo(size.width * 3/4, size.height * 0.75, size.width, size.height * 0.5);
  path.lineTo(size.width, 0);

  path.close();

  paint.color = color;
  canvas.drawPath(path, paint);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }

}