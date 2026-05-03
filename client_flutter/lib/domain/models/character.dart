class Character {
  const Character({
    required this.name,
    required this.image,
    required this.color,
    required this.game,
  });

  final String name;
  final String image;
  final String color;
  final String game;

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      name: json['name'] as String,
      image: json['image'] as String,
      color: json['color'] as String,
      game: json['game'] as String,
    );
  }
}