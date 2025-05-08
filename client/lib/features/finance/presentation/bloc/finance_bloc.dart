import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_budget/core/error/failures.dart';
import 'package:my_budget/features/finance/domain/entities/budget_entity.dart';
import 'package:my_budget/features/finance/domain/entities/jar_entity.dart';
import 'package:my_budget/features/finance/domain/entities/transaction_entity.dart';
import 'package:my_budget/features/finance/domain/usecases/create_budget.dart';
import 'package:my_budget/features/finance/domain/usecases/generate_report.dart';
import 'package:my_budget/features/finance/domain/usecases/get_budgets.dart';
import 'package:my_budget/features/finance/domain/usecases/get_jars.dart';
import 'package:my_budget/features/finance/domain/usecases/get_transactions.dart';
import 'package:my_budget/features/finance/domain/usecases/record_expense.dart';
import 'package:my_budget/features/finance/domain/usecases/record_income.dart';
import 'finance_event.dart';
import 'finance_state.dart';

class FinanceBloc extends Bloc<FinanceEvent, FinanceState> {
  final GetJars getJars;
  final RecordIncome recordIncome;
  final RecordExpense recordExpense;
  final GetTransactions getTransactions;
  final CreateBudget createBudget;
  final GetBudgets getBudgets;
  final GenerateReport generateReport;

  FinanceBloc(
    this.getJars,
    this.recordIncome,
    this.recordExpense,
    this.getTransactions,
    this.createBudget,
    this.getBudgets,
    this.generateReport,
  ) : super(FinanceInitial()) {
    on<GetJarsEvent>(_onGetJars);
    on<RecordIncomeEvent>(_onRecordIncome);
    on<RecordExpenseEvent>(_onRecordExpense);
    on<GetTransactionsEvent>(_onGetTransactions);
    on<CreateBudgetEvent>(_onCreateBudget);
    on<GetBudgetsEvent>(_onGetBudgets);
    on<GenerateReportEvent>(_onGenerateReport);
  }

  Future<void> _onGetJars(
    GetJarsEvent event,
    Emitter<FinanceState> emit,
  ) async {
    emit(FinanceLoading());
    final Either<Failure, List<Jar>> result = await getJars(event.userId);
    result.fold(
      (failure) => emit(FinanceError('Failed to fetch jars')),
      (jars) => emit(JarsLoaded(jars)),
    );
  }

  Future<void> _onRecordIncome(
    RecordIncomeEvent event,
    Emitter<FinanceState> emit,
  ) async {
    emit(FinanceLoading());
    final result = await recordIncome(
      RecordIncomeParams(
        userId: event.userId,
        amount: event.amount,
        description: event.description,
      ),
    );
    result.fold(
      (failure) => emit(FinanceError('Failed to record income')),
      (_) => emit(FinanceSuccess('Income recorded')),
    );
  }

  Future<void> _onRecordExpense(
    RecordExpenseEvent event,
    Emitter<FinanceState> emit,
  ) async {
    emit(FinanceLoading());
    final result = await recordExpense(
      RecordExpenseParams(
        userId: event.userId,
        jarId: event.jarId,
        amount: event.amount,
        description: event.description,
      ),
    );
    result.fold(
      (failure) => emit(FinanceError('Failed to record expense')),
      (_) => emit(FinanceSuccess('Expense recorded')),
    );
  }

  Future<void> _onGetTransactions(
    GetTransactionsEvent event,
    Emitter<FinanceState> emit,
  ) async {
    emit(FinanceLoading());
    final Either<Failure, List<Transaction>> result = await getTransactions(
      event.userId,
    );
    result.fold(
      (failure) => emit(FinanceError('Failed to fetch transactions')),
      (transactions) => emit(TransactionsLoaded(transactions)),
    );
  }

  Future<void> _onCreateBudget(
    CreateBudgetEvent event,
    Emitter<FinanceState> emit,
  ) async {
    emit(FinanceLoading());
    final result = await createBudget(
      CreateBudgetParams(
        userId: event.userId,
        jarId: event.jarId,
        amount: event.amount,
        month: event.month,
      ),
    );
    result.fold(
      (failure) => emit(FinanceError('Failed to create budget')),
      (_) => emit(FinanceSuccess('Budget created')),
    );
  }

  Future<void> _onGetBudgets(
    GetBudgetsEvent event,
    Emitter<FinanceState> emit,
  ) async {
    emit(FinanceLoading());
    final Either<Failure, List<Budget>> result = await getBudgets(
      GetBudgetsParams(userId: event.userId, month: event.month),
    );
    result.fold(
      (failure) => emit(FinanceError('Failed to fetch budgets')),
      (budgets) => emit(BudgetsLoaded(budgets)),
    );
  }

  Future<void> _onGenerateReport(
    GenerateReportEvent event,
    Emitter<FinanceState> emit,
  ) async {
    emit(FinanceLoading());
    final result = await generateReport(
      GenerateReportParams(userId: event.userId, month: event.month),
    );
    result.fold(
      (failure) => emit(FinanceError('Failed to generate report')),
      (report) => emit(ReportLoaded(report)),
    );
  }
}
