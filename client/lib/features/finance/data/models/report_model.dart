import 'package:equatable/equatable.dart';
import 'package:my_budget/features/finance/domain/entities/report_entity.dart';
import 'jar_model.dart';

class ReportModel extends Equatable implements Report {
  @override
  final String userId;
  @override
  final String month;
  @override
  final double totalIncome;
  @override
  final double totalExpense;
  @override
  final List<JarModel> jars;

  const ReportModel({
    required this.userId,
    required this.month,
    required this.totalIncome,
    required this.totalExpense,
    required this.jars,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      userId: json['user_id'],
      month: json['month'],
      totalIncome: json['total_income'].toDouble(),
      totalExpense: json['total_expense'].toDouble(),
      jars:
          (json['jars'] as List<dynamic>)
              .map((e) => JarModel.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'month': month,
      'total_income': totalIncome,
      'total_expense': totalExpense,
      'jars': jars.map((jar) => jar.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [userId, month, totalIncome, totalExpense, jars];
}
