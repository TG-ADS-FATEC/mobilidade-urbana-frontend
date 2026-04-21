import 'package:flutter/material.dart';

class TCircularImage extends StatelessWidget {
  final String image;
  final double size;
  final bool isNetworkImage;
  final double borderWidth;
  final Color borderColor;
  final BoxFit fit;

  const TCircularImage({
    super.key,
    required this.image,
    this.size = 56,
    this.isNetworkImage = false,
    this.borderWidth = 0,
    this.borderColor = Colors.white,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          padding: EdgeInsets.all(borderWidth),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: borderWidth > 0
                ? Border.all(color: borderColor, width: borderWidth)
                : null,
          ),
          child: ClipOval(
            child: _buildImage(),
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (isNetworkImage) {
      return Image.network(
        image,
        fit: fit,
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    }

    return Image.asset(
      image,
      fit: fit,
      errorBuilder: (_, __, ___) => _placeholder(),
    );
  }

  Widget _placeholder() {
    return Container(
      color: Colors.grey.shade300,
      child: const Icon(Icons.person),
    );
  }
}