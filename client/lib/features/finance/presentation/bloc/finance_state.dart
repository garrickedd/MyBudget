import 'package:equatable/equatable.dart';
import 'package:my_budget/features/finance/domain/entities/budget_entity.dart';
import 'package:my_budget/features/finance/domain/entities/jar_entity.dart';
import 'package:my_budget/features/finance/domain/entities/report_entity.dart';
import 'package:my_budget/features/finance/domain/entities/transaction_entity.dart';

abstract class FinanceState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FinanceInitial extends FinanceState {}

class FinanceLoading extends FinanceState {}

class FinanceSuccess extends FinanceState {
  final String message;

  FinanceSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class FinanceError extends FinanceState {
  final String message;

  FinanceError(this.message);

  @override
  List<Object?> get props => [message];
}

class JarsLoaded extends FinanceState {
  final List<Jar> jars;

  JarsLoaded(this.jars);

  @override
  List<Object?> get props => [jars];
}

class TransactionsLoaded extends FinanceState {
  final List<Transaction> transactions;

  TransactionsLoaded(this.transactions);

  @override
  List<Object?> get props => [transactions];
}

class BudgetsLoaded extends FinanceState {
  final List<Budget> budgets;

  BudgetsLoaded(this.budgets);

  @override
  List<Object?> get props => [budgets];
}

class ReportLoaded extends FinanceState {
  final Report report;

  ReportLoaded(this.report);

  @override
  List<Object?> get props => [report];
}
