import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mybudget/core/errors/exceptions.dart';

class ApiClient {
  final http.Client client;
  final String baseUrl;

  ApiClient({required this.client, required this.baseUrl});

  Future<dynamic> request({
    required String method,
    required String endpoint,
    dynamic body,
    String? token,
    Map<String, String>? queryParams,
  }) async {
    final uri = Uri.parse(
      '$baseUrl$endpoint',
    ).replace(queryParameters: queryParams);

    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    http.Response response;

    switch (method.toUpperCase()) {
      case 'GET':
        response = await client.get(uri, headers: headers);
        break;
      case 'POST':
        response = await client.post(
          uri,
          headers: headers,
          body: jsonEncode(body),
        );
        break;
      case 'PUT':
        response = await client.put(
          uri,
          headers: headers,
          body: jsonEncode(body),
        );
        break;
      case 'DELETE':
        response = await client.delete(uri, headers: headers);
        break;
      default:
        throw UnsupportedError('Method $method not supported');
    }

    return _handleResponse(response);
  }

  dynamic _handleResponse(http.Response response) {
    final responseJson = jsonDecode(response.body);

    switch (response.statusCode) {
      case 200:
      case 201:
        return responseJson;
      case 400:
        throw BadRequestException(responseJson['message'] ?? 'Bad request');
      case 401:
        throw UnauthorizedException();
      case 404:
        throw NotFoundException(responseJson['message'] ?? 'Not found');
      case 500:
      default:
        throw ServerException();
    }
  }
}
