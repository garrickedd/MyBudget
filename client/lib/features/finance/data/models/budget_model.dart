import 'package:equatable/equatable.dart';
import 'package:my_budget/features/finance/domain/entities/budget_entity.dart';

class BudgetModel extends Equatable implements Budget {
  @override
  final int id;
  @override
  final String userId;
  @override
  final int jarId;
  @override
  final double amount;
  @override
  final String month;

  const BudgetModel({
    required this.id,
    required this.userId,
    required this.jarId,
    required this.amount,
    required this.month,
  });

  factory BudgetModel.fromJson(Map<String, dynamic> json) {
    return BudgetModel(
      id: json['id'],
      userId: json['user_id'],
      jarId: json['jar_id'],
      amount: json['amount'].toDouble(),
      month: json['month'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'jar_id': jarId,
      'amount': amount,
      'month': month,
    };
  }

  @override
  List<Object?> get props => [id, userId, jarId, amount, month];
}
