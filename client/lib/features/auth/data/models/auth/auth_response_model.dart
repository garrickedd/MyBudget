import 'package:my_budget/features/auth/domain/entities/auth/auth_response_entity.dart';

class AuthResponseModel extends AuthResponseEntity {
  AuthResponseModel({required String token}) : super(token: token);

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(token: json['token']);
  }

  Map<String, dynamic> toJson() {
    return {'token': token};
  }
}
