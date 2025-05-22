import 'package:equatable/equatable.dart';
import 'package:mybudget/features/auth/domain/entities/user.dart';

class UserModel extends Equatable {
  final String id;
  final String name;
  final String email;

  const UserModel({required this.id, required this.name, required this.email});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email};
  }

  User toEntity() {
    return User(id: id, name: name, email: email);
  }

  @override
  List<Object> get props => [id, name, email];
}
