import 'package:flutter/material.dart';

import '../../domain/models/selected_domain_item.dart';

class RightPanel extends StatelessWidget {
  const RightPanel({
    super.key,
    required this.selectedItem,
  });

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
          : _DetailContent(item: item),
    );
  }
}

class _DetailContent extends StatelessWidget {
  const _DetailContent({required this.item});

  final SelectedDomainItem item;

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
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/images/${item.image}',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(child: Icon(Icons.broken_image_outlined, size: 40));
                          },
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