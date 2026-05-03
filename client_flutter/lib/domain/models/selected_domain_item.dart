import 'character.dart';
import 'console.dart';
import 'game.dart';

sealed class SelectedDomainItem {
  String get name;
  String get image;
  Map<String, String> get fields;
}

class SelectedCharacterItem extends SelectedDomainItem {
  SelectedCharacterItem(this.character);

  final Character character;

  @override
  String get name => character.name;

  @override
  String get image => character.image;

  @override
  Map<String, String> get fields => {
        'name': character.name,
        'image': character.image,
        'color': character.color,
        'game': character.game,
      };
}

class SelectedConsoleItem extends SelectedDomainItem {
  SelectedConsoleItem(this.console);

  final Console console;

  @override
  String get name => console.name;

  @override
  String get image => console.image;

  @override
  Map<String, String> get fields => {
        'name': console.name,
        'date': console.date,
        'procesador': console.procesador,
        'color': console.color,
        'units_sold': console.unitsSold.toString(),
        'image': console.image,
      };
}

class SelectedGameItem extends SelectedDomainItem {
  SelectedGameItem(this.game);

  final Game game;

  @override
  String get name => game.name;

  @override
  String get image => game.image;

  @override
  Map<String, String> get fields => {
        'name': game.name,
        'year': game.year.toString(),
        'type': game.type,
        'plot': game.plot,
        'image': game.image,
      };
}