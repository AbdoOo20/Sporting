class UserModel {
  late int id;
  late String name;
  late String email;
  late String phone;
  late String type;
  late String bio;
  late String image;
  late String facebook;
  late String instagram;
  late String twitter;
  late String snapchat;
  late String tiktok;
  late String country;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.type,
    required this.bio,
    required this.image,
    required this.facebook,
    required this.instagram,
    required this.twitter,
    required this.snapchat,
    required this.tiktok,
    required this.country,
  });

  factory UserModel.fromJSON(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      type: json['type'],
      bio: json['bio'] ?? '',
      image: json['image'] ?? '',
      facebook: json['facebook'] ?? '',
      instagram: json['instagram'] ?? '',
      twitter: json['twitter'] ?? '',
      snapchat: json['snapchat'] ?? '',
      tiktok: json['tiktok'] ?? '',
      country: json['country'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'type': type,
      'bio': bio,
      'image': image,
      'facebook': facebook,
      'instagram': instagram,
      'twitter': twitter,
      'snapchat': snapchat,
      'tiktok': tiktok,
      'country': country,
    };
  }
}
