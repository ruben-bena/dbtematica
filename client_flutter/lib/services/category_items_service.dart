import 'dart:convert';

import 'package:flutter/services.dart';

import '../domain/models/character.dart';
import '../domain/models/console.dart';
import '../domain/models/game.dart';

enum CategoryType { characters, consoles, games }

class CategoryListItem {
  const CategoryListItem({
    required this.name,
    required this.image,
  });

  final String name;
  final String image;
}

class CategoryItemsService {
  const CategoryItemsService();

  Future<List<CategoryListItem>> loadItems(CategoryType category) async {
    switch (category) {
      case CategoryType.characters:
        return _loadCharacters();
      case CategoryType.consoles:
        return _loadConsoles();
      case CategoryType.games:
        return _loadGames();
    }
  }

  Future<List<CategoryListItem>> _loadCharacters() async {
    final jsonString = await rootBundle.loadString('assets/characters.json');
    final rawList = json.decode(jsonString) as List<dynamic>;
    final characters = rawList
        .map((item) => Character.fromJson(item as Map<String, dynamic>))
        .toList();

    return characters
        .map(
          (character) => CategoryListItem(
            name: character.name,
            image: character.image,
          ),
        )
        .toList();
  }

  Future<List<CategoryListItem>> _loadConsoles() async {
    final jsonString = await rootBundle.loadString('assets/consoles.json');
    final rawList = json.decode(jsonString) as List<dynamic>;
    final consoles = rawList
        .map((item) => Console.fromJson(item as Map<String, dynamic>))
        .toList();

    return consoles
        .map(
          (console) => CategoryListItem(
            name: console.name,
            image: console.image,
          ),
        )
        .toList();
  }

  Future<List<CategoryListItem>> _loadGames() async {
    final jsonString = await rootBundle.loadString('assets/games.json');
    final rawList = json.decode(jsonString) as List<dynamic>;
    final games = rawList
        .map((item) => Game.fromJson(item as Map<String, dynamic>))
        .toList();

    return games
        .map(
          (game) => CategoryListItem(
            name: game.name,
            image: game.image,
          ),
        )
        .toList();
  }
}