import 'package:flutter/material.dart';

class CircularProgressWithDuration extends StatefulWidget {
  final Duration duration;

  CircularProgressWithDuration({required this.duration});

  @override
  _CircularProgressWithDurationState createState() =>
      _CircularProgressWithDurationState();
}

class _CircularProgressWithDurationState
    extends State<CircularProgressWithDuration> with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return CircularProgressIndicator(
          value: _animationController.value,
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}