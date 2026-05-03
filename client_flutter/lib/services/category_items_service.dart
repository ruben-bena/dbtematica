import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import '../domain/models/character.dart';
import '../domain/models/console.dart';
import '../domain/models/game.dart';
import '../domain/models/selected_domain_item.dart';

enum CategoryType { characters, consoles, games }

extension CategoryTypeApi on CategoryType {
  String get apiValue {
    switch (this) {
      case CategoryType.characters:
        return 'characters';
      case CategoryType.consoles:
        return 'consoles';
      case CategoryType.games:
        return 'games';
    }
  }

  String get label {
    switch (this) {
      case CategoryType.characters:
        return 'characters';
      case CategoryType.consoles:
        return 'consoles';
      case CategoryType.games:
        return 'games';
    }
  }
}

class CategoryItemsService {
  CategoryItemsService({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        _baseUrl = baseUrl ?? const String.fromEnvironment('API_BASE_URL', defaultValue: 'http://localhost:3000');

  final http.Client _client;
  final String _baseUrl;
  final Map<String, Future<Uint8List?>> _imageCache = {};

  Future<List<SelectedDomainItem>> loadItems(CategoryType category) async {
    final uri = Uri.parse('$_baseUrl/categorias');
    final response = await _client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'categoria': category.apiValue}),
    );

    if (response.statusCode != 200) {
      throw Exception('Error cargando categoría ${category.apiValue}');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! List<dynamic>) {
      throw Exception('Formato de respuesta inválido para categoría ${category.apiValue}');
    }

    switch (category) {
      case CategoryType.characters:
        final characters = decoded
            .map((item) => Character.fromJson(item as Map<String, dynamic>))
            .toList();
        return characters.map((character) => SelectedCharacterItem(character)).toList();
      case CategoryType.consoles:
        final consoles = decoded
            .map((item) => Console.fromJson(item as Map<String, dynamic>))
            .toList();
        return consoles.map((console) => SelectedConsoleItem(console)).toList();
      case CategoryType.games:
        final games = decoded
            .map((item) => Game.fromJson(item as Map<String, dynamic>))
            .toList();
        return games.map((game) => SelectedGameItem(game)).toList();
    }
  }

  Future<Uint8List?> loadImageBytes(String imageName) {
    return _imageCache.putIfAbsent(imageName, () => _loadImageBytes(imageName));
  }

  Future<Uint8List?> _loadImageBytes(String imageName) async {
    final uri = Uri.parse('$_baseUrl/imagen').replace(queryParameters: {'nombre': imageName});
    final response = await _client.get(uri);

    if (response.statusCode != 200) {
      return null;
    }

    final body = jsonDecode(response.body);
    if (body is! Map<String, dynamic>) {
      return null;
    }

    final base64String = body['base64'];
    if (base64String is! String || base64String.isEmpty) {
      return null;
    }

    return base64Decode(base64String);
  }
}