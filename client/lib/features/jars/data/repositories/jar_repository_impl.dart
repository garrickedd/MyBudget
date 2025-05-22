import 'package:mybudget/core/error/exceptions.dart';
import 'package:mybudget/features/jars/data/datasources/jar_remote_datasource.dart';
import 'package:mybudget/features/jars/domain/entities/jar.dart';
import 'package:mybudget/features/jars/domain/repositories/jar_repository.dart';

class JarRepositoryImpl implements JarRepository {
  final JarRemoteDataSource remoteDataSource;

  JarRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Jar>> getUserJars(String userId) async {
    try {
      final jars = await remoteDataSource.getUserJars(userId);
      return jars
          .map(
            (model) => Jar(
              id: model.id,
              userId: model.userId,
              name: model.name,
              percentage: model.percentage,
              balance: model.balance,
              createdAt: model.createdAt,
              updatedAt: model.updatedAt,
            ),
          )
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> updateJarPercentage(int jarId, double percentage) async {
    try {
      await remoteDataSource.updateJarPercentage(jarId, percentage);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
