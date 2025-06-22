import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoadingWidget extends StatelessWidget {
  final double height;
  final double? width;
  final bool isCircle;
  final EdgeInsetsGeometry? margin;
  final BorderRadius borderRadius;
  final bool useGray; // The new parameter you requested

  const ShimmerLoadingWidget({
    super.key,
    required this.height,
    this.width = double.infinity,
    this.isCircle = false,
    this.margin,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.useGray = false, // Defaults to the light version
  });

  @override
  Widget build(BuildContext context) {
    // Determine colors based on the useGray flag
    final baseColor = useGray ? Colors.grey.shade800 : Colors.grey.shade300;
    final highlightColor = useGray ? Colors.grey.shade700 : Colors.grey.shade100;
    final containerColor = useGray ? Colors.grey.shade800 : Colors.white;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        height: height,
        width: width,
        margin: margin,
        decoration: BoxDecoration(
          // The color of the shape itself that gets the shimmer effect
          color: containerColor,
          shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: isCircle ? null : borderRadius,
        ),
      ),
    );
  }
}