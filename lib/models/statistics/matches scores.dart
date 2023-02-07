class MatchesScoresModel {
  String rank;
  String name;
  String img;
  String goals;
  String aldawla;
  String logo;

  MatchesScoresModel({
    required this.name,
    required this.rank,
    required this.img,
    required this.goals,
    required this.aldawla,
    required this.logo,
  });

  factory MatchesScoresModel.fromJSON(Map<String, dynamic> json) {
    return MatchesScoresModel(
      name: json['name'],
      rank: json['rank'],
      img: json['img'] ?? '',
      goals: json['goals'],
      aldawla: json['name_aldawla'],
      logo: json['logo_aldawla'] ?? '',
    );
  }
}
