class BannerModel{
  late int id;
  late String image;
  late String type;

  BannerModel({
    required this.id,
    required this.image,
    required this.type,
  });

  factory BannerModel.fromJSON(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'],
      image: json['image'] ?? '',
      type: json['type'],
    );
  }
}