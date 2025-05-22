import 'dart:convert';
import 'package:mybudget/core/error/exceptions.dart';
import 'package:mybudget/core/network/api_client.dart';
import 'package:mybudget/core/utils/failure.dart';
import 'package:mybudget/features/jars/data/models/jar_model.dart';

class JarRemoteDataSource {
  final ApiClient apiClient;

  JarRemoteDataSource(this.apiClient);

  Future<List<JarModel>> getUserJars(String userId) async {
    try {
      final response = await apiClient.get('/jars?user_id=$userId');
      if (response is Map<String, dynamic>) {
        final List<dynamic> jars = response['jars'] as List<dynamic>;
        return jars.map((json) => JarModel.fromJson(json)).toList();
      } else if (response is List<dynamic>) {
        return (response as List<dynamic>)
            .map((json) => JarModel.fromJson(json))
            .toList();
      } else {
        throw ServerException('Unexpected response format');
      }
    } catch (e) {
      if (e is Failure) {
        throw ServerException(e.message);
      }
      throw NetworkException('Network error: $e');
    }
  }

  Future<void> updateJarPercentage(int jarId, double percentage) async {
    try {
      await apiClient.put('/jars/$jarId', {'percentage': percentage});
    } catch (e) {
      if (e is Failure) {
        throw ServerException(e.message);
      }
      throw NetworkException('Network error: $e');
    }
  }
}
