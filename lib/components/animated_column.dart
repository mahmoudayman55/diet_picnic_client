import 'package:flutter/material.dart';

class AnimatedColumn extends StatefulWidget {
  final List<Widget> children;
  final Duration duration;
  final double slideOffset;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;

  const AnimatedColumn({
    Key? key,
    required this.children,
    this.duration = const Duration(milliseconds: 1200),
    this.slideOffset = 0.3,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.min,
  }) : super(key: key);

  @override
  State<AnimatedColumn> createState() => _AnimatedColumnState();
}

class _AnimatedColumnState extends State<AnimatedColumn>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<Offset>> _slideAnimations;
  late List<Animation<double>> _fadeAnimations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _setupAnimations();
    _controller.forward();
  }

  /// 🔹 Rebuild animations if children count changes
  @override
  void didUpdateWidget(covariant AnimatedColumn oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.children.length != widget.children.length) {
      _setupAnimations();
      _controller.forward(from: 0);
    }
  }

  void _setupAnimations() {
    _slideAnimations = List.generate(
      widget.children.length,
          (index) => Tween<Offset>(
        begin: Offset(0, widget.slideOffset),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(index * 0.1, 1, curve: Curves.easeOut),
        ),
      ),
    );

    _fadeAnimations = List.generate(
      widget.children.length,
          (index) => Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(index * 0.1, 1, curve: Curves.easeIn),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: widget.mainAxisAlignment,
      crossAxisAlignment: widget.crossAxisAlignment,
      mainAxisSize: widget.mainAxisSize,
      children: List.generate(widget.children.length, (index) {
        return SlideTransition(
          position: _slideAnimations[index],
          child: FadeTransition(
            opacity: _fadeAnimations[index],
            child: widget.children[index],
          ),
        );
      }),
    );
  }
}
