class Book {
  const Book({
    required this.name,
    required this.year,
    required this.author,
    required this.plot,
    required this.color,
    required this.image,
  });

  final String name;
  final int year;
  final String author;
  final String plot;
  final String color;
  final String image;

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      name: json['name'] as String,
      year: json['year'] as int,
      author: json['author'] as String,
      plot: json['plot'] as String,
      color: json['color'] as String,
      image: json['image'] as String,
    );
  }
}