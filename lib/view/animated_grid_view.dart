import 'package:flutter/material.dart';

class AnimatedGridView extends StatefulWidget {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final SliverGridDelegate gridDelegate;
  final Duration itemAnimationDuration;
  final Duration staggerDuration;
  final EdgeInsetsGeometry? padding;

  const AnimatedGridView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.gridDelegate = const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1,
    ),
    this.itemAnimationDuration = const Duration(milliseconds: 500),
    this.staggerDuration = const Duration(milliseconds: 150),
    this.padding,
  });

  @override
  State<AnimatedGridView> createState() => _AnimatedGridViewState();
}

class _AnimatedGridViewState extends State<AnimatedGridView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Duration _totalDuration;

  @override
  void initState() {
    super.initState();
    _totalDuration = widget.itemAnimationDuration +
        widget.staggerDuration * (widget.itemCount - 1);
    _controller = AnimationController(vsync: this, duration: _totalDuration)
      ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildAnimatedItem(int index, Widget child) {
    final double start = (widget.staggerDuration.inMilliseconds * index) /
        _totalDuration.inMilliseconds;
    final double end = (start +
        widget.itemAnimationDuration.inMilliseconds /
            _totalDuration.inMilliseconds)
        .clamp(0.0, 1.0);

    final Animation<double> fade = CurvedAnimation(
      parent: _controller,
      curve: Interval(start, end, curve: Curves.easeOut),
    );

    final Animation<Offset> slide = Tween<Offset>(
      begin: const Offset(0, 0.18),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(start, end, curve: Curves.easeOut),
    ));

    return FadeTransition(
      opacity: fade,
      child: SlideTransition(
        position: slide,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: widget.padding,
      itemCount: widget.itemCount,
      gridDelegate: widget.gridDelegate,
      itemBuilder: (context, index) {
        final child = widget.itemBuilder(context, index);
        return _buildAnimatedItem(index, child);
      },
    );
  }
}
