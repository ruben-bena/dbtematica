import 'package:flutter/material.dart';

import 'config/app_config.dart';
import 'domain/models/selected_domain_item.dart';
import 'services/category_items_service.dart';
import 'ui/widgets/left_panel.dart';
import 'ui/widgets/right_panel.dart';

/// Punto de entrada de la aplicación Flutter.
void main() {
  runApp(const DbTematicaApp());
}

/// Widget raíz que configura tema, título y pantalla principal.
class DbTematicaApp extends StatelessWidget {
  /// Crea la app principal sin estado mutable.
  const DbTematicaApp({super.key});

  @override
  /// Construye el `MaterialApp` con configuración global de UI.
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DbTemática literaria',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const MainSplitView(),
    );
  }
}

/// Contenedor principal que adapta la UI entre escritorio y móvil.
class MainSplitView extends StatefulWidget {
  /// Crea la vista principal con estado para selección y tamaño.
  const MainSplitView({super.key});

  @override
  /// Inicializa el estado asociado a `MainSplitView`.
  State<MainSplitView> createState() => _MainSplitViewState();
}

class _MainSplitViewState extends State<MainSplitView> {
  final CategoryItemsService _service = CategoryItemsService(baseUrl: AppConfig.serverBaseUrl);
  static const _desktopOuterPadding = 24.0;
  static const _desktopPanelsGap = 24.0;

  late CategoryType _selectedCategory;
  late Future<List<SelectedDomainItem>> _itemsFuture;
  SelectedDomainItem? _selectedItem;
  double? _initialWindowWidth;

  @override
  /// Inicializa la categoría por defecto y carga sus elementos.
  void initState() {
    super.initState();
    _selectedCategory = CategoryType.authors;
    _itemsFuture = _service.loadItems(_selectedCategory);
  }

  /// Actualiza el elemento seleccionado en el panel de detalle.
  void _onItemSelected(SelectedDomainItem? item) {
    setState(() {
      _selectedItem = item;
    });
  }

  /// Cambia de categoría, recarga lista y limpia la selección previa.
  void _onCategoryChanged(CategoryType category) {
    setState(() {
      _selectedCategory = category;
      _itemsFuture = _service.loadItems(category);
      _selectedItem = null;
    });
  }

  @override
  /// Decide entre layout móvil o escritorio según el ancho disponible.
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Conserva el ancho inicial para fijar proporción del panel izquierdo.
        _initialWindowWidth ??= constraints.maxWidth;
        final leftPanelWidth = _calculateLeftPanelWidth(constraints.maxWidth);
        final rightPanelWidth = _calculateRightPanelWidth(
          constraints.maxWidth,
          leftPanelWidth,
        );
        // Si el panel derecho queda más pequeño que el izquierdo, se usa modo móvil.
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

  /// Calcula el ancho del panel izquierdo respetando márgenes y separación.
  double _calculateLeftPanelWidth(double currentWindowWidth) {
    // Objetivo: cuarto del ancho inicial de la ventana.
    final desiredLeftPanelWidth = (_initialWindowWidth ?? currentWindowWidth) / 4;
    // Ancho total disponible descontando padding exterior.
    final availableRowWidth =
        (currentWindowWidth - (_desktopOuterPadding * 2)).clamp(0.0, double.infinity);
    // Límite superior para asegurar espacio mínimo del panel derecho y gap.
    final maxLeftPanelWidth = (availableRowWidth - _desktopPanelsGap).clamp(0.0, double.infinity);

    return desiredLeftPanelWidth.clamp(0.0, maxLeftPanelWidth);
  }

  /// Calcula el ancho del panel derecho a partir del espacio restante.
  double _calculateRightPanelWidth(double currentWindowWidth, double leftPanelWidth) {
    final availableRowWidth =
        (currentWindowWidth - (_desktopOuterPadding * 2)).clamp(0.0, double.infinity);

    return (availableRowWidth - leftPanelWidth - _desktopPanelsGap).clamp(0.0, double.infinity);
  }

  /// Construye la disposición en dos columnas para escritorio.
  Widget _buildDesktopView(double leftPanelWidth) {
    return Padding(
      padding: const EdgeInsets.all(_desktopOuterPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: leftPanelWidth,
            child: LeftPanel(
              service: _service,
              selectedCategory: _selectedCategory,
              itemsFuture: _itemsFuture,
              selectedItem: _selectedItem,
              onCategoryChanged: _onCategoryChanged,
              onItemSelected: _onItemSelected,
            ),
          ),
          const SizedBox(width: _desktopPanelsGap),
          Expanded(
            child: RightPanel(
              service: _service,
              selectedItem: _selectedItem,
            ),
          ),
        ],
      ),
    );
  }

  /// Construye la navegación móvil: lista o detalle según selección actual.
  Widget _buildMobileView() {
    // Sin elemento seleccionado, se muestra la lista completa.
    if (_selectedItem == null) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: LeftPanel(
          service: _service,
          selectedCategory: _selectedCategory,
          itemsFuture: _itemsFuture,
          selectedItem: _selectedItem,
          onCategoryChanged: _onCategoryChanged,
          onItemSelected: _onItemSelected,
        ),
      );
    }

    // Con elemento seleccionado, se muestra detalle con botón de retorno.
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
            child: RightPanel(
              service: _service,
              selectedItem: _selectedItem,
            ),
          ),
        ],
      ),
    );
  }
}
