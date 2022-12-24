class PlayerModel {
  late String id;
  late String name;
  late String profile;
  late String money;
  late String birthDate;
  late String birthPlace;
  late String birthPlaceLogo;
  late String age;
  late String height;
  late String citizen;
  late String position;
  late String foot;
  late String playerAgent;
  late String currentCub;
  late String currentCubLogo;
  late String joinedDate;
  late String contractExpire;
  late String outFitter;
  late String goals;

  PlayerModel({
    required this.id,
    required this.name,
    required this.profile,
    required this.money,
    required this.birthDate,
    required this.birthPlace,
    required this.birthPlaceLogo,
    required this.age,
    required this.height,
    required this.citizen,
    required this.position,
    required this.foot,
    required this.playerAgent,
    required this.currentCub,
    required this.currentCubLogo,
    required this.joinedDate,
    required this.contractExpire,
    required this.outFitter,
    required this.goals,
  });

  factory PlayerModel.fromJSON(Map<String, dynamic> json) {
    return PlayerModel(
      id: json['id'],
      name: json['name'],
      profile: json['Profile'],
      money: json['Money'],
      birthDate: json['date_birth'],
      birthPlace: json['place_birth'],
      birthPlaceLogo: json['place_birth_logo'],
      age: json['age'],
      height: json['height'],
      citizen: json['Citizenship'],
      position: json['position'],
      foot: json['foot'],
      playerAgent: json['player_agent'],
      currentCub: json['current_club'],
      currentCubLogo: json['current_club_logo'],
      joinedDate: json['Joined'],
      contractExpire: json['Contract_expires'],
      outFitter: json['Outfitter'],
      goals: json['Caps_Goals'],
    );
  }
}
