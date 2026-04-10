import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({required super.id, required super.phone, required super.token});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      phone: json['phone'],
      token: json['token'],
    );
  }
}
