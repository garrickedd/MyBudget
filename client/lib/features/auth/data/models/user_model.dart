import 'package:my_budget/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({required String id, required String email, required String name})
    : super(id: id, email: email, name: name);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(id: json['id'], email: json['email'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email, 'name': name};
  }
}
