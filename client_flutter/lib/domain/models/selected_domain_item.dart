import 'author.dart';
import 'book.dart';
import 'nobel_country.dart';

sealed class SelectedDomainItem {
  String get name;
  String get image;
  Map<String, String> get fields;
}

class SelectedAuthorItem extends SelectedDomainItem {
  SelectedAuthorItem(this.author);

  final Author author;

  @override
  String get name => author.name;

  @override
  String get image => author.image;

  @override
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
  SelectedBookItem(this.book);

  final Book book;

  @override
  String get name => book.name;

  @override
  String get image => book.image;

  @override
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
  SelectedNobelCountryItem(this.country);

  final NobelCountry country;

  @override
  String get name => country.name;

  @override
  String get image => country.image;

  @override
  Map<String, String> get fields => {
        'name': country.name,
        'amount': country.amount.toString(),
        'winner_years': country.winnerYears,
        'color': country.color,
        'image': country.image,
      };
}