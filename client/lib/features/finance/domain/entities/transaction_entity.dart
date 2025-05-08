abstract class Transaction {
  int get id;
  String get userId;
  int? get jarId;
  String get type;
  double get amount;
  String get description;
  DateTime get createdAt;
}
