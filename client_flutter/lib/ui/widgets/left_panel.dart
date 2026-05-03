import 'package:flutter/material.dart';

import '../../domain/models/selected_domain_item.dart';
import '../../services/category_items_service.dart';

class LeftPanel extends StatefulWidget {
  const LeftPanel({
    super.key,
    required this.onItemSelected,
  });

  final ValueChanged<SelectedDomainItem?> onItemSelected;

  @override
  State<LeftPanel> createState() => _LeftPanelState();
}

class _LeftPanelState extends State<LeftPanel> {
  static const CategoryItemsService _service = CategoryItemsService();

  late CategoryType _selectedCategory;
  late Future<List<SelectedDomainItem>> _itemsFuture;

  @override
  void initState() {
    super.initState();
    _selectedCategory = CategoryType.characters;
    _itemsFuture = _service.loadItems(_selectedCategory);
  }

  void _onCategoryChanged(CategoryType? category) {
    if (category == null) {
      return;
    }

    setState(() {
      _selectedCategory = category;
      _itemsFuture = _service.loadItems(category);
    });

    widget.onItemSelected(null);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButton<CategoryType>(
              value: _selectedCategory,
              isExpanded: true,
              onChanged: _onCategoryChanged,
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
                future: _itemsFuture,
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
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        onTap: () => widget.onItemSelected(item),
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