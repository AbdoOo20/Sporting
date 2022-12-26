class CompetitionModel {
  late int id;
  late String name;
  late String image;
  late String subscribers;
  late String type;
  late String startDate;
  late String endDate;
  late String numberVotes;

  CompetitionModel({
    required this.id,
    required this.name,
    required this.image,
    required this.subscribers,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.numberVotes,
  });

  factory CompetitionModel.fromJSON(Map<String, dynamic> json) {
    return CompetitionModel(
      id: json['id'],
      name: json['name'],
      image: json['icon_image'],
      subscribers: json['number_of_subscribers'],
      type: json['type'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      numberVotes: json['number_of_votes'],
    );
  }
}
