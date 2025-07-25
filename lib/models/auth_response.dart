import 'user_model.dart';

class AuthResponse {
  final UserModel user;
  final String token;

  AuthResponse({required this.user, required this.token});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return AuthResponse(
      user: UserModel.fromJson(data),
      token: data['token'] ?? '',
    );
  }
}
