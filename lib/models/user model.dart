class UserModel {
  late String userName;
  late String email;
  late String password;
  late String phone;
  late String country;
  late String kind;
  late String image;
  late String about;
  late String id;
  late String facebook;
  late String instagram;
  late String twitter;
  late String tiktok;
  late String snapchat;

  UserModel({
    required this.userName,
    required this.email,
    required this.password,
    required this.phone,
    required this.country,
    required this.kind,
    required this.image,
    required this.about,
    required this.id,
    required this.facebook,
    required this.instagram,
    required this.twitter,
    required this.tiktok,
    required this.snapchat,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    email = json['email'];
    password = json['password'];
    phone = json['phone'];
    country = json['country'];
    kind = json['kind'];
    image = json['image'];
    about = json['about'];
    id = json['id'];
    facebook = json['facebook'];
    instagram = json['instagram'];
    twitter = json['twitter'];
    tiktok = json['tiktok'];
    snapchat = json['snapchat'];
  }

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'email': email,
      'password': password,
      'phone': phone,
      'country': country,
      'kind': kind,
      'image': image,
      'about': about,
      'id': id,
      'facebook': facebook,
      'instagram': instagram,
      'twitter': twitter,
      'tiktok': tiktok,
      'snapchat': snapchat,
    };
  }
}
