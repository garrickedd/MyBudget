import 'package:equatable/equatable.dart';
import 'package:my_budget/features/finance/domain/entities/jar_entity.dart';

class JarModel extends Equatable implements Jar {
  @override
  final int id;
  @override
  final String userId;
  @override
  final String name;
  @override
  final double percentage;
  @override
  final double balance;

  const JarModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.percentage,
    required this.balance,
  });

  factory JarModel.fromJson(Map<String, dynamic> json) {
    return JarModel(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      percentage: json['percentage'].toDouble(),
      balance: json['balance'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'percentage': percentage,
      'balance': balance,
    };
  }

  @override
  List<Object?> get props => [id, userId, name, percentage, balance];
}
