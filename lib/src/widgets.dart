import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget? child;
  final BorderSide side;
  final Color backgroundColor;

  const CustomCard({
    Key? key,
    this.child,
    this.side = BorderSide.none,
    this.backgroundColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
            border: Border.fromBorderSide(side),
            shape: BoxShape.rectangle,
            color: backgroundColor),
        child: child,
      ),
    );
  }
}

class IconCard extends StatelessWidget {
  final IconData iconData;
  final double? iconSize;
  final Color? color;

  const IconCard({Key? key, required this.iconData, this.iconSize, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Icon(
        iconData,
        color: color,
        size: iconSize,
      ),
    );
  }
}

class FAB extends StatelessWidget {
  final Object? heroTag;
  final Widget? child;
  final Color? backgroundColor;
  final void Function()? onPressed;
  final double diameter;
  final double elevation;
  final String? tooltip;

  const FAB({
    Key? key,
    this.onPressed,
    this.child,
    this.diameter = 55,
    this.elevation = 2,
    this.heroTag,
    this.backgroundColor,
    this.tooltip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: diameter,
      height: diameter,
      child: FloatingActionButton(
        backgroundColor: backgroundColor,
        elevation: elevation,
        heroTag: heroTag,
        onPressed: onPressed,
        tooltip: tooltip,
        child: child,
      ),
    );
  }
}
