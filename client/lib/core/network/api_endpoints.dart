class ApiEndpoints {
  static const String baseUrl = 'https://localhost:8080/api/v1';

  // Auth
  static const String register = '/users/register';
  static const String login = '/users/login';
  static const String getUser = '/users/';

  // Jars
  static const String getUserJars = '/jars';

  // Transactions
  static const String createIncome = '/transactions/income';
  static const String createExpense = '/transactions/expense';
  static const String getTransactions = '/transactions';

  // Budgets
  static const String createBudget = '/budgets';
  static const String getBudgets = '/budgets';

  // Reports
  static const String generateReport = '/reports';
}
