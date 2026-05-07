import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../services/category_items_service.dart';

/// Widget reutilizable que renderiza imágenes remotas codificadas en base64.
class Base64ItemImage extends StatelessWidget {
  /// Crea un contenedor de imagen configurable con tamaño, ajuste y bordes opcionales.
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
  /// Construye la imagen resolviendo el `Future` de bytes y gestionando estados de carga/error.
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: service.loadImageBytes(imageName),
      builder: (context, snapshot) {
        // Mientras se resuelve la descarga/decodificación, muestra un spinner compacto.
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
        // Si no hay bytes válidos, muestra icono de imagen rota en el área reservada.
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

        // Cuando hay radio configurado, aplica recorte para esquinas redondeadas.
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
