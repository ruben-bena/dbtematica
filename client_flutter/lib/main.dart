import 'package:flutter/material.dart';

import 'domain/models/selected_domain_item.dart';
import 'services/category_items_service.dart';
import 'ui/widgets/left_panel.dart';
import 'ui/widgets/right_panel.dart';

void main() {
  runApp(const DbTematicaApp());
}

class DbTematicaApp extends StatelessWidget {
  const DbTematicaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DbTemática',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const MainSplitView(),
    );
  }
}

class MainSplitView extends StatefulWidget {
  const MainSplitView({super.key});

  @override
  State<MainSplitView> createState() => _MainSplitViewState();
}

class _MainSplitViewState extends State<MainSplitView> {
  static const CategoryItemsService _service = CategoryItemsService();
  static const _desktopOuterPadding = 24.0;
  static const _desktopPanelsGap = 24.0;

  late CategoryType _selectedCategory;
  late Future<List<SelectedDomainItem>> _itemsFuture;
  SelectedDomainItem? _selectedItem;
  double? _initialWindowWidth;

  @override
  void initState() {
    super.initState();
    _selectedCategory = CategoryType.characters;
    _itemsFuture = _service.loadItems(_selectedCategory);
  }

  void _onItemSelected(SelectedDomainItem? item) {
    setState(() {
      _selectedItem = item;
    });
  }

  void _onCategoryChanged(CategoryType category) {
    setState(() {
      _selectedCategory = category;
      _itemsFuture = _service.loadItems(category);
      _selectedItem = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _initialWindowWidth ??= constraints.maxWidth;
        final leftPanelWidth = _calculateLeftPanelWidth(constraints.maxWidth);
        final rightPanelWidth = _calculateRightPanelWidth(
          constraints.maxWidth,
          leftPanelWidth,
        );
        final isMobile = rightPanelWidth < leftPanelWidth;

        return Scaffold(
          appBar: AppBar(
            title: Text(isMobile ? 'Mobile View' : 'Desktop View'),
          ),
          body: isMobile ? _buildMobileView() : _buildDesktopView(leftPanelWidth),
        );
      },
    );
  }

  double _calculateLeftPanelWidth(double currentWindowWidth) {
    final desiredLeftPanelWidth = (_initialWindowWidth ?? currentWindowWidth) / 4;
    final availableRowWidth =
        (currentWindowWidth - (_desktopOuterPadding * 2)).clamp(0.0, double.infinity);
    final maxLeftPanelWidth = (availableRowWidth - _desktopPanelsGap).clamp(0.0, double.infinity);

    return desiredLeftPanelWidth.clamp(0.0, maxLeftPanelWidth);
  }

  double _calculateRightPanelWidth(double currentWindowWidth, double leftPanelWidth) {
    final availableRowWidth =
        (currentWindowWidth - (_desktopOuterPadding * 2)).clamp(0.0, double.infinity);

    return (availableRowWidth - leftPanelWidth - _desktopPanelsGap).clamp(0.0, double.infinity);
  }

  Widget _buildDesktopView(double leftPanelWidth) {

    return Padding(
      padding: const EdgeInsets.all(_desktopOuterPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: leftPanelWidth,
            child: LeftPanel(
              selectedCategory: _selectedCategory,
              itemsFuture: _itemsFuture,
              selectedItem: _selectedItem,
              onCategoryChanged: _onCategoryChanged,
              onItemSelected: _onItemSelected,
            ),
          ),
          const SizedBox(width: _desktopPanelsGap),
          Expanded(
            child: RightPanel(selectedItem: _selectedItem),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileView() {
    if (_selectedItem == null) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: LeftPanel(
          selectedCategory: _selectedCategory,
          itemsFuture: _itemsFuture,
          selectedItem: _selectedItem,
          onCategoryChanged: _onCategoryChanged,
          onItemSelected: _onItemSelected,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => _onItemSelected(null),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Volver'),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: RightPanel(selectedItem: _selectedItem),
          ),
        ],
      ),
    );
  }
}
