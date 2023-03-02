class CompetitorModel {
  late int id;
  late String name;
  late String image;
  late String countryImage;
  late String videoLink;
  late String video;
  late String score;
  late String center;
  late String numberComments;

  CompetitorModel({
    required this.id,
    required this.name,
    required this.image,
    required this.countryImage,
    required this.videoLink,
    required this.video,
    required this.score,
    required this.center,
    required this.numberComments,
  });

  factory CompetitorModel.fromJSON(Map<String, dynamic> json) {
    return CompetitorModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      countryImage: json['country_image'],
      videoLink: json['video_link'] ?? '',
      video: json['video'] ?? '',
      score: json['total_votes'],
      center: json['center'],
      numberComments: json['number_of_comments'],
    );
  }
}
