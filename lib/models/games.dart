class GameModel {
  final String id;
  final String title;
  final String url;
  final String image;

  GameModel({
    required this.id,
    required this.title,
    required this.url,
    required this.image,
  });

  factory GameModel.fromJSON(Map<String, dynamic> json) {
    return GameModel(
      id: json['id'],
      title: json['title'],
      url: json['url'],
      image: json['image'],
    );
  }
}
