class RegisterModel {
  late String userName;
  late String email;
  late String password;
  late String phone;
  late String country;
  late String type;

  RegisterModel({
    required this.userName,
    required this.email,
    required this.password,
    required this.phone,
    required this.country,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': userName,
      'email': email,
      'password': password,
      'phone': phone,
      'country': country,
      'type': type,
    };
  }
}
