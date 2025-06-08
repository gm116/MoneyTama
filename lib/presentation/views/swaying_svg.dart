import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SwayingSvg extends StatefulWidget {
  final String svgString;
  final double width;
  final double height;

  const SwayingSvg({
    super.key,
    required this.svgString,
    required this.width,
    required this.height,
  });

  @override
  State<SwayingSvg> createState() => _SwayingSvgState();
}

class _SwayingSvgState extends State<SwayingSvg>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: Tween<double>(begin: -0.05, end: 0.05)
              .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut))
              .value,
          child: child,
        );
      },
      child: SvgPicture.string(
        widget.svgString,
        width: widget.width,
        height: widget.height,
      ),
    );
  }
}
