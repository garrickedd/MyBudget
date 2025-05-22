import 'package:mybudget/features/jars/domain/entities/jar.dart';
import 'package:mybudget/features/jars/domain/repositories/jar_repository.dart';

class GetUserJars {
  final JarRepository repository;

  GetUserJars(this.repository);

  Future<List<Jar>> call(String userId) async {
    return await repository.getUserJars(userId);
  }
}
