import 'package:mybudget/features/jars/domain/entities/jar.dart';

abstract class JarRepository {
  Future<List<Jar>> getUserJars(String userId);
  Future<void> updateJarPercentage(int jarId, double percentage);
}
