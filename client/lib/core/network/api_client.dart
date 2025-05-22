import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../utils/constants.dart';
import '../utils/failure.dart';

class ApiClient {
  final http.Client _client = http.Client();

  Future<dynamic> get(String endpoint) async {
    try {
      final response = await _client
          .get(Uri.parse('${AppConstants.baseUrl}$endpoint'))
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw Failure(message: 'Request timed out'),
          );
      return _handleResponse(response);
    } catch (e) {
      debugPrint('ApiClient: Error on GET $endpoint: $e');
      throw Failure(message: e.toString());
    }
  }

  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> data, {
    bool includeToken = true,
  }) async {
    try {
      debugPrint('ApiClient: Sending POST to $endpoint with data: $data');
      final response = await _client
          .post(
            Uri.parse('${AppConstants.baseUrl}$endpoint'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(data),
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw Failure(message: 'Request timed out'),
          );
      debugPrint('ApiClient: Response from $endpoint: ${response.body}');
      return _handleResponse(response);
    } catch (e) {
      debugPrint('ApiClient: Error on POST $endpoint: $e');
      throw Failure(message: e.toString());
    }
  }

  Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> data, {
    bool includeToken = true,
  }) async {
    try {
      debugPrint('ApiClient: Sending PUT to $endpoint with data: $data');
      final response = await _client
          .put(
            Uri.parse('${AppConstants.baseUrl}$endpoint'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(data),
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw Failure(message: 'Request timed out'),
          );
      debugPrint('ApiClient: Response from $endpoint: ${response.body}');
      return _handleResponse(response);
    } catch (e) {
      debugPrint('ApiClient: Error on PUT $endpoint: $e');
      throw Failure(message: e.toString());
    }
  }

  dynamic _handleResponse(http.Response response) {
    final decoded = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      // Kiểm tra xem decoded là List hay Map
      if (decoded is List) {
        return decoded;
      } else if (decoded is Map) {
        return decoded;
      }
      throw Failure(message: 'Unexpected response format');
    } else {
      throw Failure(
        message: 'Server error: ${response.statusCode} - ${response.body}',
      );
    }
  }

  void dispose() {
    _client.close();
  }
}
