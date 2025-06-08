import 'dart:ui';

class ChartSegment {
  final double percentage;
  final Color color;
  final String category;

  ChartSegment(
      {required this.percentage, required this.color, required this.category});

  @override
  String toString() {
    return 'ChartSegment(percentage: $percentage, color: $color)';
  }
}
