class ArticlesModel {
  final String id;
  final String title;
  final String content;
  final String poster;

  ArticlesModel({
    required this.id,
    required this.title,
    required this.content,
    required this.poster,
  });

  factory ArticlesModel.fromJSON(Map<String, dynamic> json) {
    return ArticlesModel(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      poster: json['poster'],
    );
  }
}
