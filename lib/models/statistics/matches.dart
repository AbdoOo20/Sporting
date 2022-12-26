

class Match {
  final String id;
  final String title;
  final String url;
  final String poster;

  Match({
    required this.id,
    required this.title,
    required this.url,
    required this.poster,
  });

  factory Match.fromJSON(Map<String, dynamic> json) {
    return Match(
      id: json['id'],
      title: json['title'],
      url: json['url'],
      poster: json['poster'],
    );
  }
}
