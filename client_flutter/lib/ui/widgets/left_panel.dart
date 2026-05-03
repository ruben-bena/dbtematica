import 'package:flutter/material.dart';

import '../../domain/models/selected_domain_item.dart';
import '../../services/category_items_service.dart';
import 'base64_item_image.dart';

class LeftPanel extends StatelessWidget {
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
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error cargando la categoría',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    );
                  }

                  final items = snapshot.data ?? <SelectedDomainItem>[];
                  if (items.isEmpty) {
                    return Center(
                      child: Text(
                        'No hay elementos',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    );
                  }

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

class _CategoryButtons extends StatelessWidget {
  const _CategoryButtons({
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  final CategoryType selectedCategory;
  final ValueChanged<CategoryType> onCategoryChanged;

  @override
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

class _CategoryButton extends StatelessWidget {
  const _CategoryButton({
    required this.text,
    required this.selected,
    required this.onPressed,
  });

  final String text;
  final bool selected;
  final VoidCallback onPressed;

  @override
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