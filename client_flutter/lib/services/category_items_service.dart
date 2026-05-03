import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import '../domain/models/author.dart';
import '../domain/models/book.dart';
import '../domain/models/nobel_country.dart';
import '../domain/models/selected_domain_item.dart';

enum CategoryType { authors, books, nobelCountries }

extension CategoryTypeApi on CategoryType {
  String get apiValue {
    switch (this) {
      case CategoryType.authors:
        return 'authors';
      case CategoryType.books:
        return 'books';
      case CategoryType.nobelCountries:
        return 'nobelCountries';
    }
  }

  String get label {
    switch (this) {
      case CategoryType.authors:
        return 'Autores';
      case CategoryType.books:
        return 'Libros';
      case CategoryType.nobelCountries:
        return 'Países Nobel';
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
      case CategoryType.authors:
        final authors = decoded
            .map((item) => Author.fromJson(item as Map<String, dynamic>))
            .toList();
        return authors.map((author) => SelectedAuthorItem(author)).toList();
      case CategoryType.books:
        final books = decoded
            .map((item) => Book.fromJson(item as Map<String, dynamic>))
            .toList();
        return books.map((book) => SelectedBookItem(book)).toList();
      case CategoryType.nobelCountries:
        final countries = decoded
            .map((item) => NobelCountry.fromJson(item as Map<String, dynamic>))
            .toList();
        return countries.map((country) => SelectedNobelCountryItem(country)).toList();
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