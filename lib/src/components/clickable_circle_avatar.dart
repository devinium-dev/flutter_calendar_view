import 'package:flutter/material.dart';

class ClickableCircleAvatar extends StatelessWidget {
  final Widget? child;
  final Color? backgroundColor;
  final ImageProvider<Object>? backgroundImage;
  final ImageProvider<Object>? foregroundImage;
  final void Function(Object, StackTrace?)? onBackgroundImageError;
  final void Function(Object, StackTrace?)? onForegroundImageError;
  final Color? foregroundColor;
  final double? radius;
  final double? minRadius;
  final double? maxRadius;
  final void Function()? onTap;

  const ClickableCircleAvatar({
    Key? key,
    this.child,
    this.backgroundColor,
    this.backgroundImage,
    this.foregroundImage,
    this.onBackgroundImageError,
    this.onForegroundImageError,
    this.foregroundColor,
    this.radius,
    this.minRadius,
    this.maxRadius,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(50.0),
        onTap: onTap,
        child: CircleAvatar(
          child: child,
          backgroundColor: backgroundColor,
          backgroundImage: backgroundImage,
          foregroundImage: foregroundImage,
          onBackgroundImageError: onBackgroundImageError,
          onForegroundImageError: onForegroundImageError,
          foregroundColor: foregroundColor,
          radius: radius,
          minRadius: minRadius,
          maxRadius: maxRadius,
        ),
      ),
    );
  }
}
