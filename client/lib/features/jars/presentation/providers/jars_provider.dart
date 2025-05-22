import 'package:flutter/material.dart';
import 'package:mybudget/features/auth/presentation/providers/auth_provider.dart';
import 'package:mybudget/features/jars/data/datasources/jar_remote_datasource.dart';
import 'package:mybudget/features/jars/domain/entities/jar.dart';
import 'package:provider/provider.dart';

class JarsProvider with ChangeNotifier {
  final JarRemoteDataSource _jarRemoteDataSource;
  String? _userId;
  List<Jar> _jars = [];
  bool _isLoading = false;
  String? _errorMessage;

  JarsProvider(this._jarRemoteDataSource);

  List<Jar> get jars => _jars;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  String? get userId => _userId;
  set userId(String? value) {
    if (_userId != value) {
      _userId = value;
      notifyListeners();
    }
  }

  Future<void> fetchJars(String userId) async {
    if (_isLoading) return;

    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
      print('Fetching jars for user $userId');

      _userId = userId;
      final fetchedJars = await _jarRemoteDataSource.getUserJars(userId);
      print(
        'Fetched jars: ${fetchedJars.map((jar) => 'Jar(id: ${jar.id}, percentage: ${jar.percentage})').toList()}',
      );
      _jars = fetchedJars;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load jars: $e';
      print('Error fetching jars: $_errorMessage');
      notifyListeners();
    }
  }

  Future<void> updateJarPercentage(int jarId, double percentage) async {
    if (_isLoading) return;

    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
      print('Updating jar $jarId with percentage $percentage');

      await _jarRemoteDataSource.updateJarPercentage(jarId, percentage);
      print('Jar $jarId updated successfully');
      if (_userId != null) {
        await fetchJars(_userId!);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to update jar: $e';
      print('Error updating jar: $_errorMessage');
      notifyListeners();
    }
  }
}
