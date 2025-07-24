class UserModel {
  final int id;
  final String name;
  final String email;
  final String? profilePhoto;
  final String? token;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.profilePhoto,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      profilePhoto: json['profile_photo'],
      token: json['token'],
    );
  }
}
