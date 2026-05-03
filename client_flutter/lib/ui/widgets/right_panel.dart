import 'package:flutter/material.dart';

import '../../domain/models/selected_domain_item.dart';
import '../../services/category_items_service.dart';
import 'base64_item_image.dart';

class RightPanel extends StatelessWidget {
  const RightPanel({
    super.key,
    required this.service,
    required this.selectedItem,
  });

  final CategoryItemsService service;
  final SelectedDomainItem? selectedItem;

  @override
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

class _DetailContent extends StatelessWidget {
  const _DetailContent({required this.item, required this.service});

  final SelectedDomainItem item;
  final CategoryItemsService service;

  @override
  Widget build(BuildContext context) {
    final detailTextStyle = Theme.of(context).textTheme.titleMedium;
    final plotTextStyle = Theme.of(context).textTheme.bodyMedium;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
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
                    if (item is SelectedGameItem) ...[
                      Text(
                        (item as SelectedGameItem).game.type,
                        style: detailTextStyle,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        (item as SelectedGameItem).game.year.toString(),
                        style: detailTextStyle,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        (item as SelectedGameItem).game.plot,
                        style: plotTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ] else if (item is SelectedConsoleItem) ...[
                      Text(
                        (item as SelectedConsoleItem).console.date,
                        style: detailTextStyle,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        (item as SelectedConsoleItem).console.procesador,
                        style: detailTextStyle,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        (item as SelectedConsoleItem).console.unitsSold.toString(),
                        style: detailTextStyle,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      _ColorDot(colorName: (item as SelectedConsoleItem).console.color),
                    ] else if (item is SelectedCharacterItem) ...[
                      Text(
                        (item as SelectedCharacterItem).character.game,
                        style: detailTextStyle,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      _ColorDot(colorName: (item as SelectedCharacterItem).character.color),
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
}

class _ColorDot extends StatelessWidget {
  const _ColorDot({required this.colorName});

  final String colorName;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: _parseColor(colorName),
        shape: BoxShape.circle,
      ),
    );
  }

  Color _parseColor(String value) {
    switch (value.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'green':
        return Colors.green;
      case 'pink':
        return Colors.pink;
      case 'orange':
        return Colors.orange;
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
        return Colors.blueGrey;
    }
  }
}