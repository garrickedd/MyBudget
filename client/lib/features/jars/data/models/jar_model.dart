import 'package:mybudget/features/jars/domain/entities/jar.dart';

class JarModel extends Jar {
  const JarModel({
    int? id,
    required String userId,
    required String name,
    required double percentage,
    required double balance,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) : super(
         id: id,
         userId: userId,
         name: name,
         percentage: percentage,
         balance: balance,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  factory JarModel.fromJson(Map<String, dynamic> json) {
    return JarModel(
      id: json['id'] as int?,
      userId: json['user_id'].toString(),
      name: json['name'] as String,
      percentage: (json['percentage'] as num).toDouble(),
      balance: (json['balance'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'].toString()),
      updatedAt:
          json['updated_at'] != null
              ? DateTime.parse(json['updated_at'].toString())
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'percentage': percentage,
      'balance': balance,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
