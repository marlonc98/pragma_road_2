import 'package:flutter/material.dart';

class ImageNetworkWithLoadWidget extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;

  const ImageNetworkWithLoadWidget(
    this.imageUrl, {
    super.key,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final placeholderColor = Theme.of(context)
        .colorScheme
        .surfaceContainerHighest;
    return Image.network(
      imageUrl,
      height: height,
      width: width,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) => progress == null
          ? child
          : _placeholder(
              placeholderColor,
              const CircularProgressIndicator(strokeWidth: 2),
            ),
      errorBuilder: (context, error, stackTrace) => _placeholder(
        placeholderColor,
        const Icon(Icons.broken_image_outlined, size: 40),
      ),
    );
  }

  Widget _placeholder(Color color, Widget child) => Container(
    height: height,
    width: width,
    color: color,
    alignment: Alignment.center,
    child: child,
  );
}
