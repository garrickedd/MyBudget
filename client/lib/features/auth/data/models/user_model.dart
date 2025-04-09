import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id_user'],
    firstName: json['first_name'],
    lastName: json['last_name'],
    email: json['email'],
  );

  Map<String, dynamic> toJson() => {
    'id_user': id,
    'first_name': firstName,
    'last_name': lastName,
    'email': email,
  };
}
