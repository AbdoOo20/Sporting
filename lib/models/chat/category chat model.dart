class CategoryChatModel {
  late int id;
  late String name;
  late String image;

  CategoryChatModel({
    required this.id,
    required this.name,
    required this.image,
  });

  factory CategoryChatModel.fromJSON(Map<String, dynamic> json) {
    return CategoryChatModel(
      id: json['id'],
      name: json['name'],
      image: json['image'] ?? '',
    );
  }
}
