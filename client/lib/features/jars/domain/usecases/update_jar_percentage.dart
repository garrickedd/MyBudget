import 'package:mybudget/features/jars/domain/repositories/jar_repository.dart';

class UpdateJarPercentage {
  final JarRepository repository;

  UpdateJarPercentage(this.repository);

  Future<void> call(int jarId, double percentage) async {
    return await repository.updateJarPercentage(jarId, percentage);
  }
}
