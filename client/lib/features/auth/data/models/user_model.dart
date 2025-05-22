import 'package:equatable/equatable.dart';
import 'package:mybudget/features/auth/domain/entities/user.dart';

class UserModel extends Equatable {
  final String id;
  final String? firstName;
  final String? lastName;
  final String email;
  final String name;

  const UserModel({
    required this.id,
    this.firstName,
    this.lastName,
    required this.email,
    required this.name,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id_user'] as String? ?? '',
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_user': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'name': name,
    };
  }

  User toEntity() {
    return User(
      id: id,
      firstName: firstName,
      lastName: lastName,
      email: email,
      name: name,
    );
  }

  @override
  List<Object?> get props => [id, firstName, lastName, email, name];
}
