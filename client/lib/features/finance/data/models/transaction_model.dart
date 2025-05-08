import 'package:equatable/equatable.dart';
import 'package:my_budget/features/finance/domain/entities/transaction_entity.dart';

class TransactionModel extends Equatable implements Transaction {
  @override
  final int id;
  @override
  final String userId;
  @override
  final int? jarId;
  @override
  final double amount;
  @override
  final String type;
  @override
  final String description;
  @override
  final DateTime createdAt;

  const TransactionModel({
    required this.id,
    required this.userId,
    this.jarId,
    required this.amount,
    required this.type,
    required this.description,
    required this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      userId: json['user_id'],
      jarId: json['jar_id'],
      amount: json['amount'].toDouble(),
      type: json['type'],
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'jar_id': jarId,
      'amount': amount,
      'type': type,
      'description': description,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    jarId,
    amount,
    type,
    description,
    createdAt,
  ];
}
