import 'package:my_budget/features/finance/domain/entities/jar_entity.dart';

abstract class Report {
  String get userId;
  String get month;
  double get totalIncome;
  double get totalExpense;
  List<Jar> get jars;
}
