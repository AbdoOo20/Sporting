class MatchesStatisticsModel {
  String name1;
  String name2;
  String logo1;
  String logo2;
  String scores;
  String haluh;
  String qinah;
  String muealaq;
  String aldawriu;

  MatchesStatisticsModel({
    required this.name1,
    required this.name2,
    required this.logo1,
    required this.logo2,
    required this.scores,
    required this.haluh,
    required this.qinah,
    required this.muealaq,
    required this.aldawriu,
  });

  factory MatchesStatisticsModel.fromJSON(Map<String, dynamic> json) {
    return MatchesStatisticsModel(
      name1: json['name1'],
      name2: json['name2'],
      logo1: json['logo1'],
      logo2: json['logo2'],
      scores: json['scores_time'],
      haluh: json['haluh'],
      qinah: json['qinah'],
      muealaq: json['muealaq'],
      aldawriu: json['aldawriu'],
    );
  }
}
