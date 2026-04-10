import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.accessToken,
    required super.tokenType,
    required super.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      accessToken: json['access_token'],
      tokenType: json['token_type'],
      role: json['role'],
    );
  }
}
