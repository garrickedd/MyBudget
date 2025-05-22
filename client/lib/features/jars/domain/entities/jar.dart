import 'package:equatable/equatable.dart';

class Jar extends Equatable {
  final int? id;
  final String userId;
  final String name;
  final double percentage;
  final double balance;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Jar({
    this.id,
    required this.userId,
    required this.name,
    required this.percentage,
    required this.balance,
    required this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    name,
    percentage,
    balance,
    createdAt,
    updatedAt,
  ];
}
