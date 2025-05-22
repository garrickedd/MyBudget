import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String? firstName;
  final String? lastName;
  final String email;
  final String name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const User({
    required this.id,
    this.firstName,
    this.lastName,
    required this.email,
    required this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id_user'] as String? ?? '',
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      name: json['name'] as String? ?? '',
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'] as String)
              : null,
      updatedAt:
          json['updated_at'] != null
              ? DateTime.parse(json['updated_at'] as String)
              : null,
    );
  }

  @override
  List<Object?> get props => [
    id,
    firstName,
    lastName,
    email,
    name,
    createdAt,
    updatedAt,
  ];
}
