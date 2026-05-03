import 'package:flutter/material.dart';

import '../../domain/models/selected_domain_item.dart';
import '../../services/category_items_service.dart';

class LeftPanel extends StatelessWidget {
  const LeftPanel({
    super.key,
    required this.selectedCategory,
    required this.itemsFuture,
    required this.selectedItem,
    required this.onCategoryChanged,
    required this.onItemSelected,
  });

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
            DropdownButton<CategoryType>(
              value: selectedCategory,
              isExpanded: true,
              onChanged: (category) {
                if (category != null) {
                  onCategoryChanged(category);
                }
              },
              items: const [
                DropdownMenuItem(
                  value: CategoryType.characters,
                  child: Text('characters'),
                ),
                DropdownMenuItem(
                  value: CategoryType.consoles,
                  child: Text('consoles'),
                ),
                DropdownMenuItem(
                  value: CategoryType.games,
                  child: Text('games'),
                ),
              ],
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
                        'Error cargando elementos',
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
                          child: Image.asset(
                            'assets/images/${item.image}',
                            width: 28,
                            height: 28,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const SizedBox(
                                width: 28,
                                height: 28,
                                child: Icon(Icons.broken_image_outlined, size: 18),
                              );
                            },
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