import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  // final String firstName;
  // final String lastName;
  final String email;
  final String name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const User({
    required this.id,
    // required this.firstName,
    // required this.lastName,
    required this.email,
    required this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id_user'] ?? '',
      // firstName: json['first_name'] ?? '',
      // lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      createdAt: DateTime.parse(json['created_at'] ?? '0001-01-01T00:00:00Z'),
      updatedAt: DateTime.parse(json['updated_at'] ?? '0001-01-01T00:00:00Z'),
    );
  }

  @override
  List<Object?> get props => [
    id,
    // firstName,
    // lastName,
    email,
    name,
    createdAt,
    updatedAt,
  ];
}
