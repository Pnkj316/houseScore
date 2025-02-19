import 'package:flutter/material.dart';
import 'dart:math';

class StarburstBadge extends StatelessWidget {
  final String text;

  const StarburstBadge({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: StarburstPainter(),
      child: Center(
        child: Container(
          height: 50,
          width: 50,
          alignment: Alignment.center,
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

// class StarburstPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint outerPaint = Paint()
//       ..color = const Color(0xFF73D3A6) // Outer glow color
//       ..style = PaintingStyle.fill;

//     final Paint innerPaint = Paint()
//       ..color = const Color.fromARGB(179, 40, 167, 70)
//       ..style = PaintingStyle.fill;

//     final double width = size.width;
//     final double height = size.height;

//     final double centerX = width / 2;
//     final double centerY = height / 2;

//     const int spikes = 18;
//     final double outerRadius = width / 2;
//     final double innerRadius = outerRadius * 0.79;

//     final Path outerPath = Path();
//     final Path innerPath = Path();

//     final double angle = (2 * pi) / spikes;

//     for (int i = 0; i < spikes; i++) {
//       final double outerX = centerX + outerRadius * cos(i * angle);
//       final double outerY = centerY + outerRadius * sin(i * angle);

//       final double innerX = centerX + innerRadius * cos(i * angle + angle / 2);
//       final double innerY = centerY + innerRadius * sin(i * angle + angle / 2);

//       if (i == 0) {
//         outerPath.moveTo(outerX, outerY);
//         innerPath.moveTo(outerX, outerY);
//       } else {
//         outerPath.lineTo(outerX, outerY);
//         outerPath.lineTo(innerX, innerY);
//       }
//     }

//     outerPath.close();
//     innerPath.close();

//     canvas.drawPath(outerPath, outerPaint);

//     canvas.drawPath(innerPath, innerPaint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return false;
//   }
// }

class StarburstPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Outer starburst
    final Paint outerPaint = Paint()
      ..color = const Color.fromARGB(
          255, 103, 224, 167) // Outer border color (light green)
      ..style = PaintingStyle.fill;

    // Inner starburst
    final Paint innerPaint = Paint()
      ..color = const Color.fromARGB(82, 67, 236, 165) // Inner green color
      ..style = PaintingStyle.fill;

    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    const int spikes = 18; // Number of spikes
    final double outerRadius = size.width / 2;
    final double innerRadius = outerRadius * 0.85;

    final Path starburstPath = Path();

    final double angle = (2 * pi) / spikes;

    for (int i = 0; i < spikes; i++) {
      // Outer point
      final double outerX = centerX + outerRadius * cos(i * angle);
      final double outerY = centerY + outerRadius * sin(i * angle);

      // Inner point
      final double innerX = centerX + innerRadius * cos(i * angle + angle / 2);
      final double innerY = centerY + innerRadius * sin(i * angle + angle / 2);

      if (i == 0) {
        starburstPath.moveTo(outerX, outerY);
      } else {
        starburstPath.lineTo(outerX, outerY);
        starburstPath.lineTo(innerX, innerY);
      }
    }
    starburstPath.close();

    // Draw outer starburst
    canvas.drawPath(starburstPath, outerPaint);

    // Slightly smaller path for the inner part
    final Path innerStarburstPath = Path();

    for (int i = 0; i < spikes; i++) {
      // Outer point
      final double outerX = centerX + (outerRadius - 5) * cos(i * angle);
      final double outerY = centerY + (outerRadius - 5) * sin(i * angle);

      // Inner point
      final double innerX =
          centerX + (innerRadius - 5) * cos(i * angle + angle / 2);
      final double innerY =
          centerY + (innerRadius - 5) * sin(i * angle + angle / 2);

      if (i == 0) {
        innerStarburstPath.moveTo(outerX, outerY);
      } else {
        innerStarburstPath.lineTo(outerX, outerY);
        innerStarburstPath.lineTo(innerX, innerY);
      }
    }
    innerStarburstPath.close();

    // Draw inner starburst
    canvas.drawPath(innerStarburstPath, innerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: StarburstBadge(text: '99'),
        ),
      ),
    ),
  );
}
