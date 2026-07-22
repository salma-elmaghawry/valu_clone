import 'package:no_wait/features/auth/domain/entities/app_user.dart';

class UserModel {
  final String id;
  final String phone;
  final String? nationalId;
  final String? token;

  const UserModel({
    required this.id,
    required this.phone,
    this.nationalId,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      phone: json['phone'] as String,
      nationalId: json['nationalId'] as String?,
      token: json['token'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'phone': phone, 'nationalId': nationalId, 'token': token};
  }

  AppUser toEntity() => AppUser(id: id, phone: phone, nationalId: nationalId);
}
