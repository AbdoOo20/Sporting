class SportServicesCategoriesModel {
  late int id;
  late String name;
  late String image;

  SportServicesCategoriesModel({
    required this.id,
    required this.name,
    required this.image,
  });

  factory SportServicesCategoriesModel.fromJSON(Map<String, dynamic> json) {
    return SportServicesCategoriesModel(
      id: json['id'],
      name: json['name'],
      image: json['image'] ?? '',
    );
  }
}
