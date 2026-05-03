import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../services/category_items_service.dart';

class Base64ItemImage extends StatelessWidget {
  const Base64ItemImage({
    super.key,
    required this.imageName,
    required this.service,
    required this.width,
    required this.height,
    this.borderRadius,
    this.fit = BoxFit.cover,
    this.errorIconSize = 18,
  });

  final String imageName;
  final CategoryItemsService service;
  final double width;
  final double height;
  final double? borderRadius;
  final BoxFit fit;
  final double errorIconSize;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: service.loadImageBytes(imageName),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            width: width,
            height: height,
            child: const Center(
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }

        final bytes = snapshot.data;
        if (bytes == null) {
          return SizedBox(
            width: width,
            height: height,
            child: Icon(Icons.broken_image_outlined, size: errorIconSize),
          );
        }

        final image = Image.memory(
          bytes,
          width: width,
          height: height,
          fit: fit,
          gaplessPlayback: true,
        );

        if (borderRadius == null) {
          return image;
        }

        return ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius!),
          child: image,
        );
      },
    );
  }
}
