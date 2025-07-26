class UserModel {
  final String id;
  final String email;
  final String token;
  final String role;

  UserModel({
    required this.id,
    required this.email,
    required this.token,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, String token) {
    return UserModel(
      id: json['_id'],
      email: json['email'],
      token: token,
      role: json['role'],
    );
  }
}
