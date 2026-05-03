class Game {
  const Game({
    required this.name,
    required this.year,
    required this.type,
    required this.plot,
    required this.image,
  });

  final String name;
  final int year;
  final String type;
  final String plot;
  final String image;

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      name: json['name'] as String,
      year: json['year'] as int,
      type: json['type'] as String,
      plot: json['plot'] as String,
      image: json['image'] as String,
    );
  }
}