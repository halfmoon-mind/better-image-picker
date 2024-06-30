import 'dart:async';

import 'package:flutter/material.dart';

class ZourneyScrollbar extends StatefulWidget {
  final Widget child;
  final ScrollController controller;
  final String Function(double offset)? labelBuilder;
  final double? maxScrollExtent;

  const ZourneyScrollbar({
    Key? key,
    required this.child,
    required this.controller,
    this.labelBuilder,
    this.maxScrollExtent,
  }) : super(key: key);

  @override
  State<ZourneyScrollbar> createState() => _ZourneyScrollbarState();
}

class _ZourneyScrollbarState extends State<ZourneyScrollbar>
    with TickerProviderStateMixin {
  final double _thumbHeight = 40;
  final double _verticalMargin = 10;
  double _bottomPadding = 0; // SafeArea를 고려한 스크롤의 최하단 위치
  double _thumbOffset = 0;

  late AnimationController _animationController;
  late Animation<double> _animation;
  Timer? _timer;

  bool _showLabel = false;

  double get _minThumbOffest => _verticalMargin;
  double get _maxThumbOffest =>
      widget.controller.position.viewportDimension - _bottomPadding;

  double get _pixels => widget.controller.position.pixels;
  double get _maxScrollExtent =>
      widget.maxScrollExtent ?? widget.controller.position.maxScrollExtent;

  @override
  void initState() {
    _thumbOffset = _verticalMargin;
    _bottomPadding =
        _thumbHeight + _verticalMargin + MediaQuery.of(context).padding.bottom;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.fastOutSlowIn,
    );

    widget.controller.addListener(() {
      if (!mounted) return;

      _thumbOffset = _minThumbOffest +
          (_pixels / _maxScrollExtent * (_maxThumbOffest - _minThumbOffest));

      if (_thumbOffset < _minThumbOffest) {
        _thumbOffset = _minThumbOffest;
      }

      if (_thumbOffset > _maxThumbOffest) {
        _thumbOffset = _maxThumbOffest;
      }

      setState(() {});

      if (_animationController.isDismissed && mounted) {
        _animationController.forward();
      }

      _timer?.cancel();
      _timer = Timer(const Duration(seconds: 2), () {
        if (mounted) {
          _animationController.reverse();
        }

        _timer = null;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Stack(
        children: [
          RepaintBoundary(child: widget.child),
          RepaintBoundary(
            child: GestureDetector(
              onVerticalDragStart: _onVerticalDragStart,
              onVerticalDragUpdate: _onVerticalDragUpdate,
              onVerticalDragEnd: _onVerticalDragEnd,
              child: Container(
                alignment: Alignment.topRight,
                margin: EdgeInsets.only(top: _thumbOffset, right: 5),
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) =>
                      _animation.value == 0.0 ? Container() : child!,
                  child: SlideTransition(
                    position: Tween(
                      begin: const Offset(1.0, 0.0),
                      end: const Offset(0.0, 0.0),
                    ).animate(_animation),
                    child: FadeTransition(
                      opacity: _animation,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (_showLabel)
                            Container(
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                              ),
                              child: Text(
                                () {
                                  if (widget.labelBuilder == null) {
                                    return "";
                                  }

                                  return widget.labelBuilder!(_pixels);
                                }(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          Container(
                            width: 26,
                            height: _thumbHeight,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.9),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(13)),
                            ),
                            child: const Icon(
                              Icons.unfold_more_rounded,
                              size: 26,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  void _onVerticalDragStart(DragStartDetails details) {
    if (!mounted) return;

    if (widget.labelBuilder == null) {
      return;
    }

    _showLabel = true;

    setState(() {});
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    if (!mounted) return;

    double offest = _thumbOffset + details.delta.dy;

    if (offest < _minThumbOffest) {
      offest = _minThumbOffest;
    }
    if (offest > _maxThumbOffest) {
      offest = _maxThumbOffest;
    }

    final scrollExtent = (offest - _minThumbOffest) /
        (_maxThumbOffest - _minThumbOffest) *
        _maxScrollExtent;

    widget.controller.jumpTo(scrollExtent);
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    if (!mounted) return;

    if (widget.labelBuilder == null) {
      return;
    }

    _showLabel = false;
    setState(() {});
  }
}
