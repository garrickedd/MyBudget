// Base failure
abstract class Failure {
  final String message;
  Failure(this.message);
}

// Các failure tương ứng với exception
class NetworkFailure extends Failure {
  NetworkFailure() : super('Lỗi kết nối mạng');
}

class ServerFailure extends Failure {
  ServerFailure() : super('Lỗi máy chủ');
}

class CacheFailure extends Failure {
  CacheFailure() : super('Lỗi lưu trữ dữ liệu');
}

class ValidationFailure extends Failure {
  ValidationFailure(String message) : super(message);
}

class UnauthorizedFailure extends Failure {
  UnauthorizedFailure() : super('Phiên đăng nhập hết hạn');
}
