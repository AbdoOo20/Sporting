class RegisterModel {
  late String userName;
  late String email;
  late String password;

  RegisterModel({
    required this.userName,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': userName,
      'email': email,
      'password': password,
    };
  }
}
