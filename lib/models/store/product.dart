
class ProductModel {
  late int id;
  late String name;
  late String price;
  late String storeCategoryId;
  late String description;
  late String discount;
  List<Colors> colors = [];
  List<Size> sizes = [];
  List<Media> media = [];

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.storeCategoryId,
    required this.description,
    required this.colors,
    required this.sizes,
    required this.media,
    required this.discount,
  });

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    storeCategoryId = json['store_category_id'];
    description = json['description'];
    discount = json['discount'] ?? '';
    if (json['colors'] != null) {
      colors = <Colors>[];
      json['colors'].forEach((v) {
        colors.add(Colors.fromJson(v));
      });
      var output = colors[0].name.split(',');
      colors = [];
      for (var element in output) {
        var editElement = element.replaceAll('[', '').replaceAll(']', '');
        colors.add(Colors(id: id, name: editElement, productId: id.toString()));
      }
    }
    if (json['sizes'] != null) {
      sizes = <Size>[];
      json['sizes'].forEach((v) {
        sizes.add(Size.fromJson(v));
      });
      var output = sizes[0].name.split(',');
      sizes = [];
      for (var element in output) {
        var editElement = element.replaceAll('[', '').replaceAll(']', '');
        sizes.add(Size(id: id, name: editElement, productId: id.toString()));
      }
    }
    if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media.add(Media.fromJson(v));
      });
    }
  }
}

class Colors {
  late int id;
  late String name;
  late String productId;

  Colors({
    required this.id,
    required this.name,
    required this.productId,
  });

  Colors.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    productId = json['product_id'];
  }
}

class Media {
  late int id;
  late String productId;
  late String fileName;

  Media({
    required this.id,
    required this.productId,
    required this.fileName,
  });

  Media.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    fileName = json['file_name'];
  }
}

class Size {
  late int id;
  late String name;
  late String productId;

  Size({
    required this.id,
    required this.name,
    required this.productId,
  });

  Size.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    productId = json['product_id'];
  }
}
