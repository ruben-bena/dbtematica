class Author {
  const Author({
    required this.name,
    required this.yearBorn,
    required this.yearDead,
    required this.country,
    required this.color,
    required this.image,
  });

  final String name;
  final int yearBorn;
  final int? yearDead;
  final String country;
  final String color;
  final String image;

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      name: json['name'] as String,
      yearBorn: json['year_born'] as int,
      yearDead: json['year_dead'] as int?,
      country: json['country'] as String,
      color: json['color'] as String,
      image: json['image'] as String,
    );
  }
}