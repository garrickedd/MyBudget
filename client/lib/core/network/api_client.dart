import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../utils/constants.dart';
import '../utils/failure.dart';

class ApiClient {
  final http.Client _client = http.Client();

  Future<Map<String, dynamic>> get(String endpoint) async {
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

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
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
