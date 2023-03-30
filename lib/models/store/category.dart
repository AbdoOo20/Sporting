class CategoryModel {
  late int id;
  late String name;
  late String storeID;

  CategoryModel({
    required this.id,
    required this.name,
    required this.storeID,
  });

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    storeID = json['store_model_id'];
  }
}
