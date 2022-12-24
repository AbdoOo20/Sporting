class TeamModel {
  String rank;
  String teamLogo;
  String team;
  String pld;
  String won;
  String draw;
  String lost;
  String matchLeft;
  String goalPlusMinus;
  String diff;
  String? pts;

  TeamModel({
    required this.rank,
    required this.teamLogo,
    required this.team,
    required this.pld,
    required this.won,
    required this.draw,
    required this.lost,
    required this.matchLeft,
    required this.goalPlusMinus,
    required this.diff,
    required this.pts,
  });

  factory TeamModel.fromJSON(Map<String, dynamic> json) {
    return TeamModel(
      rank: json['rank'],
      teamLogo: json['team_logo'],
      team: json['team'],
      pld: json['pld'],
      won: json['won'],
      draw: json['draw'],
      lost: json['lost'],
      matchLeft: json['match_left'],
      goalPlusMinus: json['goal_plus_minus'],
      diff: json['diff'],
      pts: json['pts'],
    );
  }
}
