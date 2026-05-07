import 'package:flutter/material.dart';

import '../../domain/models/selected_domain_item.dart';
import '../../services/category_items_service.dart';
import 'base64_item_image.dart';

/// Panel derecho: muestra placeholder o detalle del elemento seleccionado.
class RightPanel extends StatelessWidget {
  /// Crea el panel de detalle y recibe el elemento actualmente seleccionado.
  const RightPanel({
    super.key,
    required this.service,
    required this.selectedItem,
  });

  final CategoryItemsService service;
  final SelectedDomainItem? selectedItem;

  @override
  /// Construye el detalle o una guía de selección cuando no hay elemento activo.
  Widget build(BuildContext context) {
    final item = selectedItem;

    return Card(
      child: item == null
          ? Center(
              child: Text(
                'Selecciona un elemento del panel izquierdo',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            )
          : _DetailContent(item: item, service: service),
    );
  }
}

/// Contenido detallado para cualquier tipo de elemento seleccionado.
class _DetailContent extends StatelessWidget {
  /// Crea el bloque de detalle con acceso a datos e imágenes.
  const _DetailContent({required this.item, required this.service});

  final SelectedDomainItem item;
  final CategoryItemsService service;

  @override
  /// Construye un layout centrado y desplazable con imagen + metadatos por tipo.
  Widget build(BuildContext context) {
    final detailTextStyle = Theme.of(context).textTheme.titleMedium;
    final plotTextStyle = Theme.of(context).textTheme.bodyMedium;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            // Mantiene altura mínima para centrar visualmente en pantallas altas.
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 220,
                      child: Center(
                        child: Base64ItemImage(
                          imageName: item.image,
                          service: service,
                          width: 320,
                          height: 220,
                          borderRadius: 12,
                          fit: BoxFit.contain,
                          errorIconSize: 40,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      item.name,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    // Selecciona qué bloque de detalle pintar según el subtipo.
                    if (item is SelectedBookItem) ...[
                      ..._buildBookDetails(item as SelectedBookItem, detailTextStyle, plotTextStyle),
                    ] else if (item is SelectedNobelCountryItem) ...[
                      ..._buildCountryDetails(
                        item as SelectedNobelCountryItem,
                        detailTextStyle,
                        plotTextStyle,
                      ),
                    ] else if (item is SelectedAuthorItem) ...[
                      ..._buildAuthorDetails(item as SelectedAuthorItem, detailTextStyle),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Formatea el rango de vida del autor gestionando el caso de autor vivo.
  String _formatLifetime(SelectedAuthorItem item) {
    final endYear = item.author.yearDead?.toString() ?? 'actualidad';
    return '${item.author.yearBorn} - $endYear';
  }

  /// Construye los widgets de detalle específicos para libros.
  List<Widget> _buildBookDetails(
    SelectedBookItem item,
    TextStyle? detailTextStyle,
    TextStyle? plotTextStyle,
  ) {
    return [
      _DetailText(label: 'Autor', value: item.book.author, style: detailTextStyle),
      const SizedBox(height: 8),
      _DetailText(label: 'Año', value: item.book.year.toString(), style: detailTextStyle),
      const SizedBox(height: 12),
      Text(
        item.book.plot,
        style: plotTextStyle,
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 16),
      _ColorBadge(colorName: item.book.color),
    ];
  }

  /// Construye los widgets de detalle específicos para países Nobel.
  List<Widget> _buildCountryDetails(
    SelectedNobelCountryItem item,
    TextStyle? detailTextStyle,
    TextStyle? plotTextStyle,
  ) {
    return [
      _DetailText(
        label: 'Premios Nobel de Literatura',
        value: item.country.amount.toString(),
        style: detailTextStyle,
      ),
      const SizedBox(height: 8),
      _DetailText(
        label: 'Años ganadores',
        value: item.country.winnerYears,
        style: plotTextStyle,
      ),
      const SizedBox(height: 16),
      _ColorBadge(colorName: item.country.color),
    ];
  }

  /// Construye los widgets de detalle específicos para autores.
  List<Widget> _buildAuthorDetails(
    SelectedAuthorItem item,
    TextStyle? detailTextStyle,
  ) {
    return [
      _DetailText(label: 'Vida', value: _formatLifetime(item), style: detailTextStyle),
      const SizedBox(height: 8),
      _DetailText(label: 'País', value: item.author.country, style: detailTextStyle),
      const SizedBox(height: 16),
      _ColorBadge(colorName: item.author.color),
    ];
  }
}

/// Texto de detalle con formato uniforme `Etiqueta: valor`.
class _DetailText extends StatelessWidget {
  /// Crea una línea de información del panel de detalle.
  const _DetailText({
    required this.label,
    required this.value,
    required this.style,
  });

  final String label;
  final String value;
  final TextStyle? style;

  @override
  /// Renderiza texto centrado para mantener consistencia visual.
  Widget build(BuildContext context) {
    return Text(
      '$label: $value',
      style: style,
      textAlign: TextAlign.center,
    );
  }
}

/// Muestra un círculo coloreado a partir del nombre textual del color.
class _ColorBadge extends StatelessWidget {
  /// Crea la insignia de color para el atributo cromático del elemento.
  const _ColorBadge({required this.colorName});

  final String colorName;

  @override
  /// Dibuja un contenedor circular relleno con el color parseado.
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: _parseColor(colorName),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white24),
      ),
    );
  }

  /// Convierte un nombre de color (API) en una instancia concreta de `Color`.
  Color _parseColor(String value) {
    // Soporta nombres estándar y algunos tonos definidos manualmente.
    switch (value.toLowerCase()) {
      case 'blue':
        return Colors.blue;
      case 'navy':
        return const Color(0xFF001F54);
      case 'royalblue':
        return const Color(0xFF4169E1);
      case 'gold':
        return const Color(0xFFFFD700);
      case 'limegreen':
        return const Color(0xFF32CD32);
      case 'midnightblue':
        return const Color(0xFF191970);
      case 'darkred':
        return const Color(0xFF8B0000);
      case 'silver':
        return const Color(0xFFC0C0C0);
      case 'beige':
        return const Color(0xFFF5F5DC);
      case 'maroon':
        return const Color(0xFF800000);
      case 'darkgreen':
        return const Color(0xFF006400);
      case 'crimson':
        return const Color(0xFFDC143C);
      case 'red':
        return Colors.red;
      case 'green':
        return Colors.green;
      case 'pink':
        return Colors.pink;
      case 'brown':
        return Colors.brown;
      case 'yellow':
        return Colors.yellow;
      case 'grey':
      case 'gray':
        return Colors.grey;
      case 'black':
        return Colors.black;
      case 'white':
        return Colors.white;
      case 'purple':
        return Colors.purple;
      default:
        // Fallback seguro para valores desconocidos.
        return Colors.blueGrey;
    }
  }
}