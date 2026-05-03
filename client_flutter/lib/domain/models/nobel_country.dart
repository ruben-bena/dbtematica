class NobelCountry {
  const NobelCountry({
    required this.name,
    required this.amount,
    required this.winnerYears,
    required this.color,
    required this.image,
  });

  final String name;
  final int amount;
  final String winnerYears;
  final String color;
  final String image;

  factory NobelCountry.fromJson(Map<String, dynamic> json) {
    return NobelCountry(
      name: json['name'] as String,
      amount: json['amount'] as int,
      winnerYears: json['winner_years'] as String,
      color: json['color'] as String,
      image: json['image'] as String,
    );
  }
}