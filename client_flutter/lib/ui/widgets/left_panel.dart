import 'package:flutter/material.dart';

import '../../domain/models/selected_domain_item.dart';
import '../../services/category_items_service.dart';
import 'base64_item_image.dart';

/// Panel izquierdo: selector de categoría y listado de elementos.
class LeftPanel extends StatelessWidget {
  /// Crea el panel de navegación con callbacks de categoría y selección.
  const LeftPanel({
    super.key,
    required this.service,
    required this.selectedCategory,
    required this.itemsFuture,
    required this.selectedItem,
    required this.onCategoryChanged,
    required this.onItemSelected,
  });

  final CategoryItemsService service;
  final CategoryType selectedCategory;
  final Future<List<SelectedDomainItem>> itemsFuture;
  final SelectedDomainItem? selectedItem;
  final ValueChanged<CategoryType> onCategoryChanged;
  final ValueChanged<SelectedDomainItem?> onItemSelected;

  @override
  /// Construye el contenido del panel con estados de carga/error/vacío.
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _CategoryButtons(
              selectedCategory: selectedCategory,
              onCategoryChanged: onCategoryChanged,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<SelectedDomainItem>>(
                future: itemsFuture,
                builder: (context, snapshot) {
                  // Estado de carga inicial de la categoría seleccionada.
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // Si la petición falla, se muestra un mensaje simple de error.
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error cargando la categoría',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    );
                  }

                  final items = snapshot.data ?? <SelectedDomainItem>[];
                  // Si no hay datos para la categoría, se informa explícitamente.
                  if (items.isEmpty) {
                    return Center(
                      child: Text(
                        'No hay elementos',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    );
                  }

                  // Renderiza la lista separada con estado de selección por tipo + nombre.
                  return ListView.separated(
                    itemCount: items.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final isSelected = selectedItem != null &&
                          selectedItem.runtimeType == item.runtimeType &&
                          selectedItem!.name == item.name;

                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        selected: isSelected,
                        onTap: () => onItemSelected(item),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Base64ItemImage(
                            imageName: item.image,
                            service: service,
                            width: 28,
                            height: 28,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(item.name),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Grupo vertical de botones para cambiar rápidamente de categoría.
class _CategoryButtons extends StatelessWidget {
  /// Crea la botonera interna de categorías.
  const _CategoryButtons({
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  final CategoryType selectedCategory;
  final ValueChanged<CategoryType> onCategoryChanged;

  @override
  /// Construye los tres botones con estado visual según categoría activa.
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _CategoryButton(
          text: CategoryType.authors.label,
          selected: selectedCategory == CategoryType.authors,
          onPressed: () => onCategoryChanged(CategoryType.authors),
        ),
        const SizedBox(height: 8),
        _CategoryButton(
          text: CategoryType.books.label,
          selected: selectedCategory == CategoryType.books,
          onPressed: () => onCategoryChanged(CategoryType.books),
        ),
        const SizedBox(height: 8),
        _CategoryButton(
          text: CategoryType.nobelCountries.label,
          selected: selectedCategory == CategoryType.nobelCountries,
          onPressed: () => onCategoryChanged(CategoryType.nobelCountries),
        ),
      ],
    );
  }
}

/// Botón individual de categoría con variante rellena/contorno.
class _CategoryButton extends StatelessWidget {
  /// Crea un botón con texto, estado de selección y acción.
  const _CategoryButton({
    required this.text,
    required this.selected,
    required this.onPressed,
  });

  final String text;
  final bool selected;
  final VoidCallback onPressed;

  @override
  /// Elige `FilledButton` si está seleccionado y `OutlinedButton` en caso contrario.
  Widget build(BuildContext context) {
    if (selected) {
      return FilledButton(
        onPressed: onPressed,
        child: Text(text),
      );
    }

    return OutlinedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}