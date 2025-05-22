class FinancialSummary {
  final double totalBalance;
  final double income;
  final double expense;

  FinancialSummary({
    required this.totalBalance,
    required this.income,
    required this.expense,
  });

  factory FinancialSummary.empty() {
    return FinancialSummary(totalBalance: 0.0, income: 0.0, expense: 0.0);
  }
}
