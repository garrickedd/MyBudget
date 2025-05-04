// define abstract class(es) error to handle error(s)
abstract class Failure {
  String get message;
}

class ServerFailure extends Failure {
  @override
  String get message => 'Server error occured';
}

class AuthFailure extends Failure {
  @override
  final String message;
  AuthFailure(this.message);
}
