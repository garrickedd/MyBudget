import 'package:equatable/equatable.dart';

abstract class FinanceEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetJarsEvent extends FinanceEvent {
  final String userId;

  GetJarsEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class RecordIncomeEvent extends FinanceEvent {
  final String userId;
  final double amount;
  final String description;

  RecordIncomeEvent(this.userId, this.amount, this.description);

  @override
  List<Object?> get props => [userId, amount, description];
}

class RecordExpenseEvent extends FinanceEvent {
  final String userId;
  final int jarId;
  final double amount;
  final String description;

  RecordExpenseEvent(this.userId, this.jarId, this.amount, this.description);

  @override
  List<Object?> get props => [userId, jarId, amount, description];
}

class GetTransactionsEvent extends FinanceEvent {
  final String userId;

  GetTransactionsEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class CreateBudgetEvent extends FinanceEvent {
  final String userId;
  final int jarId;
  final double amount;
  final String month;

  CreateBudgetEvent(this.userId, this.jarId, this.amount, this.month);

  @override
  List<Object?> get props => [userId, jarId, amount, month];
}

class GetBudgetsEvent extends FinanceEvent {
  final String userId;
  final String month;

  GetBudgetsEvent(this.userId, this.month);

  @override
  List<Object?> get props => [userId, month];
}

class GenerateReportEvent extends FinanceEvent {
  final String userId;
  final String month;

  GenerateReportEvent(this.userId, this.month);

  @override
  List<Object?> get props => [userId, month];
}
