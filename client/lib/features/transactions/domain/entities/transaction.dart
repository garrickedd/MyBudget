class Transaction {
  final String userId;
  final int jarId;
  final String type;
  final double amount;
  final String description;
  final DateTime transactionDate;

  Transaction({
    required this.userId,
    required this.jarId,
    required this.type,
    required this.amount,
    required this.description,
    required this.transactionDate,
  });
}
