import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoadingWidget extends StatelessWidget {
  final double height;
  final double? width;
  final bool isCircle;
  final EdgeInsetsGeometry? margin;
  final BorderRadius borderRadius;

  const ShimmerLoadingWidget({
    super.key,
    required this.height,
    this.width = double.infinity,
    this.isCircle = false,
    this.margin,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height,
        width: width,
        margin: margin,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: isCircle ? null : borderRadius,
        ),
      ),
    );
  }
}