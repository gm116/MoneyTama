import 'package:flutter/material.dart';

class AnalyticalPieChart extends StatefulWidget {
  final List<PieChartSegment> data;
  final Duration animationDuration;

  const AnalyticalPieChart({
    super.key,
    required this.data,
    this.animationDuration = const Duration(seconds: 2),
  });

  @override
  AnalyticalPieChartState createState() => AnalyticalPieChartState();
}

class AnalyticalPieChartState extends State<AnalyticalPieChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 360).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          painter: PieChartPainter(widget.data, _animation.value),
        );
      },
    );
  }
}

class PieChartPainter extends CustomPainter {
  final List<PieChartSegment> data;
  final double sweepAngle;

  PieChartPainter(this.data, this.sweepAngle);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..isAntiAlias = true;

    final pi = 3.141592653589793;
    final double radius = size.width / 2;
    final Offset center = Offset(size.width / 2, size.height / 2);
    double startAngle = -90;

    for (var item in data) {
      final double percentage = item.percentage;
      final Color color = item.color;
      paint.color = color;

      final double angle = 360 * (percentage / 100);
      if (startAngle + angle <= sweepAngle) {
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          startAngle * (pi / 180),
          angle * (pi / 180),
          false,
          paint,
        );
      } else if (startAngle < sweepAngle) {
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          startAngle * (pi / 180),
          (sweepAngle - startAngle) * (pi / 180),
          false,
          paint,
        );
      }
      startAngle += angle;
    }

    // Draw text in the center
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: 'Total',
        style: TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(center.dx - textPainter.width / 2,
          center.dy - textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class PieChartSegment {
  final double percentage;
  final Color color;
  final String category;

  PieChartSegment({required this.percentage, required this.color, required this.category});

  @override
  String toString() {
    return 'PieChartSegment(percentage: $percentage, color: $color)';
  }
}
