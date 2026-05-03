import 'dart:convert';

import 'package:flutter/services.dart';

import '../domain/models/character.dart';
import '../domain/models/console.dart';
import '../domain/models/game.dart';
import '../domain/models/selected_domain_item.dart';

enum CategoryType { characters, consoles, games }

class CategoryItemsService {
  const CategoryItemsService();

  Future<List<SelectedDomainItem>> loadItems(CategoryType category) async {
    switch (category) {
      case CategoryType.characters:
        return _loadCharacters();
      case CategoryType.consoles:
        return _loadConsoles();
      case CategoryType.games:
        return _loadGames();
    }
  }

  Future<List<SelectedDomainItem>> _loadCharacters() async {
    final jsonString = await rootBundle.loadString('assets/characters.json');
    final rawList = json.decode(jsonString) as List<dynamic>;
    final characters = rawList
        .map((item) => Character.fromJson(item as Map<String, dynamic>))
        .toList();

    return characters
        .map((character) => SelectedCharacterItem(character))
        .toList();
  }

  Future<List<SelectedDomainItem>> _loadConsoles() async {
    final jsonString = await rootBundle.loadString('assets/consoles.json');
    final rawList = json.decode(jsonString) as List<dynamic>;
    final consoles = rawList
        .map((item) => Console.fromJson(item as Map<String, dynamic>))
        .toList();

    return consoles
        .map((console) => SelectedConsoleItem(console))
        .toList();
  }

  Future<List<SelectedDomainItem>> _loadGames() async {
    final jsonString = await rootBundle.loadString('assets/games.json');
    final rawList = json.decode(jsonString) as List<dynamic>;
    final games = rawList
        .map((item) => Game.fromJson(item as Map<String, dynamic>))
        .toList();

    return games.map((game) => SelectedGameItem(game)).toList();
  }
}