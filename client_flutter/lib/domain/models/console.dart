class Console {
  const Console({
    required this.name,
    required this.date,
    required this.procesador,
    required this.color,
    required this.unitsSold,
    required this.image,
  });

  final String name;
  final String date;
  final String procesador;
  final String color;
  final int unitsSold;
  final String image;

  factory Console.fromJson(Map<String, dynamic> json) {
    return Console(
      name: json['name'] as String,
      date: json['date'] as String,
      procesador: json['procesador'] as String,
      color: json['color'] as String,
      unitsSold: json['units_sold'] as int,
      image: json['image'] as String,
    );
  }
}