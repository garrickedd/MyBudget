// Base exception
abstract class AppException implements Exception {
  final String message;
  AppException(this.message);
}

// Các exception cụ thể
class NetworkException extends AppException {
  NetworkException() : super('Lỗi kết nối mạng');
}

class UnauthorizedException extends AppException {
  UnauthorizedException() : super('Phiên đăng nhập hết hạn');
}

class BadRequestException extends AppException {
  BadRequestException(String message) : super(message);
}

class NotFoundException extends AppException {
  NotFoundException(String message) : super(message);
}

class ServerException extends AppException {
  ServerException() : super('Lỗi máy chủ');
}

class CacheException extends AppException {
  CacheException() : super('Lỗi lưu trữ dữ liệu');
}
