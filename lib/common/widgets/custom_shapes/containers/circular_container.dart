import 'package:flutter/material.dart';
import '../../../../../utils/constants/colors.dart';

/// A circular container widget with optional child, border, and styling.
class TCircularContainer extends StatelessWidget {
  /// Create a circular container.
  const TCircularContainer({
    super.key,
    this.child,
    this.margin,
    this.padding,
    this.width = 400,
    this.height = 400,
    this.radius = 400,
    this.showBorder = false,
    this.backgroundColor = TColors.white,
    this.borderColor = TColors.borderPrimary,
    this.shadow,
  })  : assert(radius >= 0, 'Radius cannot be negative'),
        assert(width == null || width >= 0, 'Width cannot be negative'),
        assert(height == null || height >= 0, 'Height cannot be negative');

  final Widget? child;
  final double? width;
  final double radius;
  final double? height;
  final bool showBorder;
  final Color borderColor;
  final Color backgroundColor;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final BoxShadow? shadow;

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = radius > 0 ? radius : (width ?? height ?? 0) / 2;

    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(effectiveRadius),
        border: showBorder ? Border.all(color: borderColor) : null,
        boxShadow: shadow != null ? [shadow!] : null,
      ),
      child: child,
    );
  }
}
