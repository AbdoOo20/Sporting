class MemberModel {
  late int id;
  late String name;

  MemberModel({
    required this.id,
    required this.name,
  });

  factory MemberModel.fromJSON(Map<String, dynamic> json) {
    return MemberModel(
      id: json['id'],
      name: json['name'],
    );
  }
}

class MemberDetailsModel {
  late int id;
  late String name;
  late String image;
  late String job;
  late String countryImage;
  late String countryName;

  MemberDetailsModel({
    required this.id,
    required this.name,
    required this.image,
    required this.job,
    required this.countryImage,
    required this.countryName,
  });

  factory MemberDetailsModel.fromJSON(Map<String, dynamic> json) {
    return MemberDetailsModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      job: json['job_title'],
      countryImage: json['country_image'],
      countryName: json['country_name'],
    );
  }
}
