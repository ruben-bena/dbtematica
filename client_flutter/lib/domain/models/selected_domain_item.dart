import 'author.dart';
import 'book.dart';
import 'nobel_country.dart';

/// Contrato común para representar cualquier elemento seleccionable en UI.
sealed class SelectedDomainItem {
  String get name;
  String get image;
  Map<String, String> get fields;
}

class SelectedAuthorItem extends SelectedDomainItem {
  /// Envuelve una entidad de autor para exponerla en la UI de selección.
  SelectedAuthorItem(this.author);

  final Author author;

  @override
  /// Devuelve el nombre público del autor.
  String get name => author.name;

  @override
  /// Devuelve la clave de imagen del autor.
  String get image => author.image;

  @override
  /// Construye los campos textuales que alimentan el panel de detalle.
  Map<String, String> get fields => {
        'name': author.name,
        'year_born': author.yearBorn.toString(),
        'year_dead': author.yearDead?.toString() ?? 'Actualidad',
        'country': author.country,
        'color': author.color,
        'image': author.image,
      };
}

class SelectedBookItem extends SelectedDomainItem {
  /// Envuelve una entidad de libro para exponerla en la UI de selección.
  SelectedBookItem(this.book);

  final Book book;

  @override
  /// Devuelve el nombre público del libro.
  String get name => book.name;

  @override
  /// Devuelve la clave de imagen del libro.
  String get image => book.image;

  @override
  /// Construye los campos textuales que alimentan el panel de detalle.
  Map<String, String> get fields => {
        'name': book.name,
        'year': book.year.toString(),
        'author': book.author,
        'plot': book.plot,
        'color': book.color,
        'image': book.image,
      };
}

class SelectedNobelCountryItem extends SelectedDomainItem {
  /// Envuelve una entidad de país Nobel para exponerla en la UI de selección.
  SelectedNobelCountryItem(this.country);

  final NobelCountry country;

  @override
  /// Devuelve el nombre público del país.
  String get name => country.name;

  @override
  /// Devuelve la clave de imagen del país.
  String get image => country.image;

  @override
  /// Construye los campos textuales que alimentan el panel de detalle.
  Map<String, String> get fields => {
        'name': country.name,
        'amount': country.amount.toString(),
        'winner_years': country.winnerYears,
        'color': country.color,
        'image': country.image,
      };
}